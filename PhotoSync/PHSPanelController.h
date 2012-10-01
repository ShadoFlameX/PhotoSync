//
//  PHSPanelController.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PHSGridView.h"

@class PHSPhotoScrubber;
@class PHSPhotoQuickView;

@class PHSPanelController;
@protocol PHSPanelControllerDelegate <NSObject>
@required
- (NSPoint)originPointForPanelController:(PHSPanelController *)panelController;
@end

@interface PHSPanelController : NSWindowController <PHSGridViewDatasource>

@property (nonatomic, weak) id <PHSPanelControllerDelegate> delegate;
@property (nonatomic, strong) TUIView *rootView;
@property (nonatomic, strong) PHSGridView *gridView;
@property (nonatomic, strong) PHSPhotoScrubber *photoScrubber;
@property (nonatomic, strong) PHSPhotoQuickView *photoQuickView;

- (IBAction)openPanel:(id)sender;
- (IBAction)closePanel:(id)sender;

@end
