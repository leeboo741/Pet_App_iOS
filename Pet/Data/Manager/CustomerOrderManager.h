//
//  CustomerOrderManager.h
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomerSelectOrderType) {
    CustomerSelectOrderType_unpay = 0,
    CustomerSelectOrderType_unsend = 1,
    CustomerSelectOrderType_unreceiver = 2,
    CustomerSelectOrderType_complete = 3,
};

@interface CustomerOrderManager : NSObject
SingleInterface(CustomerOrderManager);
/**
 根据订单类型获取客户订单列表
 
 @param orderType 订单类型
 @param success success
 @param fail fail
 */
-(void)getCustomerOrderListByType:(CustomerSelectOrderType)orderType
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail;

/**
 编辑订单联系人
 
 @param orderNo 订单编号
 @param senderName 发件人
 @param senderPhone 发件人电话
 @param receiverName 收件人
 @param receiverPhone 收件人电话
 @param success success
 @param fail fail
 */
-(void)editCustomerOrderContactsWithOrderNo:(NSString *)orderNo
                                 senderName:(NSString *)senderName
                                senderPhone:(NSString *)senderPhone
                               receiverName:(NSString *)receiverName
                              receiverPhone:(NSString *)receiverPhone
                                    success:(SuccessBlock)success
                                       fail:(FailBlock)fail;

-(void)receiverCustomerOrderWithOrderNo:(NSString *)orderNo 
@end

NS_ASSUME_NONNULL_END
