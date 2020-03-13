//
//  BusinessBalanceManager.m
//  Pet
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BusinessBalanceManager.h"

@implementation BusinessRebate

@end

@implementation BusinessBalanceBuffer

@end

@implementation BusinessWithdrawFlow

@end

@implementation BusinessBalanceManager
SingleImplementation(BusinessBalanceManager);
/**
 获取商家返利流水
 
 @param businessNo 商家编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getRebateFlowWithBusinessNo:(NSString *)businessNo
                           offset:(NSInteger)offset
                            limit:(NSInteger)limit
                          success:(SuccessBlock)success
                              fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"businessNo": businessNo,
        @"offset": kIntegerNumber(offset),
        @"limit": kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Station_RebateFlow paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [BusinessRebate mj_objectArrayWithKeyValuesArray:data];
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
 获取商家 可用余额 和 冻结余额
 
 @param businessNo 商家编号
 @param success success
 @param fail fail
 */
-(void)getBalanceBufferWithBusinessNo:(NSString *)businessNo
                             success:(SuccessBlock)success
                                 fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"businessNo":businessNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Station_BalanceBuffer paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        BusinessBalanceBuffer * buffer = [BusinessBalanceBuffer mj_objectWithKeyValues:data];
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
 
 @param businessNo 商家编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getWithdrawFlowWithBusinessNo:(NSString *)businessNo
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                            success:(SuccessBlock)success
                                fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"businessNo":businessNo,
        @"offset":kIntegerNumber(offset),
        @"limit":kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Station_WithdrawFlow paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [BusinessWithdrawFlow mj_objectArrayWithKeyValuesArray:data];
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
 商家提现
 
 @param businessNo 商家编号
 @param amount 提现金额
 @param success success
 @param fail fail
 */
-(void)withDrawByBusinessNo:(NSString *)businessNo
                     amount:(CGFloat)amount
                    success:(SuccessBlock)success
                       fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"businessNo":businessNo,
        @"amount":kFloatNumber(amount)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Station_Withdraw paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
