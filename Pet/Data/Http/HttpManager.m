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
//SingleImplementation(HttpManager);
+(instancetype)shareHttpManager{
    return [[HttpManager alloc]init];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        self.requestSerializer.timeoutInterval = TimeOut;
        NSMutableSet *mgrSet = [NSMutableSet set];
        mgrSet.set = self.responseSerializer.acceptableContentTypes;
        [mgrSet addObject:@"text/html"];
        //因为微信返回的参数是text/plain 必须加上 会进入fail方法
        [mgrSet addObject:@"text/plain"];
        [mgrSet addObject:@"application/json"];
        self.responseSerializer.acceptableContentTypes = mgrSet;
    }
    return self;
}

#pragma mark - public method

/**
 将参数拼接到url中
 
 @param base url
 @param paramer 参数字典
 
 @return 返回的url
 */
+(NSString *)appendingUrlWithBase:(NSString *)base
                          paramer:(NSDictionary *)paramer{
   
    for (NSInteger i = 0; i < paramer.allKeys.count; i++) {
        NSString * key = paramer.allKeys[i];
        if (i == 0) {
            base = [NSString stringWithFormat:@"%@?%@=%@",base,key,[paramer objectForKey:key]];
        } else {
            base = [NSString stringWithFormat:@"%@&%@=%@",base,key,[paramer objectForKey:key]];
        }
    }
    return  base;
}

/**
发起请求

@param model 请求模型
*/
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
    __weak typeof(self) weakSelf = self;
    [self GET:model.urlStr parameters:model.paramers progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handlerSuccessWithRequestModel:model task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handlerFailWithRequestModel:model task:task error:error];
    }];
}

#pragma mark - POST

-(void)POSTRequestWithModel:(HttpRequestModel *)model{
    __weak typeof(self) weakSelf = self;
    [self POST:model.urlStr parameters:model.paramers progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handlerSuccessWithRequestModel:model task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handlerFailWithRequestModel:model task:task error:error];
    }];
}

#pragma mark - PUT

-(void)PUTRequestWithModel:(HttpRequestModel *)model{
    __weak typeof(self) weakSelf = self;
    [self PUT:model.urlStr parameters:model.paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handlerSuccessWithRequestModel:model task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handlerFailWithRequestModel:model task:task error:error];
    }];
}

#pragma mark - DELETE

-(void)DELETERequestWithModel:(HttpRequestModel *)model{
    __weak typeof(self) weakSelf = self;
    [self DELETE:model.urlStr parameters:model.paramers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handlerSuccessWithRequestModel:model task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handlerFailWithRequestModel:model task:task error:error];
    }];
}

#pragma mark - UPLOAD

-(void)UPLOADRequestWithModel:(HttpRequestModel *)model{
    __weak typeof(self) weakSelf = self;
    [self POST:model.urlStr parameters:model.paramers constructingBodyWithBlock:model.constructBlock progress:model.progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handlerSuccessWithRequestModel:model task:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handlerFailWithRequestModel:model task:task error:error];
    }];
}


#pragma mark - private method

-(void)handlerSuccessWithRequestModel:(HttpRequestModel *)requestModel task:(NSURLSessionDataTask * _Nonnull)task responseObject:(id _Nullable)responseObject{
    if (requestModel.jsessionid_return_block) {
        requestModel.jsessionid_return_block([self getCookiesWithUrl:requestModel.urlStr]);
    }
    if (!requestModel.useDefaultHandler) {
        if (requestModel.successBlock) {
            requestModel.successBlock(responseObject, @"自定义解析");
        }
    } else {
        [HttpResponseHandler handlerResponseObject:responseObject
                                      successBlock:requestModel.successBlock
                                         failBlock:requestModel.failBlock];
    }
}

-(void)handlerFailWithRequestModel:(HttpRequestModel *)requestModel task:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error {
    if (requestModel.jsessionid_return_block) {
        requestModel.jsessionid_return_block([self getCookiesWithUrl:requestModel.urlStr]);
    }
    [HttpResponseHandler handlerFailWithError:error
                                    failBlock:requestModel.failBlock];
}

-(NSString *)getCookiesWithUrl:(NSString *)url{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    NSString * JSESSIONID = nil;
    for (NSHTTPCookie*cookie in cookies) {
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            JSESSIONID = cookie.value;
        }
    }
    return JSESSIONID;
}

-(void)addHeader:(HttpRequestModel *)model{
    if (kDictIsEmpty(model.header)) {
        return;
    }
    for (NSString * key in model.header.allKeys) {
        [self.requestSerializer setValue:model.header[key] forHTTPHeaderField:key];
    }
}

@end
