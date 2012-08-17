//
//  PHSStatusItemView.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/18/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSStatusItemView.h"

@implementation PHSStatusItemView

#pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.statusItem drawStatusBarBackgroundInRect:self.bounds withHighlight:self.statusItem.highlightMode];
    
    [[NSColor redColor] set];
    NSRectFill(NSInsetRect(self.bounds, 4.0f, 4.0f));
}

#pragma mark - Events

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStatusItemView:)]) {
        [self.delegate didSelectStatusItemView:self];
    }
}

@end
