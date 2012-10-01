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
    TUIButton *_quitButton;
}

@end

@implementation PHSPanelController

#pragma mark - Properties

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        CGRect windowRect = CGRectMake(0, 0, 509, 600);
        
        /** Table View */
        self.window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [self.window setReleasedWhenClosed:NO];
        [self.window setMinSize:NSMakeSize(windowRect.size.width, windowRect.size.height)];
        [self.window center];
        [self.window setOpaque:NO];
        [self.window setBackgroundColor:[NSColor clearColor]];
        
        _photos = @[[NSImage imageNamed:@"photo1"],[NSImage imageNamed:@"photo2"],[NSImage imageNamed:@"photo3"],[NSImage imageNamed:@"photo4"],[NSImage imageNamed:@"photo5"],[NSImage imageNamed:@"photo6"]];
        
        TUINSView *bridgeView = [[TUINSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, self.window.frame.size.width, self.window.frame.size.height)];
        [bridgeView tui_setOpaque:NO];
        self.window.contentView = bridgeView;
        
        _rootView = [[TUIView alloc] initWithFrame:bridgeView.bounds];
        _rootView.backgroundColor = [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f];
        _rootView.layer.cornerRadius = 5.0f;
        
        bridgeView.rootView = self.rootView;
        
        _photoScrubber = [[PHSPhotoScrubber alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.rootView.frame.size.width, 64.0f)];
        [_photoScrubber addTarget:self action:@selector(updatePhotoPreview:) forControlEvents:TUIControlEventValueChanged];
        [_photoScrubber addTarget:self action:@selector(hidePhotoPreview:) forControlEvents:PHSPhotoScrubberControlEventMouseExited];
        
        NSTrackingArea *scrubberTracking = [[NSTrackingArea alloc] initWithRect:NSRectFromCGRect(_photoScrubber.frame) options:NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved owner:_photoScrubber userInfo:nil];
        [bridgeView addTrackingArea:scrubberTracking];
        
        _gridView = [[PHSGridView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, _rootView.bounds.size.width, _rootView.bounds.size.height - 64.0f)];
        _gridView.contentInset = TUIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        _gridView.itemSize = CGSizeMake(250.0f, 250.0f);
        _gridView.dataSource = self;
        
//        _photoQuickView = [[PHSPhotoQuickView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, _rootView.bounds.size.width, _rootView.bounds.size.height - 64.0f)];
//        _photoQuickView.userInteractionEnabled = NO;
        
        _quitButton = [[TUIButton alloc] initWithFrame:CGRectMake(20.0f, _rootView.bounds.size.height - 40.0f, 20.0f, 20.0f)];
        _quitButton.backgroundColor = [NSColor lightGrayColor];
        _quitButton.autoresizingMask = TUIViewAutoresizingFlexibleBottomMargin;
        _quitButton.titleLabel.text = NSLocalizedString(@"X", nil);
        _quitButton.titleLabel.alignment = TUITextAlignmentCenter;
        [_quitButton addTarget:self action:@selector(quitApp:) forControlEvents:TUIControlEventMouseUpInside];
        
//        [self.rootView addSubview:self.photoQuickView];
        [self.rootView addSubview:self.gridView];
        [self.rootView addSubview:self.photoScrubber];
        [self.rootView addSubview:_quitButton];
    }
    return self;
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
    [TUIView animateWithDuration:0.2f animations:^{
        _quitButton.alpha = 0.0f;
    }];
    
    [_photoQuickView setImage:[_photos objectAtIndex:photoScrubber.index % _photos.count] animated:YES];
}

- (void)hidePhotoPreview:(PHSPhotoScrubber *)photoScrubber
{
    [TUIView animateWithDuration:0.2f animations:^{
        _quitButton.alpha = 1.0f;
    }];
    
    [_photoQuickView setImage:nil animated:YES];
}

- (void)quitApp:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}


#pragma mark - PHSGridViewDataSource methods

- (NSUInteger)numberOfItemsInGridView:(PHSGridView *)gridView
{
    return 20;
}


- (TUIView *)gridView:(PHSGridView *)gridView itemForIndex:(NSUInteger)index
{
    TUIView *itemView = [[TUIView alloc] initWithFrame:CGRectZero];
    itemView.layer.cornerRadius = 3.0f;
    
    NSColor *color = nil;
    
    switch (index % 5) {
        case 0:
            color = [NSColor redColor];
            break;

        case 1:
            color = [NSColor greenColor];
            break;
            
        case 2:
            color = [NSColor blueColor];
            break;
            
        case 3:
            color = [NSColor orangeColor];
            break;
            
        case 4:
            color = [NSColor purpleColor];
            break;
        default:
            break;
    }
    
    itemView.backgroundColor = color;
    
    return itemView;
}



@end


