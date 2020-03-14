//
//  SiteOrderManager.m
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "SiteOrderManager.h"
@implementation InOrOutPortRequestParam
-(NSString *)staffNo{
    if (!_staffNo) {
        _staffNo = [[UserManager shareUserManager] getStaffNo];
    }
    return _staffNo;
}
-(NSString *)stationNo{
    if (!_stationNo) {
        _stationNo = [[UserManager shareUserManager] getStationNo];
    }
    return _stationNo;
}
-(NSString *)orderNo{
    return !_orderNo?@"":_orderNo;
}
-(NSMutableArray<NSString *> *)orderTypeArray{
    if (!_orderTypeArray) {
        _orderTypeArray = [NSMutableArray array];
    }
    return _orderTypeArray;
}
-(NSString *)startOrderTime{
    return !_startOrderTime?@"":_startOrderTime;
}
-(NSString *)endOrderTime{
    return !_endOrderTime?@"":_endOrderTime;
}
-(NSString *)startLeaveTime{
    return !_startLeaveTime?@"":_startLeaveTime;
}
-(NSString *)endLeaveTime{
    return !_endLeaveTime?@"":_endLeaveTime;
}

@end

@implementation SiteOrderManager
SingleImplementation(SiteOrderManager);
/**
 新增备注
 
 @param orderRemark 订单备注
 @param success success
 @param fail fail
 */
-(void)addOrderRemark:(OrderRemarks *)orderRemark
              success:(SuccessBlock)success
                 fail:(FailBlock)fail{
    NSDictionary * dict = [orderRemark mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Site_AddOrderRemark paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 新增补价单
 
 @param orderPremium 补价单
 @param success success
 @param fail fail
 */
-(void)addOrderPremium:(OrderPremium *)orderPremium
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    NSDictionary * dict = [orderPremium mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_AddPremium paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 取消补价单
 
 @param billNo 补价单号
 @param success success
 @param fail fail
 */
-(void)cancelOrderPremiumWithBillNo:(NSString *)billNo
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_PUT Url:URL_Site_CancelPremium paramers:@{@"billNo":billNo} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
获取订单未支付补价单数量

@param orderNo 订单编号
@param success success
@param fail fail
*/
-(void)getUnpayPremiumCountWithOrderNo:(NSString *)orderNo
                               success:(SuccessBlock)success
                                  fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_GetUnpayPremiumCount paramers:@{@"orderNo":orderNo} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
        @"staffNo": [[UserManager shareUserManager] getStaffNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_SearchOrder paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 获取出入港单
 
 @param param 请求参数
 @param success success
 @param fail fail
 */
-(void)getInOrOutPortOrderWithParam:(InOrOutPortRequestParam *)param
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"queryParamStr": [param mj_JSONString]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_OrderListByOrderNo paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<OrderEntity *> * array = [OrderEntity mj_objectArrayWithKeyValuesArray:data];
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
 获取对应状态 站点所有订单
 
 @param state 站点订单状态
 @param offset 下标
 @param limit 铲毒
 @param success success
 @param fail fail
 */
-(void)getSiteAllOrderByState:(SiteOrderState)state
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"stationNo": [[UserManager shareUserManager] getStationNo],
        @"state": [self getSiteOrderStateStringWithState:state],
        @"offset":kIntegerNumber(offset),
        @"limit":kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_OrderListAllByState paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<OrderEntity *> * array = [OrderEntity mj_objectArrayWithKeyValuesArray:data];
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
 修改订单价格
 
 @param order 订单对象
 @param success success
 @param fail fail
 */
-(void)updateOrderPrice:(OrderEntity *)order
                success:(SuccessBlock)success
                   fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_PUT Url:URL_Site_UpdateOrderPrice paramers:[order mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    [manager requestWithRequestModel:model];
}

/**
 获取站点订单状态 对应 字符串
 
 @param state 站点订单状态
 @return 对应字符串
 */
-(NSString *)getSiteOrderStateStringWithState:(SiteOrderState)state{
    switch (state) {
        case SiteOrderState_All:
            return @"全部";
        case SiteOrderState_ToPay:
            return @"待付款";
        case SiteOrderState_ToPack:
            return @"待揽件";
        case SiteOrderState_ToInport:
            return @"待入港";
        case SiteOrderState_Inport:
            return @"已入港";
        case SiteOrderState_ToOutport:
            return @"待出港";
        case SiteOrderState_Outport:
            return @"已出港";
        case SiteOrderState_ToArrived:
            return @"待到达";
        case SiteOrderState_Arrived:
            return @"已到达";
        case SiteOrderState_Delivering:
            return @"派送中";
        case SiteOrderState_ToSign:
            return @"待签收";
        case SiteOrderState_Completed:
            return @"已完成";
        case SiteOrderState_UnKnow:
            return @"未知";
    }
}

/**
 获取站点订单状态
 
 @param stateString 状态对应字符串
 @return 站点订单状态
 */
-(SiteOrderState)getSiteOrderStateByString:(NSString *)stateString{
    if ([[self getSiteOrderStateStringWithState:SiteOrderState_All] isEqualToString:stateString]) {
        return SiteOrderState_All;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToPay] isEqualToString:stateString]) {
        return SiteOrderState_ToPay;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToPack] isEqualToString:stateString]) {
        return SiteOrderState_ToPack;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToInport] isEqualToString:stateString]) {
        return SiteOrderState_ToInport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Inport] isEqualToString:stateString]) {
        return SiteOrderState_Inport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToOutport] isEqualToString:stateString]) {
        return SiteOrderState_ToOutport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Outport] isEqualToString:stateString]) {
        return SiteOrderState_Outport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToArrived] isEqualToString:stateString]) {
        return SiteOrderState_ToArrived;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Arrived] isEqualToString:stateString]) {
        return SiteOrderState_Arrived;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Delivering] isEqualToString:stateString]) {
        return SiteOrderState_Delivering;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToSign] isEqualToString:stateString]) {
        return SiteOrderState_ToSign;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Completed] isEqualToString:stateString]) {
        return SiteOrderState_Completed;
    } else
        return SiteOrderState_UnKnow;
}

@end
