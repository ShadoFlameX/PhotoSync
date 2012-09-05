//
//  PHSStatusItemView.h
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PHSStatusItemView;

@protocol PHSStatusItemViewDelegate <NSObject>
- (void)didSelectStatusItemView:(PHSStatusItemView *)statusItemView;
@end

@interface PHSStatusItemView : NSView

@property (nonatomic, weak) id <PHSStatusItemViewDelegate> delegate;
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;

@end
