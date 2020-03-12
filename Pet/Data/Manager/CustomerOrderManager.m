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
/**
 确认收货
 
 @param orderNo 订单编号
 @param success success
 @param fail fail
 */
-(void)receiverCustomerOrderWithOrderNo:(NSString *)orderNo
                                success:(SuccessBlock)success fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo":orderNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Customer_OrderConfirm paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET",@"HEAD",@"POST",@"PUT"]];
    [manager requestWithRequestModel:model];
}

/**
 确认是否有权限签收订单
 
 @param orderNo 订单编号
 @param customerNo 客户编号
 @param success success
 @param fail fail
 */
-(void)ableConfirmOrderWithOrderNo:(NSString *)orderNo
                         customrNo:(NSString *)customerNo
                           success:(SuccessBlock)success
                              fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo":orderNo,
        @"customerNo":customerNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Customer_OrderAbleConfirm paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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

/**
 取消订单
 
 @param orderNo 订单编号
 @param customerNo 客户编号
 @param success success
 @param fail fail
 */
-(void)cancelOrderWithOrderNo:(NSString *)orderNo customerNo:(NSString *)customerNo success:(SuccessBlock)success fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo":orderNo,
        @"customerNo": customerNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Customer_OrderCancel paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET",@"HEAD",@"PUT"]];
    [manager requestWithRequestModel:model];
}
/**
 评价订单
 
 @param evaluate 订单评价对象
 @param success success
 @param fail fail
 */
-(void)evaluateOrder:(OrderEvaluate *)evaluate
             success:(SuccessBlock)success
                fail:(FailBlock)fail{
    NSDictionary * dict = [evaluate mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Customer_EvaluateOrder paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    [manager  requestWithRequestModel:model];
}

/**
 模糊查询点单号
 
 @param orderNo 订单号
 @param success success
 @param fail fail
 */
-(void)getOrderNoByOrderNo:(NSString *)orderNo
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"customerNo": [[UserManager shareUserManager] getCustomerNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Customer_SearchOrder paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
