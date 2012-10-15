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
#import "PHSPersonPopover.h"
#import "PHSPhotoStorageManager.h"

@interface PHSPanelController () {
    TUIButton *_quitButton;
    TUIButton *_linkButton;
}

@property (nonatomic, strong) NSArray *photoPaths;
@property (nonatomic, strong) PHSNavigationBar *navigationBar;
@property (nonatomic, strong) PHSPersonPopover *personPopover;

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
        
        TUINSView *bridgeView = [[TUINSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, self.window.frame.size.width, self.window.frame.size.height)];
        [bridgeView tui_setOpaque:NO];
        self.window.contentView = bridgeView;
        
        self.rootView = [[TUIView alloc] initWithFrame:bridgeView.bounds];
        self.rootView.backgroundColor = [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f];
        self.rootView.layer.cornerRadius = 5.0f;
        
        bridgeView.rootView = self.rootView;
        
        self.navigationBar = [[PHSNavigationBar alloc] initWithFrame:CGRectMake(0.0f, _rootView.bounds.size.height - 42.0f, _rootView.bounds.size.width, 42.0f)];
        [self.navigationBar.personButton addTarget:self action:@selector(showPersonPopover:) forControlEvents:TUIControlEventMouseUpInside];

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
        
        _linkButton = [[TUIButton alloc] initWithFrame:CGRectMake(_rootView.bounds.size.width - 60.0f , 20.0f, 40.0f, 20.0f)];
        _linkButton.backgroundColor = [NSColor lightGrayColor];
        _linkButton.autoresizingMask = TUIViewAutoresizingFlexibleBottomMargin | TUIViewAutoresizingFlexibleLeftMargin;
        _linkButton.titleLabel.text = NSLocalizedString(@"Load", nil);
        _linkButton.titleLabel.alignment = TUITextAlignmentCenter;
        [_linkButton addTarget:self action:@selector(linkClicked:) forControlEvents:TUIControlEventMouseUpInside];
        
        [self.rootView addSubview:self.gridView];
        [self.rootView addSubview:self.navigationBar];
        [self.rootView addSubview:_quitButton];
        [self.rootView addSubview:_linkButton];
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

- (void)showPersonPopover:(id)sender
{
    if (self.personPopover.shown) return;
    
    TUIViewController *viewController = [[TUIViewController alloc] init];
    
    self.personPopover = [[PHSPersonPopover alloc] initWithContentViewController:viewController];
    [self.personPopover showRelativeToRect:self.navigationBar.personButton.frame ofView:self.navigationBar preferredEdge:CGRectMinXEdge];
}

- (void)linkClicked:(id)sender
{
    [[PHSPhotoStorageManager sharedManager] authenticateWithCompletion:^(BOOL success) {
        [[PHSPhotoStorageManager sharedManager] loadPhotoPathsWithCompletion:^(NSArray *photoPaths, NSError *error) {
            self.photoPaths = photoPaths;
            [self.gridView reloadData];
            [self.gridView scrollToTopAnimated:NO];
        }];
    }];
}

- (void)quitApp:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}


#pragma mark - PHSGridViewDataSource methods

- (NSUInteger)numberOfItemsInGridView:(PHSGridView *)gridView
{
    return self.photoPaths.count;
}


- (TUIView *)gridView:(PHSGridView *)gridView itemForIndex:(NSUInteger)index
{
    TUIView *itemView = [[TUIView alloc] initWithFrame:CGRectZero];
    itemView.layer.cornerRadius = 3.0f;
    itemView.layer.contentsGravity = kCAGravityResizeAspectFill;
    itemView.layer.masksToBounds = YES;
        
    [[PHSPhotoStorageManager sharedManager] photoForPath:[self.photoPaths objectAtIndex:index] completion:^(NSImage *photo, NSError *error) {
        CGImageRef imageRef = ((NSImage *)photo).tui_CGImage;        
        itemView.layer.contents = (__bridge id)imageRef;
    }];
        
    return itemView;
}

@end


