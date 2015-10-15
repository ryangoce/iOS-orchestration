//
//  RGAccountService.h
//  jumpstart
//
//  Created by Ryan Goce on 10/6/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGService.h"
#import "RGCancellationTokenSource.h"
#import "RGUser.h"

@class RGAccountService;

@protocol RGAccountServiceDelegate <NSObject>

- (void)accountService:(RGAccountService *)accountService didLoginUser:(RGUser *)user withError:(NSError *)error;
- (void)accountService:(RGAccountService *)accountService didLogoutUser:(RGUser *)user withError:(NSError *)error;

@end

@interface RGAccountService : RGService

@property (nonatomic, weak) id<RGAccountServiceDelegate> delegate;
@property (nonatomic, readonly) dispatch_queue_t delegateQueue;

-(instancetype)initWithDelegate:(id<RGAccountServiceDelegate>)delegate andDelegateQueue:(dispatch_queue_t)delegateQueue;

-(void)loginUser:(RGUser *)user withCancelToken:(RGCancelToken *)cancelToken;
-(void)logout;

@end
