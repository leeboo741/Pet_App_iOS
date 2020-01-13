//
//  HttpManager.h
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "HttpResponseHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSInteger code);

@interface HttpManager : AFHTTPSessionManager
SingleInterface(HttpManager);
-(void)requestWithRequestModel:(HttpRequestModel *)model;
-(void)handlerFailWithCode:(HttpResponseCode)code msg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
