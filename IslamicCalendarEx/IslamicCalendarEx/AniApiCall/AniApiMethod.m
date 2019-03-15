//
//  AniApiMethod.m
//  ApiParse
//
//  Created by Anish Mallik on 10/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import "AniApiMethod.h"
#import "Reachability.h"
#import "AniApiCall.h"
#import "AppDelegate.h"
#import "AniView.h"
#import "AniCheckConnection.h"
static NSString *boundary = @"0xKhTmLbOuNdArY";
static NSString * AniCreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}


NSTimer *timer;
NSMutableURLRequest *request;
@implementation AniApiMethod

+(instancetype)sharedManager
{
    static AniApiMethod *ltapi=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        ltapi=[[AniApiMethod alloc] init];
    });
    return ltapi;
}

#pragma mark - GET METHODS

-(void)callGETJSONMethodApi:(NSURL *)url  completion:(AniCallApiMethodBlock)completion{

   // AniView *vw=[[AniView alloc] init];
    
    [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
        
        if(![message isEqualToString:@"NoAccess"])
        {
            
            [[AniApiCall alloc] reteriveWithoutParamJSONData:[self getJSONRequestWithOutParam:url] completion:^(NSData *data, NSError *error) {
                
                if(completion)
                {
                   // [vw removeSubview];
                    completion(data,error);
                }
                
            }];
        }
        else
        {
           // [vw addView];
           // [vw addSubview:[self getLabel:vw]];
            
        }
   
    }];

}

-(void)callGETJSONMethodApiWithParameter:(NSURL *)url parameter:(NSMutableDictionary *)parameter completion:(AniCallApiMethodBlock)completion
{
  [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
        if(![message isEqualToString:@"NoAccess"])
        {
             [[AniApiCall alloc] reteriveWithoutParamJSONData:[self getJSONRequestWithParam:url param:parameter] completion:^(NSData *data, NSError *error) {
                 
                 if(completion)
                 {
                     completion(data,error);
                 }
                 
             }];
        }
  }];

}


-(NSString *)generateParam :(NSMutableDictionary *)param
{
    NSMutableString *paramData = [[NSMutableString alloc] init];
    NSArray *fields = [param allKeys];
    
    if (fields.count == 0) return paramData;
    for (NSString *field in fields) {
        NSString *value = [param objectForKey:field];
        [paramData appendFormat:@"%@=%@&", field, value];
    }
    
    return [paramData substringToIndex:[paramData length] - 1];
}

-(NSMutableURLRequest *)getJSONRequestWithOutParam:(NSURL *)url
{
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300];
    [self setRequest];
    return request;
}


-(NSMutableURLRequest *)getJSONRequestWithParam : (NSURL *)url param:(NSMutableDictionary *)dicParam
{
    NSString *urlStr=[[NSString stringWithFormat:@"%@",url] stringByAppendingString:[self generateParam:dicParam]];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300];
    [self setRequest];
    
    return request;
}
-(void)setRequest
{
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

}

#pragma mark -----------------


#pragma mark POST METHOD

-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter completion:(AniCallApiMethodBlock)completion
{
    [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
        
       
        if (![message isEqualToString:@"NoAccess"]) {
            
            
            [[AniApiCall alloc] reteriveWithoutParamJSONData:[self getPOSTJSONRequestwithoutImage:url parameter:parameter] completion:^(NSData *data, NSError *error) {
                if(completion)
                {
                    completion(data,error);
                }
            }];
        }
        
    }];
    
}

-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter imgData:(NSData *)imgData forKey:(NSString *)forKey completion:(AniCallApiMethodBlock)completion
{
    [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
        
        if (![message isEqualToString:@"NoAccess"]) {
             NSMutableArray *ary=[self addData:imgData forKey:forKey mimeType:@"" fileName:@""];
            [[AniApiCall alloc] reteriveWithoutParamJSONData:[self getPOSTJSONRequestwithoutImage:url parameter:parameter aryImage:ary] completion:^(NSData *data, NSError *error) {
                if(completion)
                {
                    completion(data,error);
                }
            }];
        }
        
    }];
    
}
-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter imgData:(NSData *)imgData forKey:(NSString *)forKey fileName:(NSString *)fileName mimeType:(NSString *)mimeType completion:(AniCallApiMethodBlock)completion
{
    [[AniCheckConnection sharedManager] checkConnection:^(NSString *message) {
        
        if (![message isEqualToString:@"NoAccess"]) {
              NSMutableArray *ary=[self addData:imgData forKey:forKey mimeType:mimeType fileName:fileName];
            [[AniApiCall alloc] reteriveWithoutParamJSONData:[self getPOSTJSONRequestwithoutImage:url parameter:parameter aryImage:ary] completion:^(NSData *data, NSError *error) {
                if(completion)
                {
                    completion(data,error);
                }
            }];
        }
        
    }];
    
}

