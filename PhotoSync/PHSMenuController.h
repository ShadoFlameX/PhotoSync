//
//  PHSMenuController.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHSStatusItemView.h"

@interface PHSMenuController : NSObject <PHSStatusItemViewDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) PHSStatusItemView *statusItemView;

@end
