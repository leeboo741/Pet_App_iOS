//
//  SiteOrderManager.h
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiteOrderManager : NSObject
SingleInterface(SiteOrderManager);

/**
 新增备注
 
 @param orderRemark 订单备注
 @param success success
 @param fail fail
 */
-(void)addOrderRemark:(OrderRemarks *)orderRemark
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;

/**
 新增补价单
 
 @param orderPremium 补价单
 @param success success
 @param fail fail
 */
-(void)addOrderPremium:(OrderPremium *)orderPremium
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;

/**
 取消补价单
 
 @param billNo 补价单号
 @param success success
 @param fail fail
 */
-(void)cancelOrderPremiumWithBillNo:(NSString *)billNo
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

/**
 获取订单未支付补价单数量
 
 @param orderNo 订单编号
 @param success success
 @param fail fail
 */
-(void)getUnpayPremiumCountWithOrderNo:(NSString *)orderNo
                               success:(SuccessBlock)success
                                  fail:(FailBlock)fail;

/**
 模糊查询点单号
 
 @param orderNo 订单号
 @param success success
 @param fail fail
 */
-(void)getOrderNoByOrderNo:(NSString *)orderNo
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail;

@end

NS_ASSUME_NONNULL_END
