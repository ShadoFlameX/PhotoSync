//
//  PHSNavigationBar.m
//  PhotoSync
//
//  Created by Bryan Hansen on 10/2/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSNavigationBar.h"

@implementation PHSNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor colorWithCalibratedWhite:0.1f alpha:1.0f];
        
        CGRect personRect, eventRect, calendarRect, searchRect, addRect;
        
        personRect = CGRectInset(self.bounds, 10.0f, 5.0f);
        
        CGRectDivide(personRect, &personRect, &calendarRect, 100.0f, CGRectMinXEdge);
        CGRectDivide(calendarRect, &calendarRect, &eventRect, 106.0f, CGRectMaxXEdge);
        CGRectDivide(calendarRect, &calendarRect, &searchRect, 32.0f, CGRectMinXEdge);
        CGRectDivide(searchRect, &searchRect, &addRect, 32.0f + 10.0f, CGRectMinXEdge);
        searchRect = CGRectInset(searchRect, 5.0f, 0.0f);
        
        eventRect.size.width = 100.0f;
        eventRect.origin.x = floorf((frame.size.width - eventRect.size.width) * 0.5f);
        
        self.personButton = [[TUIButton alloc] initWithFrame:personRect];
        self.personButton.titleLabel.text = @"Friends";
        self.personButton.titleLabel.font = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
        [self.personButton setTitleColor:[NSColor whiteColor] forState:TUIControlStateNormal];
        self.personButton.titleLabel.alignment = TUITextAlignmentLeft;
        self.personButton.titleEdgeInsets = TUIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        self.personButton.backgroundColor = [NSColor clearColor];

        self.eventButton = [[TUIButton alloc] initWithFrame:eventRect];
        [self.eventButton setTitle:@"Events" forState:TUIControlStateNormal];
        self.eventButton.titleLabel.font = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
        [self.eventButton setTitleColor:[NSColor grayColor] forState:TUIControlStateNormal];
        self.eventButton.titleLabel.alignment = TUITextAlignmentCenter;
        self.eventButton.titleEdgeInsets = TUIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        self.eventButton.autoresizingMask = TUIViewAutoresizingFlexibleLeftMargin | TUIViewAutoresizingFlexibleRightMargin;
        self.eventButton.backgroundColor = [NSColor clearColor];

        self.calendarButton = [[TUIButton alloc] initWithFrame:calendarRect];
        [self.calendarButton setImage:[NSImage imageNamed:@"calendar-icon"] forState:TUIControlStateNormal];
        self.calendarButton.autoresizingMask = TUIViewAutoresizingFlexibleLeftMargin;
        self.calendarButton.backgroundColor = [NSColor clearColor];
        
        self.searchButton = [[TUIButton alloc] initWithFrame:searchRect];
        [self.searchButton setImage:[NSImage imageNamed:@"search-icon"] forState:TUIControlStateNormal];
        self.searchButton.autoresizingMask = TUIViewAutoresizingFlexibleLeftMargin;
        self.searchButton.backgroundColor = [NSColor clearColor];
        
        self.addPhotosButton = [[TUIButton alloc] initWithFrame:addRect];
        [self.addPhotosButton setTitle:@"+" forState:TUIControlStateNormal];
        self.addPhotosButton.titleLabel.font = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
        [self.addPhotosButton setTitleColor:[NSColor grayColor] forState:TUIControlStateNormal];
        self.addPhotosButton.autoresizingMask = TUIViewAutoresizingFlexibleLeftMargin;
        self.addPhotosButton.backgroundColor = [NSColor clearColor];
        
        [self addSubview:self.personButton];
        [self addSubview:self.eventButton];
        [self addSubview:self.calendarButton];
        [self addSubview:self.searchButton];
        [self addSubview:self.addPhotosButton];
    }
    return self;
}

@end
