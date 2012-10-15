//
//  PHSPersonPopover.m
//  PhotoSync
//
//  Created by Bryan Hansen on 10/2/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPersonPopover.h"

@implementation PHSPersonPopover

- (id)initWithContentViewController:(TUIViewController *)viewController
{
    self = [super initWithContentViewController:viewController];
    if (self) {
        self.contentSize = CGSizeMake(320.0f, 400.0f);
        self.behaviour = TUIPopoverViewControllerBehaviourTransient;
    }
    return self;
}

@end
