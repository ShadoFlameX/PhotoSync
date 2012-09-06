//
//  PHSPanelController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPanelController.h"
#import "PHSPhotoScrubber.h"

@implementation PHSPanelController

#pragma mark - Properties

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    TUINSView *bridgeView = self.window.contentView;
    
    self.rootView = [[TUIView alloc] initWithFrame:bridgeView.bounds];
    self.rootView.backgroundColor = [NSColor colorWithDeviceWhite:0.3f alpha:1.0f];
    
    bridgeView.rootView = self.rootView;
    
    self.photoScrubber = [[PHSPhotoScrubber alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.rootView.frame.size.width, 48.0f)];
    
    [self.rootView addSubview:self.photoScrubber];
}

#pragma mark - Actions

- (IBAction)openPanel:(id)sender
{
    NSPoint origin = [self.delegate originPointForPanelController:self];
    origin.x -= floor(self.window.frame.size.width / 2.0f);
    origin.y -= self.window.frame.size.height + 10.0f;
    NSRect rect = NSMakeRect(origin.x, origin.y, self.window.frame.size.width, self.window.frame.size.height);
    
    [NSApp activateIgnoringOtherApps:NO];
    [self.window setAlphaValue:0.0f];
    [self.window setFrame:rect display:YES];
    [NSApp arrangeInFront:sender];
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.1f;
        [[self.window animator] setAlphaValue:1.0f];
    } completionHandler:nil];
}

- (IBAction)closePanel:(id)sender
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.2f;
        [[self.window animator] setAlphaValue:0.0f];
    } completionHandler:^{
        [self.window orderOut:nil];
    }];
}

@end


