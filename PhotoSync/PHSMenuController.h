//
//  PHSMenuController.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHSStatusItemView.h"
#import "PHSPanelController.h"

@interface PHSMenuController : NSObject <PHSStatusItemViewDelegate,PHSPanelControllerDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) PHSStatusItemView *statusItemView;
@property (nonatomic, strong, readonly) PHSPanelController *panelController;

@end
