//
//  PHSPanelController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPanelController.h"

@implementation PHSPanelController

#pragma mark - Properties

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
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
    [self.window makeKeyAndOrderFront:nil];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.15f;
        [[self.window animator] setAlphaValue:1.0f];
    } completionHandler:nil];
}

- (IBAction)closePanel:(id)sender
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.15f;
        [[self.window animator] setAlphaValue:0.0f];
    } completionHandler:^{
        [self.window orderOut:nil];
    }];
}

@end
