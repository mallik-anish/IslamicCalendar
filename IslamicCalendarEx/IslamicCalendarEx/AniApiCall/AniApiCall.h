//
//  AniApiCall.h
//  ApiParse
//
//  Created by Anish Mallik on 10/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^apiParseR)(NSData *data, NSError *error);

@interface AniApiCall : NSObject

/**
 Method to call API using NSURLSession
 
 @param url Pass Request
 
 */
-(instancetype)reteriveWithoutParamJSONData:(NSMutableURLRequest *)urlRequest completion:(apiParseR)completionBlock;
@end
