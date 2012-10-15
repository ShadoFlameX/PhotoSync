//
//  PHSAppDelegate.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/16/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSAppDelegate.h"

@implementation PHSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.menuController = [[PHSMenuController alloc] init];
    
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
    [self.menuController.panelController.window becomeKeyWindow];
}

- (void)applicationWillResignActive:(NSNotification *)aNotification
{
//    [self.menuController.panelController closePanel:nil];
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}


#pragma mark - URL Support

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    // This gets called when the user clicks Show "App name". You don't need to do anything for Dropbox here
    
    [self.menuController.panelController openPanel:nil];

}

@end
