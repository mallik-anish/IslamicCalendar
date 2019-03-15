//
//  AniApiMethod.h
//  ApiParse
//
//  Created by Anish Mallik on 10/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AniCallApiMethodBlock)(NSData *data,NSError *error);
//typedef void(^AniCheckConnection)(NSString *message);
@interface AniApiMethod : NSObject
+(instancetype)sharedManager;

/**
Block Method Create and run GET Method without parameter
@param url URL which is call
@param AniCallApiMethodBlock Completion block which return when response comes
 
*/

-(void)callGETJSONMethodApi:(NSURL *)url completion:(AniCallApiMethodBlock)completion;

/**
 Block Method Create and run GET Method with parameter
 @param url URL which is call
 @param parameter Pass Parameter Dictionary
 @param completion Completion block which return when response comes
 
 */
-(void)callGETJSONMethodApiWithParameter:(NSURL *)url parameter:(NSDictionary *)parameter completion:(AniCallApiMethodBlock)completion;


/**
Block Method Create and run POST Method without Image parameter ßReturn Response Data or Error.
 
 @param url URL which is call
 @param parameter Pass Parameter Dictionary
 
*/

-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter completion:(AniCallApiMethodBlock)completion;

/**
 Block Method Create and run Post Method with Image
 
 @param url URL which is call
 @param parameter Pass parameter Dictionary
 @param imgData NSData pass image data as parameter
 @param forKey pass Key of image.
 */

-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter imgData:(NSData *)imgData forKey:(NSString *)forKey completion:(AniCallApiMethodBlock)completion;

/**
 Block Method Create and run Post Method with Image
 
 @param url URL which is call
 @param parameter Pass parameter Dictionary
 @param imgData NSData pass image data as parameter
 @param forKey pass Key of image.
 @param fileName pass Name of file
 @param mimeType Type of image to pass
 */

-(void)callPOSTJSONMethod:(NSURL *)url parameter:(NSMutableDictionary *)parameter imgData:(NSData *)imgData forKey:(NSString *)forKey fileName:(NSString *)fileName mimeType:(NSString *)mimeType completion:(AniCallApiMethodBlock)completion;


//-(void)checkConnection:(AniCheckConnection)completion;
@end
