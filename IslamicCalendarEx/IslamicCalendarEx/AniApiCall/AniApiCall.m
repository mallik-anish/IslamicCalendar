//
//  AniApiCall.m
//  ApiParse
//
//  Created by Anish Mallik on 10/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import "AniApiCall.h"
#import "AniCheckConnection.h"
@interface fetchApi : AniApiCall
@property(strong,nonatomic)NSMutableURLRequest *url;
@property(strong,nonatomic)NSMutableURLRequest *request;
@end
@implementation fetchApi

-(void)fetchApiDetial:(apiParseR)completionBlock
{
    static NSURLSession *session;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        session=[NSURLSession sessionWithConfiguration:config];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
            
            
            if(![message isEqualToString:@"NoAccess"])
            {
                
                NSURLSessionDataTask *task=[session dataTaskWithRequest:self.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    
                    if(completionBlock)
                    {
                        completionBlock(data,error);
                    }
                    
                }];
                [task resume];
            }
        }];
    });
}

@end

@implementation AniApiCall

-(instancetype)reteriveWithoutParamJSONData:(NSMutableURLRequest *)urlRequest completion:(apiParseR)completionBlock
{
    fetchApi *fetchData;
    fetchData=[[fetchApi alloc] init];
    if(fetchData)
    {
        fetchData.url=urlRequest;
        [fetchData fetchApiDetial:completionBlock];
    }
    return fetchData;
    
}

@end
