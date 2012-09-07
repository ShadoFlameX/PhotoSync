//
//  PHSPhotoQuickView.m
//  PhotoSync
//
//  Created by Bryan Hansen on 9/6/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPhotoQuickView.h"
#import <Quartz/Quartz.h>

static const CGFloat PHSPhotoQuickViewAnimationScale = 1.02f;

@interface PHSPhotoQuickView ()
@property (nonatomic, strong, readonly) TUIView *photoView;
@end

@implementation PHSPhotoQuickView

#pragma mark - Properties

@synthesize photoView = _photoView;
@synthesize image = _image;

- (void)setImage:(NSImage *)image
{
    [self setImage:image animated:NO];
}

- (void)setImage:(NSImage *)image animated:(BOOL)animated
{
    id cgImage = (id)image.tui_CGImage;
        
    if (!animated || (_image && cgImage)) {
        _photoView.layer.contents = cgImage;
        return;
    }
    
    if (image) {
        _photoView.alpha = 0.0f;
        _photoView.hidden = NO;
        
        [TUIView animateWithDuration:0.25f animations:^{
            _photoView.layer.contents = cgImage;
            _photoView.alpha = 1.0f;
            _photoView.transform = CGAffineTransformIdentity;
        }];
    } else {
        [TUIView animateWithDuration:0.35f animations:^{
            _photoView.alpha = 0.0f;
            _photoView.transform = CGAffineTransformMakeScale(PHSPhotoQuickViewAnimationScale, PHSPhotoQuickViewAnimationScale);
        } completion:^(BOOL finished) {
            _photoView.layer.contents = NULL;
            if (finished)
                _photoView.hidden = YES;
        }];
    }
    
    _image = image;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor clearColor];
        
        _photoView = [[TUIImageView alloc] initWithFrame:self.bounds];
        _photoView.autoresizingMask = TUIViewAutoresizingFlexibleWidth | TUIViewAutoresizingFlexibleHeight;
        _photoView.backgroundColor = [NSColor blackColor];
        _photoView.layer.contentsGravity = kCAGravityResizeAspect;
        _photoView.alpha = 0.0f;
        _photoView.transform = CGAffineTransformMakeScale(PHSPhotoQuickViewAnimationScale, PHSPhotoQuickViewAnimationScale);
        _photoView.hidden = YES;
        _photoView.layer.contents = NULL;
        
        [self addSubview:_photoView];
    }
    return self;
}

@end
