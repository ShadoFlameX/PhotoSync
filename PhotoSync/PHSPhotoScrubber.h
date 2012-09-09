//
//  PHSPhotoScrubber.h
//  PhotoSync
//
//  Created by Bryan Hansen on 9/5/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
    PHSPhotoScrubberControlEventMouseExited = TUIControlEventApplicationReserved <<  1
};
typedef NSUInteger PHSPhotoScrubberControlEvents;

@interface PHSPhotoScrubber : TUIControl

@property (nonatomic) NSUInteger index;

@end
