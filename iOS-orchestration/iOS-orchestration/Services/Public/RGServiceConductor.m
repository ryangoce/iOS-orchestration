//
//  RGServiceConductor.m
//  jumpstart
//
//  Created by Ryan Goce on 10/6/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGServiceConductor.h"

#import "GCDMulticastDelegate.h"

//list of services the conductor know
#import "RGAccountService.h"
#import "RGUploadService.h"

@interface RGServiceConductor ()<RGAccountServiceDelegate, RGUploadServiceDelegate>

@property (nonatomic, strong) RGAccountService *accountService;
@property (nonatomic, strong) RGUploadService *uploadService;
@property (nonatomic) id multicastDelegate;

@end

@implementation RGServiceConductor

#pragma mark - Shared Instance
static RGServiceConductor *sharedInstance;
+ (RGServiceConductor *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[RGServiceConductor alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark - init
-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.multicastDelegate = [[GCDMulticastDelegate alloc]init];
        
        self.accountService = [[RGAccountService alloc]initWithDelegate:self andDelegateQueue:nil];
        self.uploadService = [[RGUploadService alloc]initWithDelegate:self andDelegateQueue:nil];
    }
    
    return self;
}

#pragma mark - public methods
-(void)loginUser:(RGUser *)user withCancelToken:(RGCancelToken *)cancelToken {
    [self.accountService loginUser:user withCancelToken:cancelToken];
}

-(void)logout {
    [self.accountService logout];
}

-(void)uploadFileFrom:(NSURL *)fromUrl toUrl:(NSURL *)toUrl withId:(NSString *__autoreleasing *)uploadId cancelToken:(RGCancelToken *)cancelToken {
    [self.uploadService uploadFileFrom:fromUrl toUrl:toUrl withId:uploadId cancelToken:cancelToken];
}

#pragma mark - subscribe/unsubscribe methods
-(void)addDelegate:(id<RGServiceConductorDelegate>)delegate usingDelegateQueue:(dispatch_queue_t)delegateQueue {
    @synchronized(self) {
        [self.multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    }
}

-(void)removeDelegate:(id<RGServiceConductorDelegate>)delegate usingDelegateQueue:(dispatch_queue_t)delegateQueue {
    @synchronized(self) {
        [self.multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    }
}

#pragma mark - RGAccountServiceDelegate
-(void)accountService:(RGAccountService *)accountService didLoginUser:(RGUser *)user withError:(NSError *)error {
    
    //start uploads for the user
    [self.uploadService startAllUploadsForUser:user];
    
    @synchronized (self) {
        [self.multicastDelegate serviceConductor:self didLoginUser:user withError:error];
    }
}

-(void)accountService:(RGAccountService *)accountService didLogoutUser:(RGUser *)user withError:(NSError *)error {
    //stop all pending uploads
    [self.uploadService stopAllUploads];
    
    @synchronized (self) {
        [self.multicastDelegate serviceConductor:self didLogoutUser:user withError:error];
    }
}

#pragma mark - RGUploadServiceDelegate
-(void)uploadService:(RGUploadService *)uploadService didStartAllUploadsForUserId:(NSNumber *)userId {
    
}

-(void)uploadService:(RGUploadService *)uploadService didUploadFileWithId:(NSString *)fileId {
    
}

-(void)uploadServiceDidStopAllUploads:(RGUploadService *)uploadService {
    
}

@end
