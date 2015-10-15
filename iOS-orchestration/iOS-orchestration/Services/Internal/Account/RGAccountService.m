//
//  RGAccountService.m
//  jumpstart
//
//  Created by Ryan Goce on 10/6/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGAccountService.h"
#import "RGService+Protected.h"


//error definitions
//error domain name
#define ERROR_DOMAIN @"com.saperium.jumpstart"

//error codes. RGAccountService is assigned the 100 series for codes
#define ERROR_CODE_LOGIN_CANCELED   100


@interface RGAccountService ()

@property (nonatomic) dispatch_queue_t delegateQueue;

@end

@implementation RGAccountService

-(instancetype)initWithDelegate:(id<RGAccountServiceDelegate>)delegate andDelegateQueue:(dispatch_queue_t)delegateQueue {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.delegateQueue = delegateQueue;
    }
    
    return self;
}

-(void)loginUser:(RGUser *)user withCancelToken:(RGCancelToken *)cancelToken {
    [self scheduleBlock:^{
        
        if (cancelToken) {
            cancelToken.cancellationRequestedBlock = ^() {
                if (self.delegate) {
                    
                    [self dispatchBlockInDelegateQueue:^{
                        //TODO: Think of the best way to localize error messages
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"login was canceled", NSLocalizedDescriptionKey, nil];
                        
                        NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_LOGIN_CANCELED userInfo:userInfo];
                        
                        [self.delegate accountService:self didLoginUser:user withError:error];
                    }];
                    
                }
            };
        }
        
        //simulate a HTTP call by sleeping
        sleep(1.5);
        
        if (!cancelToken.isCanceled) {
            //successfully logged in the user
            [self dispatchBlockInDelegateQueue:^{
                [self.delegate accountService:self didLoginUser:user withError:nil];
            }];
        }
        
    }];
}

-(void)logout {
    [self scheduleBlock:^{
        //TODO: Do logout
        
        [self dispatchBlockInDelegateQueue:^{
            [self.delegate accountService:self didLogoutUser:nil withError:nil];
            
        }];
    }];
}

-(void)dispatchBlockInDelegateQueue:(dispatch_block_t)block {
    dispatch_queue_t queue = self.delegateQueue ? self.delegateQueue : dispatch_get_main_queue();
    dispatch_async(queue, block);
}

@end
