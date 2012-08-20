//
//  PHSMenuController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSMenuController.h"

@implementation PHSMenuController

#pragma mark - Properties

@synthesize panelController =_panelController;

- (PHSPanelController *)panelController
{
    if (!_panelController) {
        _panelController = [[PHSPanelController alloc] initWithWindowNibName:@"PopupPanel"];
        _panelController.delegate = self;
    }
    
    return _panelController;
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:32.0f];
        self.statusItemView = [[PHSStatusItemView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 32.0f, [[NSStatusBar systemStatusBar] thickness])];
        self.statusItem.view = self.statusItemView;
        self.statusItemView.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

#pragma mark - PHSStatusItemView delegate methods

- (void)didSelectStatusItemView:(PHSStatusItemView *)statusItemView
{
    [self.panelController openPanel:nil];
}

#pragma mark - PHSPanelController delegate methods

- (NSPoint)originPointForPanelController:(PHSPanelController *)panelController
{
    NSRect rect = [self.statusItemView.window convertRectToScreen:self.statusItemView.frame];
    
    return NSMakePoint(rect.origin.x + floor(rect.size.width/2.0f), rect.origin.y);
}

@end
