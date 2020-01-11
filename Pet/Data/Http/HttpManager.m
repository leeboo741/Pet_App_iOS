//
//  HttpManager.m
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "HttpManager.h"

#pragma mark - HttpManager
#pragma mark -

@interface HttpManager ()

@end

static CGFloat TimeOut = 20.0f; // 超时时间

@implementation HttpManager
SingleImplementation(HttpManager);
-(instancetype)init{
    self = [super init];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = TimeOut;
    }
    return self;
}

#pragma mark - public method

-(void)requestWithRequestModel:(HttpRequestModel *)model{
    [self addHeader:model];
    switch (model.methodType) {
        case HttpRequestMethodType_GET:
        {
            [self GETRequsetWithModel:model];
        }
            break;
        case HttpRequestMethodType_PUT:
        {
            [self PUTRequestWithModel:model];
        }
            break;
        case HttpRequestMethodType_POST:
        {
            [self POSTRequestWithModel:model];
        }
            break;
        case HttpRequestMethodType_DELETE:
        {
            [self DELETERequestWithModel:model];
        }
            break;
        case HttpRequestMethodType_UPLOAD:
        {
            [self UPLOADRequestWithModel:model];
        }
            break;
            
        default:
        {
            [MBProgressHUD showErrorMessage:@"未知的MethodType"];
        }
            break;
    }
}

#pragma mark - GET

-(void)GETRequsetWithModel:(HttpRequestModel *)model{
    [self GET:model.urlStr parameters:model.paramers progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:model.successBlock
                                         failBlock:model.failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpResponseHandler handlerFailWithError:error
                                        failBlock:model.failBlock];
    }];
}

#pragma mark - POST

-(void)POSTRequestWithModel:(HttpRequestModel *)model{
    [self POST:model.urlStr parameters:model.paramers progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:model.successBlock
                                         failBlock:model.failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpResponseHandler handlerFailWithError:error
                                        failBlock:model.failBlock];
    }];
}

#pragma mark - PUT

-(void)PUTRequestWithModel:(HttpRequestModel *)model{
    [self PUT:model.urlStr parameters:model.paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:model.successBlock
                                         failBlock:model.failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpResponseHandler handlerFailWithError:error
                                        failBlock:model.failBlock];
    }];
}

#pragma mark - DELETE

-(void)DELETERequestWithModel:(HttpRequestModel *)model{
    [self DELETE:model.urlStr parameters:model.paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:model.successBlock
                                         failBlock:model.failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpResponseHandler handlerFailWithError:error
                                        failBlock:model.failBlock];
    }];
}

#pragma mark - UPLOAD

-(void)UPLOADRequestWithModel:(HttpRequestModel *)model{
    [self POST:model.urlStr parameters:model.paramers constructingBodyWithBlock:model.constructBlock progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:model.successBlock
                                         failBlock:model.failBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpResponseHandler handlerFailWithError:error
                                        failBlock:model.failBlock];
    }];
}


#pragma mark - private method

-(void)addHeader:(HttpRequestModel *)model{
    if (kDictIsEmpty(model.header)) {
        return;
    }
    for (NSString * key in model.header.allKeys) {
        [self.requestSerializer setValue:model.header[key] forHTTPHeaderField:key];
    }
}

@end
