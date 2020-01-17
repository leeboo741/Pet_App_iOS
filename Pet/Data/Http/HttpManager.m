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

-(void)handlerFailWithCode:(HttpResponseCode)code msg:(NSString *)msg{
    switch (code) {
        case HttpResponseCode_IS_NULL_DATA: {
            [MBProgressHUD showErrorMessage:@"返回数据为空"];
        }
            break;
        case HttpResponseCode_PARAM_ERROR: {
            [MBProgressHUD showErrorMessage:@"请求参数有误"];
        }
            break;
        case HttpResponseCode_LOGIN_ERROR: {
            [MBProgressHUD showErrorMessage:@"账号密码不能为空"];
        }
            break;
        case HttpResponseCode_CHECK_ERROR: {
            [MBProgressHUD showErrorMessage:@"校验错误"];
        }
            break;
        case HttpResponseCode_NOT_EXISTS: {
            [MBProgressHUD showErrorMessage:@"用户不存在"];
        }
            break;
        case HttpResponseCode_ACCOUNT_DISABLEED: {
            [MBProgressHUD showErrorMessage:@"账号被禁用"];
        }
            break;
        case HttpResponseCode_ACCOUNT_ERROR: {
            [MBProgressHUD showErrorMessage:@"账号密码错误"];
        }
            break;
        case HttpResponseCode_UPDATE_PASSWORD_ERROR: {
            [MBProgressHUD showErrorMessage:@"原始密码错误"];
        }
            break;
        case HttpResponseCode_NAME_ALREADY_EXISTS: {
            [MBProgressHUD showErrorMessage:@"名称已经存在"];
        }
            break;
        case HttpResponseCode_ERROR: {
            [MBProgressHUD showErrorMessage:@"系统异常"];
        }
            break;
        case HttpResponseCode_INSERT_ERROR: {
            [MBProgressHUD showErrorMessage:@"系统异常,录入失败"];
        }
            break;
        case HttpResponseCode_UPDATE_ERROR: {
            [MBProgressHUD showErrorMessage:@"系统异常,更新失败"];
        }
            break;
        case HttpResponseCode_NOT_LOGIN: {
            [MBProgressHUD showErrorMessage:@"请登录"];
        }
            break;
        case HttpResponseCode_JSON_ERROR: {
            [MBProgressHUD showErrorMessage:@"JSON序列化错误"];
        }
            break;
        case HttpResponseCode_TOKEN_ERROR: {
            [MBProgressHUD showErrorMessage:@"TOKEN不合法"];
        }
            break;
        case HttpResponseCode_TOKEN_FAIL: {
            [MBProgressHUD showErrorMessage:@"TOKEN失效"];
        }
            break;
        case HttpResponseCode_HAS_CHILD: {
            [MBProgressHUD showErrorMessage:@"有子分类"];
        }
            break;
        case HttpResponseCode_INVAILD_TRANSPORT: {
            [MBProgressHUD showErrorMessage:@"无效的运输路线"];
        }
            break;
        case HttpResponseCode_CONNECT_FAIL: {
            [MBProgressHUD showErrorMessage:@"链接失败"];
        }
            break;
        case HttpResponseCode_UNKNOW: {
            [MBProgressHUD showErrorMessage:@"未知错误"];
        }
            break;
        default: {
            [MBProgressHUD showErrorMessage:@"未知错误"];
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
