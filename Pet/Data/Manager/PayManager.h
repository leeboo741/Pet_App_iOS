//
//  PayManager.h
//  Pet
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "WechatManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface PayManager : NSObject
SingleInterface(PayManager)

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
                                           fail:(FailBlock)fail;

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
                                        fail:(FailBlock)fail;
/**
 请求 微信 充值单 支付参数
 
 @param amount 充值金额
 @param customerNo 用户编号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getRechargePayParamForWechatWithCustomerNo:(NSString *)customerNo amount:(CGFloat)amount success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
