//
//  CommonOrderManager.h
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonOrderManager : NSObject
SingleInterface(CommonOrderManager);

/**
 获取订单详情
 
 @param orderNo 订单编号
 @param success success
 @param fail fail
 */
-(void)getOrderDetailWithOrderNo:(NSString *)orderNo
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail;

/**
 获取扫描结果中的 订单编号
 
 @param scanResult 扫描结果
 @return 订单编号
 */
-(NSString *)getScanOrderNoResultWithScanResult:(NSString *)scanResult;
@end

NS_ASSUME_NONNULL_END
