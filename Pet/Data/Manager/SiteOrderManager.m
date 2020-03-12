//
//  SiteOrderManager.m
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "SiteOrderManager.h"

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
@end
