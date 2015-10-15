//
//  RGLoginViewController.m
//  jumpstart
//
//  Created by Ryan Goce on 10/6/15.
//  Copyright (c) 2015 Ryan Goce. All rights reserved.
//

#import "RGLoginViewController.h"
#import "RGServiceConductor.h"

@interface RGLoginViewController ()<RGServiceConductorDelegate>

@property (nonatomic, readonly) RGServiceConductor *serviceConductor;

@end

@implementation RGLoginViewController

-(RGServiceConductor *)serviceConductor {
    return [RGServiceConductor sharedInstance];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.serviceConductor addDelegate:self usingDelegateQueue:dispatch_get_main_queue()];
    }
    
    return self;
}

-(void)dealloc {
    [self.serviceConductor removeDelegate:self usingDelegateQueue:dispatch_get_main_queue()];
}

-(void)tappedLogin:(UIButton *)sender {
    RGUser *user = [RGUser new];
    user.username = self.textUsername.text;
    user.password = self.textPassword.text;
    
    [self.serviceConductor loginUser:user withCancelToken:nil];
    
    [self.activityIndicator startAnimating];
    self.textUsername.enabled = self.textPassword.enabled = NO;
}

#pragma mark - RGServiceConductorDelegate
-(void)serviceConductor:(RGServiceConductor *)serviceConductor didLoginUser:(RGUser *)user withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    self.textUsername.enabled = self.textPassword.enabled = YES;
    
    if (error) {
        //TODO: Show alert message
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"User %@ successfully logged in!", user.username];
        
        [[[UIAlertView alloc]initWithTitle:@"Success!" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]show];
        
        //TODO: show main page
    }
}

@end
