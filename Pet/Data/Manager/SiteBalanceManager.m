//
//  SiteBalanceManager.m
//  Pet
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import "SiteBalanceManager.h"

@implementation SiteRebateFlow

@end

@implementation SiteBalanceBuffer

@end

@implementation SiteWithdrawFlow

@end

@implementation SiteBalanceManager
SingleImplementation(SiteBalanceManager);
/**
 获取站点返利流水
 
 @param stationNo 站点编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getRebateFlowWithStationNo:(NSString *)stationNo
                           offset:(NSInteger)offset
                            limit:(NSInteger)limit
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"stationNo": stationNo,
        @"offset": kIntegerNumber(offset),
        @"limit": kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_RebateFlow paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [SiteRebateFlow mj_objectArrayWithKeyValuesArray:data];
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
 获取站点 可用余额 和 冻结余额
 
 @param stationNo   站点编号
 @param success success
 @param fail fail
 */
-(void)getBalanceBufferWithStationNo:(NSString *)stationNo
                             success:(SuccessBlock)success
                                fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"stationNo":stationNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_BalanceBuffer paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        SiteBalanceBuffer * buffer = [SiteBalanceBuffer mj_objectWithKeyValues:data];
        if (success) {
            success(buffer);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 获取提现流水
 
 @param stationNo 站点编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getWithdrawFlowWithStationNo:(NSString *)stationNo
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"stationNo":stationNo,
        @"offset":kIntegerNumber(offset),
        @"limit":kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_WithdrawFlow paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [SiteWithdrawFlow mj_objectArrayWithKeyValuesArray:data];
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
 站点提现
 
 @param customerNo  客户编号
 @param amount 提现金额
 @param success success
 @param fail fail
 */
-(void)withDrawByCustomerNo:(NSString *)customerNo
                     amount:(CGFloat)amount
                    success:(SuccessBlock)success
                       fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"customerNo":customerNo,
        @"amount":kFloatNumber(amount)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Site_Withdraw paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager  * manger = [HttpManager shareHttpManager];
    manger.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST"]];
    [manger requestWithRequestModel:model];
}
@end
