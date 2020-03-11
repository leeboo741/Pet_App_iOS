//
//  PayManager.m
//  Pet
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PayManager.h"


@implementation PayManager
SingleImplementation(PayManager)
/**
 请求 微信 运输单 支付参数
 
 @param orderNo 订单编号
 @param customerNo 用户编号
 @param success 成功回调
 @param fail 失败回调
 */
 -(void)getTransportPayParamForWechatWithOrderNo:(NSString *)orderNo
                                      customerNo:(NSString *)customerNo
                                         success:(SuccessBlock)success
                                            fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"customerNo": customerNo,
        @"appType": APP_TYPE
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_GetTranportPayParamForWechat paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatPayParam * payParam = [WechatPayParam mj_objectWithKeyValues:data];
        if (success) {
            success(payParam);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 请求 微信 补价单 支付参数
 
 @param billNo 订单编号
 @param customerNo 用户编号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getPremiumPayParamForWechatWithBillNo:(NSString *)billNo
                                  customerNo:(NSString *)customerNo
                                     success:(SuccessBlock)success
                                        fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"billNo": billNo,
        @"customerNo": customerNo,
        @"appType": APP_TYPE
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_GetPremiumPayParamForWechat paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatPayParam * payParam = [WechatPayParam mj_objectWithKeyValues:data];
        if (success) {
            success(payParam);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
/**
 请求 微信 充值单 支付参数
 
 @param amount 充值金额
 @param customerNo 用户编号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getRechargePayParamForWechatWithCustomerNo:(NSString *)customerNo amount:(CGFloat)amount success:(SuccessBlock)success fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"rechargeAmount": [NSNumber numberWithDouble:amount],
        @"customerNo": customerNo,
        @"appType": APP_TYPE
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_GetPremiumPayParamForWechat paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatPayParam * payParam = [WechatPayParam mj_objectWithKeyValues:data];
        if (success) {
            success(payParam);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
@end
