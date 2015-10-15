//
//  RGUploadService.h
//  jumpstart
//
//  Created by Ryan Goce on 10/8/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGService.h"
#import "RGUser.h"
#import "RGCancellationTokenSource.h"

@class RGUploadService;

@protocol RGUploadServiceDelegate <NSObject>

-(void)uploadService:(RGUploadService *)uploadService didUploadFileWithId:(NSString *)fileId;
-(void)uploadService:(RGUploadService *)uploadService didStartAllUploadsForUserId:(NSNumber *)userId;
-(void)uploadServiceDidStopAllUploads:(RGUploadService *)uploadService;

@end

@interface RGUploadService : RGService

@property (nonatomic, weak) id<RGUploadServiceDelegate> delegate;
@property (nonatomic, readonly) dispatch_queue_t delegateQueue;

-(instancetype)initWithDelegate:(id<RGUploadServiceDelegate>)delegate andDelegateQueue:(dispatch_queue_t)delegateQueue;

-(void)startAllUploadsForUser:(RGUser *)user;
-(void)stopAllUploads;

-(void)uploadFileFrom:(NSURL *)fromUrl toUrl:(NSURL *)toUrl withId:(NSString **)uploadId cancelToken:(RGCancelToken *)cancelToken;

@end
