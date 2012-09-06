//
//  PHSPanelController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPanelController.h"
#import "PHSPhotoScrubber.h"
#import "PHSPhotoQuickView.h"

@interface PHSPanelController () {
    NSArray *_photos;
}

@end

@implementation PHSPanelController

#pragma mark - Properties

@synthesize rootView = _rootView;
@synthesize photoScrubber = _photoScrubber;
@synthesize photoQuickView = _photoQuickView;

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    
    _photos = @[[NSImage imageNamed:@"photo1"],[NSImage imageNamed:@"photo2"],[NSImage imageNamed:@"photo3"],[NSImage imageNamed:@"photo4"],[NSImage imageNamed:@"photo5"],[NSImage imageNamed:@"photo6"],[NSImage imageNamed:@"photo7"]];
    
    TUINSView *bridgeView = [[TUINSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, self.window.frame.size.width, self.window.frame.size.height)];
    [bridgeView tui_setOpaque:NO];
    self.window.contentView = bridgeView;
    
    _rootView = [[TUIView alloc] initWithFrame:bridgeView.bounds];
    _rootView.backgroundColor = [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f];
    _rootView.layer.cornerRadius = 5.0f;
    
    bridgeView.rootView = self.rootView;
    
    _photoScrubber = [[PHSPhotoScrubber alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.rootView.frame.size.width, 64.0f)];
    [_photoScrubber addTarget:self action:@selector(updatePhotoPreview:) forControlEvents:TUIControlEventValueChanged];
    [_photoScrubber addTarget:self action:@selector(hidePhotoPreview:) forControlEvents:TUIControlEventMouseUpInside];
    
    _photoQuickView = [[PHSPhotoQuickView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, _rootView.bounds.size.width, _rootView.bounds.size.height - 64.0f)];
    
    [self.rootView addSubview:self.photoScrubber];
    [self.rootView addSubview:self.photoQuickView];
}

#pragma mark - Actions

- (IBAction)openPanel:(id)sender
{
    NSPoint origin = [self.delegate originPointForPanelController:self];
    origin.x -= floor(self.window.frame.size.width / 2.0f);
    origin.y -= self.window.frame.size.height + 10.0f;
    NSRect rect = NSMakeRect(origin.x, origin.y, self.window.frame.size.width, self.window.frame.size.height);
    
    [NSApp activateIgnoringOtherApps:NO];
    [self.window setAlphaValue:0.0f];
    [self.window setFrame:rect display:YES];
    [NSApp arrangeInFront:sender];
    [self.window orderFrontRegardless];
    [NSApp activateIgnoringOtherApps:YES];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.1f;
        [[self.window animator] setAlphaValue:1.0f];
    } completionHandler:nil];
}

- (IBAction)closePanel:(id)sender
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.2f;
        [[self.window animator] setAlphaValue:0.0f];
    } completionHandler:^{
        [self.window orderOut:nil];
        self.photoQuickView.image = nil;
    }];
}

- (void)updatePhotoPreview:(PHSPhotoScrubber *)photoScrubber
{
    [_photoQuickView setImage:[_photos objectAtIndex:photoScrubber.index % _photos.count] animated:YES];
}

- (void)hidePhotoPreview:(PHSPhotoScrubber *)photoScrubber
{
    [_photoQuickView setImage:nil animated:YES];
}

@end


