//
//  CustomerOrderManager.m
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CustomerOrderManager.h"

@implementation CustomerOrderManager
SingleImplementation(CustomerOrderManager);
/**
 根据订单类型获取订单列表
 @param orderType 订单类型
 @param success success
 @param fail fail
 */
-(void)getCustomerOrderListByType:(CustomerSelectOrderType)orderType
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail{
    NSString * orderStatus = @"待付款";
    switch (orderType) {
        case CustomerSelectOrderType_unpay:
            orderStatus = @"待付款";
            break;
        case CustomerSelectOrderType_unsend:
            orderStatus = @"待发货";
            break;
        case CustomerSelectOrderType_unreceiver:
            orderStatus = @"待收货";
            break;
        case CustomerSelectOrderType_complete:
            orderStatus = @"已完成";
            break;
    }
    NSDictionary * dict = @{
        @"orderStatus":orderStatus,
        @"customerNo":[[UserManager shareUserManager]getCustomerNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Customer_GetOrderListByStatus paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [OrderEntity mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(array);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

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
                                       fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo":orderNo,
        @"senderName":senderName,
        @"senderPhone":senderPhone,
        @"receiverName":receiverName,
        @"receiverPhone":receiverPhone
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Customer_EditOrderContacts paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
@end
