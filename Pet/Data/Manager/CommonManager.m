//
//  CommonManager.m
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "CommonManager.h"

@implementation CommonManager
SingleImplementation(CommonManager);

/**
 申请获取短信验证码
 
 @param phoneNumber 手机号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getPhoneCodeByPhoneNumber:(NSString *)phoneNumber success:(SuccessBlock)success fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_GetPhoneCode paramers:@{@"phoneNumber":phoneNumber} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager]requestWithRequestModel:model];
}
@end
