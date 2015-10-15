//
//  RGUploadService.m
//  jumpstart
//
//  Created by Ryan Goce on 10/8/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGUploadService.h"
#import "RGService+Protected.h"
#import "NSString+Extensions.h"

@interface RGUploadService ()

@property (nonatomic) dispatch_queue_t delegateQueue;

@end

@implementation RGUploadService

-(instancetype)initWithDelegate:(id<RGUploadServiceDelegate>)delegate andDelegateQueue:(dispatch_queue_t)delegateQueue {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.delegateQueue = delegateQueue;
    }
    
    return self;
}

-(void)startAllUploadsForUser:(RGUser *)user {
    [self scheduleBlock:^{
        //TODO: Do actual upload
        sleep(5);
    }];
}

-(void)stopAllUploads {
    [self scheduleBlock:^{
        //TODO: Do actual stop
        sleep(1);
    }];
}

-(void)uploadFileFrom:(NSURL *)fromUrl toUrl:(NSURL *)toUrl withId:(NSString *__autoreleasing *)uploadId cancelToken:(RGCancelToken *)cancelToken {
    
    //assign the unique id first
    NSString *uuid = [NSString uuid];
    *uploadId = uuid;
    
    [self scheduleBlock:^{
        //TODO: Do actual stop
        
        sleep(3);
        
        [self dispatchBlockInDelegateQueue:^{
            [self.delegate uploadService:self didUploadFileWithId:uuid];
        }];
    }];
}

-(void)dispatchBlockInDelegateQueue:(dispatch_block_t)block {
    dispatch_queue_t queue = self.delegateQueue ? self.delegateQueue : dispatch_get_main_queue();
    dispatch_async(queue, block);
}

@end
