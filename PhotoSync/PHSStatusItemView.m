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
    
    NSImage *icon = self.isHighlighted ? [NSImage imageNamed:@"icon"] : [NSImage imageNamed:@"icon"];
    CGFloat iconX = round((NSWidth(self.bounds) - icon.size.width) / 2);
    CGFloat iconY = round((NSHeight(self.bounds) - icon.size.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    [icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

#pragma mark - Events

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStatusItemView:)]) {
        [self.delegate didSelectStatusItemView:self];
    }
}

@end
