//
//  PHSAppDelegate.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/16/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PHSMenuController.h"

@interface PHSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) PHSMenuController *menuController;

@end
