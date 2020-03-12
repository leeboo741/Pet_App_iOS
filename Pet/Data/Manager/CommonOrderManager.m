//
//  CommonOrderManager.m
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CommonOrderManager.h"

@implementation CommonOrderManager
SingleImplementation(CommonOrderManager);

/**
 获取订单详情
 
 @param orderNo 订单编号
 @param success success
 @param fail fail
 */
-(void)getOrderDetailWithOrderNo:(NSString *)orderNo
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"customerNo": [[UserManager shareUserManager] getCustomerNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Order_Detail paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        OrderEntity * orderEntity = [OrderEntity mj_objectWithKeyValues:data];
        if (success) {
            success(orderEntity);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 获取扫描结果中的 订单编号
 
 @param scanResult 扫描结果
 @return 订单编号
 */
-(NSString *)getScanOrderNoResultWithScanResult:(NSString *)scanResult{
    NSDictionary * dict = Util_GetUrlParamDict(scanResult);
    if (kDictIsEmpty(dict)) {
        return nil;
    } else {
        NSString * type = [dict objectForKey:@"type"];
        NSString * orderNo = [dict objectForKey:@"orderno"];
        NSString * scanType = @"scan";
        if (!kStringIsEmpty(type) && !kStringIsEmpty(orderNo) && [scanType isEqualToString:@"type"]) {
            return orderNo;
        }
        return nil;
    }
}
@end
