//
//  AniCheckConnection.m
//  ApiParse
//
//  Created by Anish Mallik on 17/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import "AniCheckConnection.h"
#import "Reachability.h"
@implementation AniCheckConnection

+(instancetype)sharedManager
{
    static AniCheckConnection *checkCon;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        checkCon=[[AniCheckConnection alloc] init];
    });
    
    return checkCon;
}

-(void)checkConnection:(AniCheckConnectionBlock)completion
{

    NSString *netStr = [self checkNetworkConnectivity];
    if(completion)
    {
        completion(netStr);
    }
    
}
-(NSString *)checkNetworkConnectivity
{


    NSString *networkValue;
    
    Reachability *rc = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [rc currentReachabilityStatus];
    
    if(internetStatus==0)
    {
        networkValue = @"NoAccess";
    }
    else if(internetStatus==1)
    {
        networkValue = @"ReachableViaWiFi";
        
    } else if(internetStatus==2)
    {
        networkValue = @"ReachableViaWWAN";
    }
    else  //if(internetStatus>2)
    {
        networkValue = @"Reachable";
    }
    
    return networkValue;
}

@end
