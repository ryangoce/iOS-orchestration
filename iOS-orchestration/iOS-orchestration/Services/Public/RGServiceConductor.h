//
//  RGServiceConductor.h
//  jumpstart
//
//  Created by Ryan Goce on 10/6/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGUser.h"
#import "RGCancellationTokenSource.h"

@class RGServiceConductor;

@protocol RGServiceConductorDelegate <NSObject>

@optional
-(void)serviceConductor:(RGServiceConductor *)serviceConductor didLoginUser:(RGUser *)user withError:(NSError *)error;
-(void)serviceConductor:(RGServiceConductor *)serviceConductor didLogoutUser:(RGUser *)user withError:(NSError *)error;

@end

@interface RGServiceConductor : NSObject

+(RGServiceConductor *)sharedInstance;

-(void)loginUser:(RGUser *)user withCancelToken:(RGCancelToken *)cancelToken;
-(void)logout;
-(void)uploadFileFrom:(NSURL *)fromUrl toUrl:(NSURL *)toUrl withId:(NSString **)uploadId cancelToken:(RGCancelToken *)cancelToken;

-(void)addDelegate:(id<RGServiceConductorDelegate>)delegate usingDelegateQueue:(dispatch_queue_t)delegateQueue;
-(void)removeDelegate:(id<RGServiceConductorDelegate>)delegate usingDelegateQueue:(dispatch_queue_t)delegateQueue;

@end
