//
//  PHSPhotoQuickView.h
//  PhotoSync
//
//  Created by Bryan Hansen on 9/6/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <TwUI/TUIKit.h>

@interface PHSPhotoQuickView : TUIView

@property (nonatomic, strong) NSImage *image;

- (void)setImage:(NSImage *)image animated:(BOOL)animated;

@end
