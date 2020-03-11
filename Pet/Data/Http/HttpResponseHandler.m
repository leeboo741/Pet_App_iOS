//
//  HttpResponseHandler.m
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "HttpResponseHandler.h"
//#import "LoginViewController.h"
//#import "RegisterViewController.h"

@implementation HttpResponseHandler

+(void)handlerResponseObject:(id)responseObject
                successBlock:(HttpRequestSuccessBlock)successBlock
                   failBlock:(HttpRequestFailBlock)failBlock{
    MSLog(@"Response ==> \n%@", [responseObject mj_JSONString]);
    HttpResponseModel * responseModel = [HttpResponseModel mj_objectWithKeyValues:responseObject];
    if (responseModel.code == HttpResponseCode_SUCCESS) {
        if (successBlock) {
            successBlock(responseModel.data, responseModel.message);
        }
    } else {
        [HttpResponseHandler handlerFailWithCode:responseModel.code msg:responseModel.message];
        if (failBlock) {
            failBlock(responseModel.code, responseModel.message);
        }
    }
}

+(void)handlerFailWithError:(NSError *)error
                  failBlock:(HttpRequestFailBlock)failBlock{
    
    [MBProgressHUD hideHUD];
    [HttpResponseHandler handlerFailWithCode:HttpResponseCode_CONNECT_FAIL msg:@"链接异常"];
    if (failBlock) {
        failBlock(HttpResponseCode_CONNECT_FAIL, @"链接异常");
    }
}

+(void)handlerFailWithCode:(HttpResponseCode)code msg:(NSString *_Nullable)msg{
    [MBProgressHUD hideHUD];
    switch (code) {
        case HttpResponseCode_IS_NULL_DATA: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"返回数据为空"];
        }
            break;
        case HttpResponseCode_PARAM_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"请求参数有误"];
        }
            break;
        case HttpResponseCode_LOGIN_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"账号密码不能为空"];
        }
            break;
        case HttpResponseCode_CHECK_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"校验错误"];
        }
            break;
        case HttpResponseCode_NOT_EXISTS: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"用户不存在"];
        }
            break;
        case HttpResponseCode_ACCOUNT_DISABLEED: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"账号被禁用"];
        }
            break;
        case HttpResponseCode_ACCOUNT_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"账号密码错误"];
        }
            break;
        case HttpResponseCode_UPDATE_PASSWORD_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"原始密码错误"];
        }
            break;
        case HttpResponseCode_NAME_ALREADY_EXISTS: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"名称已经存在"];
        }
            break;
        case HttpResponseCode_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"系统异常"];
        }
            break;
        case HttpResponseCode_INSERT_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"系统异常,录入失败"];
        }
            break;
        case HttpResponseCode_UPDATE_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"系统异常,更新失败"];
        }
            break;
        case HttpResponseCode_NOT_LOGIN: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"请登录"];
        }
            break;
        case HttpResponseCode_JSON_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"JSON序列化错误"];
        }
            break;
        case HttpResponseCode_TOKEN_ERROR: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"TOKEN不合法"];
        }
            break;
        case HttpResponseCode_TOKEN_FAIL: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"TOKEN失效"];
        }
            break;
        case HttpResponseCode_HAS_CHILD: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"有子分类"];
        }
            break;
        case HttpResponseCode_INVAILD_TRANSPORT: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"无效的运输路线"];
        }
            break;
        case HttpResponseCode_CONNECT_FAIL: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"链接失败"];
        }
            break;
        case HttpResponseCode_UNKNOW: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"未知错误"];
        }
            break;
        default: {
            [HttpResponseHandler showErrorMsg:msg placeholderMsg:@"未知错误"];
        }
            break;
    }
}
+(void)showErrorMsg:(NSString *)msg placeholderMsg:(NSString *)placeholderMsg{
    if (kStringIsEmpty(msg)) {
        [MBProgressHUD showTipMessageInWindow:placeholderMsg];
    } else {
        [MBProgressHUD showTipMessageInWindow:msg];
    }
}
@end
