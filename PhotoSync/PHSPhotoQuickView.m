//
//  PHSPhotoQuickView.m
//  PhotoSync
//
//  Created by Bryan Hansen on 9/6/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPhotoQuickView.h"

@interface PHSPhotoQuickView ()
@property (nonatomic, strong, readonly) TUIImageView *imageView;
@end

@implementation PHSPhotoQuickView

#pragma mark - Properties

@synthesize imageView = _imageView;

- (NSImage *)image
{
    return _imageView.image;
}

- (void)setImage:(NSImage *)image
{
    [self setImage:image animated:NO];
}

- (void)setImage:(NSImage *)image animated:(BOOL)animated
{
    if (_imageView.image == image)
        return;
    
    if (!animated || (_imageView.image && image)) {
        _imageView.image = image;
        return;
    }
    
    if (image) {
        _imageView.alpha = 0.0f;
        _imageView.hidden = NO;
        
        [TUIView animateWithDuration:0.35f animations:^{
            _imageView.image = image;
            _imageView.alpha = 1.0f;
        }];
    } else {
        [TUIView animateWithDuration:0.5f animations:^{
            _imageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            _imageView.image = image;
            _imageView.hidden = YES;
        }];
    }
}

#pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor clearColor];
        
        _imageView = [[TUIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = TUIViewAutoresizingFlexibleWidth | TUIViewAutoresizingFlexibleHeight;
        _imageView.backgroundColor = [NSColor blackColor];
        _imageView.contentMode = TUIViewContentModeScaleAspectFit;
        _imageView.alpha = 0.0f;
        _imageView.hidden = YES;
        
        [self addSubview:_imageView];
    }
    return self;
}

@end
