//
//  HttpModel.h
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - HttpModel
#pragma mark -

@interface HttpModel : NSObject
@end

#pragma mark - HttpRequestModel
#pragma mark -

@class HttpResponseModel;

typedef void(^HttpRequestSuccessBlock)(id data, NSString * msg); // 成功回调
typedef void(^HttpRequestFailBlock)(NSInteger code, NSString * errorMsg); // 失败回调
typedef void(^ConstructingBodyBlock)(id<AFMultipartFormData> formData); // 上传数据回调
typedef void(^ProgressBlock)(NSProgress * progress); // 上传进度回调

typedef NS_ENUM(NSInteger, HttpRequestMethodType) {
    HttpRequestMethodType_GET = 0,
    HttpRequestMethodType_POST ,
    HttpRequestMethodType_PUT,
    HttpRequestMethodType_DELETE,
    HttpRequestMethodType_UPLOAD,
};

static NSString * HEADER_KEY_CONTENT_TYPE = @"Content-Type";
static NSString * HEADER_KEY_ACCEPT = @"Accept";

static NSString * HEADER_VALUE_APPLICATION_JSON = @"application/json";

@interface HttpRequestModel : NSObject
@property (nonatomic, assign) HttpRequestMethodType methodType;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, strong) id paramers;
@property (nonatomic, strong) NSMutableDictionary * header;
@property (nonatomic, copy) ConstructingBodyBlock constructBlock;
@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) HttpRequestSuccessBlock successBlock;
@property (nonatomic, copy) HttpRequestFailBlock failBlock;
@end

#pragma mark - HttpResponseModel
#pragma mark -

typedef NS_ENUM(NSInteger, HttpResponseCode) {
    HttpResponseCode_SUCCESS = 200, // 成功
    
    HttpResponseCode_IS_NULL_DATA = 300, // 返回数据为空
    HttpResponseCode_PARAM_ERROR = 400, // 请求参数有误
    HttpResponseCode_ERROR_PHONE = 400, // 电话号码错误
    HttpResponseCode_LOGIN_ERROR = 401, // 账号密码不能为空
    HttpResponseCode_CHECK_ERROR = 405, // 校验错误
    HttpResponseCode_NOT_EXISTS = 406, // 用户不存在
    HttpResponseCode_ACCOUNT_DISABLEED = 410, // 账号被禁用
    HttpResponseCode_ACCOUNT_ERROR = 420, // 账号密码错误
    HttpResponseCode_UPDATE_PASSWORD_ERROR = 450, // 原始密码错误
    HttpResponseCode_NAME_ALREADY_EXISTS = 460, // 名称已经存在
    HttpResponseCode_ERROR = 500, // 系统异常
    HttpResponseCode_INSERT_ERROR = 501, // 系统异常,录入失败
    HttpResponseCode_UPDATE_ERROR = 503, // 系统异常,更新失败
    HttpResponseCode_NOT_LOGIN = 504, // 请登录
    HttpResponseCode_JSON_ERROR = 600, // JSON序列化错误
    HttpResponseCode_TOKEN_ERROR = 700, // TOKEN不合法
    HttpResponseCode_TOKEN_FAIL = 701, // TOKEN失效
    HttpResponseCode_HAS_CHILD = 801, // 有子分类
    HttpResponseCode_INVAILD_TRANSPORT = 901, // 无效的运输路线
    
    HttpResponseCode_CONNECT_FAIL = 1000, // 链接失败
    
    HttpResponseCode_UNKNOW = 9000, // 未知
};

@interface HttpResponseModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) id data;
@end

NS_ASSUME_NONNULL_END
