//
//  HttpResponseHandler.h
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpResponseHandler : NSObject

+(void)handlerResponseObject:(id)responseObject
                successBlock:(HttpRequestSuccessBlock)successBlock
                   failBlock:(HttpRequestFailBlock)failBlock;

+(void)handlerFailWithCode:(HttpResponseCode)code
                       msg:(NSString *_Nullable)msg;

+(void)handlerFailWithError:(NSError *)error
                  failBlock:(HttpRequestFailBlock)failBlock;
@end

NS_ASSUME_NONNULL_END
