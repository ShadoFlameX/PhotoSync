//
//  PHSPhotoStorageManager.h
//  PhotoSync
//
//  Created by Bryan Hansen on 10/8/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxOSX/DropboxOSX.h>

@interface PHSPhotoStorageManager : NSObject <DBRestClientDelegate>

+ (PHSPhotoStorageManager *)sharedManager;

- (void)authenticateWithCompletion:(void (^)(BOOL success))completion;
- (void)loadPhotoPathsWithCompletion:(void (^)(NSArray *photoPaths, NSError *error))completion;
- (void)photoForPath:(NSString *)photoPath completion:(void (^)(NSImage *photo, NSError *error))completion;

@end
