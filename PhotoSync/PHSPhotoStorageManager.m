//
//  PHSPhotoStorageManager.m
//  PhotoSync
//
//  Created by Bryan Hansen on 10/8/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSPhotoStorageManager.h"

typedef void (^PhotoStorageManagerAuthCompletionBlock)(BOOL);
typedef void (^PhotoStorageManagerLoadPhotoURLsCompletionBlock)(NSArray *, NSError *);
typedef void (^PhotoStorageManagerPhotoWithPathCompletionBlock)(NSImage *photo, NSError *error);

@interface PHSPhotoStorageManager ()

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) NSString *photosHash;
@property (nonatomic, copy) PhotoStorageManagerAuthCompletionBlock authCompletionBlock;
@property (nonatomic, copy) PhotoStorageManagerLoadPhotoURLsCompletionBlock loadPhotoURLsCompletionBlock;
@property (nonatomic, strong) NSMutableDictionary *photoWithPathCompletionBlocks;

@end

@implementation PHSPhotoStorageManager

+ (PHSPhotoStorageManager *)sharedManager
{
    static PHSPhotoStorageManager *SharedManager;
    if (!SharedManager) {
        SharedManager = [[self alloc] init];
        
        SharedManager.photoWithPathCompletionBlocks = [NSMutableDictionary dictionary];
        
        NSString *appKey = @"hs4fgj52dvt7cp2";
        NSString *appSecret = @"0s9rosp4lp9pnfb";
        NSString *root = kDBRootAppFolder;
        
        DBSession *session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
        [DBSession setSharedSession:session];
        
        [[NSNotificationCenter defaultCenter] addObserver:SharedManager selector:@selector(authHelperStateDidChange:) name:DBAuthHelperOSXStateChangedNotification object:[DBAuthHelperOSX sharedHelper]];
    }
    
    return SharedManager;
}


#pragma mark - Authentication

- (void)authenticateWithCompletion:(void (^)(BOOL success))completion;
{
    self.authCompletionBlock = completion;
    
    if ([[DBSession sharedSession] isLinked]) {
        [self updateRestClient];
        self.authCompletionBlock(YES);
        
    } else {
        [[DBAuthHelperOSX sharedHelper] authenticate];
    }
}

#pragma mark - Photos

- (void)loadPhotoPathsWithCompletion:(void (^)(NSArray *photoPaths, NSError *error))completion
{
    NSAssert([DBSession sharedSession].root != kDBRootDropbox, @"kDBRootDropbox set for app.");
    
    self.loadPhotoURLsCompletionBlock = completion;
    
    [self.restClient loadMetadata:@"/" withHash:self.photosHash];
}

- (void)photoForPath:(NSString *)photoPath completion:(void (^)(NSImage *photo, NSError *error))completion
{
    [self.photoWithPathCompletionBlocks setObject:[completion copy] forKey:[photoPath lastPathComponent]];
    
    // TODO: make this work when photos in different folders have the same name
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[photoPath lastPathComponent]];
    [self.restClient loadThumbnail:photoPath ofSize:@"l" intoPath:filePath];
}


#pragma mark - Private methods

- (void)authHelperStateDidChange:(NSNotification *)notification {
    [self updateRestClient];
    self.authCompletionBlock((BOOL)self.restClient);
}

- (void)updateRestClient
{
    if ([[DBSession sharedSession] isLinked]) {
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        
    } else {
        self.restClient = nil;
    }
}


#pragma mark DBRestClientDelegate

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    self.photosHash = metadata.hash;
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }
    
    self.loadPhotoURLsCompletionBlock(newPhotoPaths, nil);
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    self.loadPhotoURLsCompletionBlock(nil, error);
    [[DBSession sharedSession] unlinkAll];
    
    if (error.code == 401) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"The DropBox access token is no longer valid. Please Try again." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    PhotoStorageManagerPhotoWithPathCompletionBlock block = [self.photoWithPathCompletionBlocks objectForKey:[destPath lastPathComponent]];
    block([[NSImage alloc] initWithContentsOfFile:destPath], nil);
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    NSLog (@"restClient:loadThumbnailFailedWithError: %@",error);
    // TODO: what can we do for failure???
}

@end
