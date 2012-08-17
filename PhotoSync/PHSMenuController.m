//
//  PHSMenuController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSMenuController.h"

@implementation PHSMenuController

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
    NSLog(@"didSelectStatusItemView");
}

@end
