//
//  PHSPanelController.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PHSPanelController;
@protocol PHSPanelControllerDelegate <NSObject>
@required
- (NSPoint)originPointForPanelController:(PHSPanelController *)panelController;
@end

@interface PHSPanelController : NSWindowController

@property (nonatomic, weak) id <PHSPanelControllerDelegate> delegate;

- (IBAction)openPanel;
- (IBAction)closePanel;

@end
