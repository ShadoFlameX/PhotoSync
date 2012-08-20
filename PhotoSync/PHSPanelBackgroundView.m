//
//  PHSPanelBackgroundView.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/20/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPanelBackgroundView.h"

@implementation PHSPanelBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor darkGrayColor] set];
    NSRectFill(self.bounds);
}

@end
