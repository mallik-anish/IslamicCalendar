//
//  AniCheckConnection.h
//  ApiParse
//
//  Created by Anish Mallik on 17/03/15.
//  Copyright (c) 2015 Anish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AniCheckConnectionBlock)(NSString *message);

@interface AniCheckConnection : NSObject

+(instancetype)sharedManager;

/**
 Block Method  Check internetConnection
 Return String within block.
 
 */
-(void)checkConnection :(AniCheckConnectionBlock) completion;
@end
