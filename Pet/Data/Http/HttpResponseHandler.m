//
//  HttpResponseHandler.m
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "HttpResponseHandler.h"

@implementation HttpResponseHandler

+(void)handlerResponseObject:(id)responseObject
                successBlock:(HttpRequestSuccessBlock)successBlock
                   failBlock:(HttpRequestFailBlock)failBlock{
    HttpResponseModel * responseModel = [HttpResponseModel mj_objectWithKeyValues:responseObject];
    if (responseModel.code == HttpResponseCode_SUCCESS) {
        if (successBlock) {
            successBlock(responseModel.data, responseModel.message);
        }
    } else {
        if (failBlock) {
            failBlock(responseModel.code, responseModel.message);
        }
    }
}

+(void)handlerFailWithError:(NSError *)error
                  failBlock:(HttpRequestFailBlock)failBlock{
    if (failBlock) {
        failBlock(HttpResponseCode_CONNECT_FAIL, @"链接异常");
    }
}
@end
