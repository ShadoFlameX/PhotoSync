//
//  PHSPhotoScrubber.m
//  PhotoSync
//
//  Created by Bryan Hansen on 9/5/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPhotoScrubber.h"

@interface PHSPhotoScrubber ()
@property (nonatomic, strong) TUIImageView *backgroundView;
@end

@implementation PHSPhotoScrubber

#pragma mark - Properties

@synthesize backgroundView = _backgroundView;

#pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor colorWithCalibratedWhite:0.1f alpha:1.0f];
        _backgroundView = [[TUIImageView alloc] initWithImage:[NSImage imageNamed:@"scrubber-background"]];
        CGRect bgRect = _backgroundView.frame;
        bgRect.origin.y = 0.0f;
        _backgroundView.frame = bgRect; 
        
        _backgroundView.backgroundColor = [NSColor clearColor];
        [self addSubview:_backgroundView];
    }
    
    return self;
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    CGPoint point = [_backgroundView convertFromWindowPoint:[theEvent locationInWindow]];
    if ([_backgroundView pointInside:point]) {
        _index = (NSUInteger)point.x / 20;
        [self sendActionsForControlEvents:TUIControlEventValueChanged];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self sendActionsForControlEvents:PHSPhotoScrubberControlEventMouseExited];
}

@end