// pass all image data requirement which return array

-(NSMutableArray *) addData:(NSData*) data forKey:(NSString*) key mimeType:(NSString*) mimeType fileName:(NSString*) fileName {
    
    NSMutableArray *aryImage=[[NSMutableArray alloc] init];
    if([mimeType isEqualToString:@""] && [fileName isEqualToString:@""])
    {
        mimeType=@"image/jpeg";
        fileName=@"image.jpg";
    }
    NSDictionary *dict = @{@"data": data,
                           @"name": key,
                           @"mimetype": mimeType,
                           @"filename": fileName};
    
    [aryImage addObject:dict];
    
    return aryImage;
    
}

// return request for parameter without image data

-(NSMutableURLRequest *)getPOSTJSONRequestwithoutImage:(NSURL *)url parameter:(NSMutableDictionary *)dicParam
{
    request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
   
    [self setPOSTParam:dicParam dicImage:nil];
    
    return request;
}

// return request for parameter with image data

-(NSMutableURLRequest *)getPOSTJSONRequestwithoutImage:(NSURL *)url parameter:(NSMutableDictionary *)dicParam aryImage:(NSMutableArray *)aryImage
{
     request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    [self setPOSTParam:dicParam dicImage:aryImage];

    return request;
}


// set Post Main Requirement
-(void)setPOSTParam:(NSMutableDictionary *)dicParam dicImage:(NSMutableArray *)dicImage
{
    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
      NSString *boundary =AniCreateMultipartFormBoundary();
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *dataPost=[NSMutableData data];
    
    if(dicParam!=nil)
    {
        [dicParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSString *stringParam=[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",boundary,key,obj];
            [dataPost appendData:[stringParam dataUsingEncoding:NSUTF8StringEncoding]];
            [dataPost appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }

    if(dicImage!=nil)
    {
        [dicImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dataDic=(NSDictionary *)obj;
            NSString *fieldString = [NSString stringWithFormat:
                                         @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                         boundary,
                                         dataDic[@"name"],
                                         dataDic[@"filename"],
                                         dataDic[@"mimetype"]];
            [dataPost appendData:[fieldString dataUsingEncoding:NSUTF8StringEncoding]];
            [dataPost appendData:dataDic[@"data"]];
            [dataPost appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            
        }];
    }
    [dataPost appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary]
    forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [dataPost length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataPost];
    
    
}



/*
 TIMER IS CALLED WHEN INTERNET GET LOST, IT GET INVALIDATE WHEN INTERNET APPEAR
 */
-(void)callTimerToCheckConnection
{
//   NSString *str=[self checkNetworkConnectivity];
 
//    if([str isEqualToString:@"NoAccess"])
//    {
//        timer= [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(callTimerToCheckConnection) userInfo:nil repeats:YES];
//    }
//    else
//    {
//        [timer invalidate];
//        timer=nil;
//    }
}

-(UILabel *)getLabel :(AniView *)vw
{
    UILabel *lbl=[[UILabel alloc] initWithFrame:vw.frame];
    lbl.text=@"No Internet Found";
    lbl.textAlignment=NSTextAlignmentCenter;
    return lbl;
}

//-(void)checkConnection:(AniCheckConnection)completion{
//    
//    NSString *netStr = [self checkNetworkConnectivity];
//    if(completion)
//    {
//        completion(netStr);
//    }
//}
//
///*
// check Connectivity it return status
// */
//-(NSString *)checkNetworkConnectivity
//{
//    
//    
//    
//    
//    NSString *networkValue;
//    
//    Reachability *rc = [Reachability reachabilityWithHostName:@"www.google.com"];
//    NetworkStatus internetStatus = [rc currentReachabilityStatus];
//    
//    if(internetStatus==0)
//    {
//        networkValue = @"NoAccess";
//    }
//    else if(internetStatus==1)
//    {
//        networkValue = @"ReachableViaWiFi";
//        
//    } else if(internetStatus==2)
//    {
//        networkValue = @"ReachableViaWWAN";
//    }
//    else  //if(internetStatus>2)
//    {
//        networkValue = @"Reachable";
//    }
//    
//    return networkValue;
//}

@end
