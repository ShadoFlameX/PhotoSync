//
//  PHSPanelController.m
//  PhotoSync
//
//  Created by Bryan Hansen on 8/19/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <TwUI/NSImage+TUIExtensions.h>
#import "PHSPanelController.h"
#import "PHSNavigationBar.h"
#import "PHSPhotoQuickView.h"

@interface PHSPanelController () {
    NSArray *_photos;
    TUIButton *_quitButton;
}

@property (nonatomic, strong) PHSNavigationBar *navigationBar;

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
        
        self.rootView = [[TUIView alloc] initWithFrame:bridgeView.bounds];
        self.rootView.backgroundColor = [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f];
        self.rootView.layer.cornerRadius = 5.0f;
        
        bridgeView.rootView = self.rootView;
        
        self.navigationBar = [[PHSNavigationBar alloc] initWithFrame:CGRectMake(0.0f, _rootView.bounds.size.height - 42.0f, _rootView.bounds.size.width, 42.0f)];

        self.gridView = [[PHSGridView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _rootView.bounds.size.width, _rootView.bounds.size.height - self.navigationBar.frame.size.height)];
        self.gridView.contentInset = TUIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        self.gridView.itemSize = CGSizeMake(250.0f, 250.0f);
        self.gridView.dataSource = self;

        _quitButton = [[TUIButton alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 40.0f, 20.0f)];
        _quitButton.backgroundColor = [NSColor lightGrayColor];
        _quitButton.autoresizingMask = TUIViewAutoresizingFlexibleBottomMargin;
        _quitButton.titleLabel.text = NSLocalizedString(@"Quit", nil);
        _quitButton.titleLabel.alignment = TUITextAlignmentCenter;
        [_quitButton addTarget:self action:@selector(quitApp:) forControlEvents:TUIControlEventMouseUpInside];
        
        [self.rootView addSubview:self.gridView];
        [self.rootView addSubview:self.navigationBar];
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
    [self.window becomeKeyWindow];
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
        [self.window resignKeyWindow];
        [self.window orderOut:nil];
        self.photoQuickView.image = nil;
    }];
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
    itemView.layer.contentsGravity = kCAGravityResizeAspectFill;
    itemView.layer.masksToBounds = YES;
    
    CGImageRef imageRef = ((NSImage *)[NSImage imageNamed:[NSString stringWithFormat:@"photo%ld",index % 11 + 1]]).tui_CGImage;
    
    itemView.layer.contents = (__bridge id)imageRef;
    
    return itemView;
}


#pragma mark - TUIScrollViewDelegate methods



@end


