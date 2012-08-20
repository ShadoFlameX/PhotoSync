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
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    self.menuController = nil;
    return NSTerminateNow;
}

@end
