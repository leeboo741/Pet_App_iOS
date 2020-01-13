//
//  OrderManager.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderManager.h"

@interface OrderManager ()
@property (nonatomic, strong) NSArray * petTypes;
@property (nonatomic, strong) NSArray * startCitys;
@property (nonatomic, strong) NSArray * endCitys;
@end

@implementation OrderManager
SingleImplementation(OrderManager);

-(void)getStartCitySuccess:(SuccessBlock)success fail:(FailBlock)fail{
    if (self.startCitys) {
        if (success) {
            success(self.startCitys);
        }
    } else {
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_StartCity paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
}

-(void)getEndCityWithStartCity:(NSString *)startCity Success:(SuccessBlock)success fail:(FailBlock)fail{
    if (self.endCitys) {
        if (success) {
            success(self.endCitys);
        }
    } else {
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_EndCity paramers:@{@"startCity":startCity} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
}

-(void)getPetTypeSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    if (self.petTypes) {
        if (success) {
            success(self.petTypes);
        }
    } else {
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Pet_Type paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            if (success) {
                success(data);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            [[HttpManager shareHttpManager]handlerFailWithCode:code msg:errorMsg];
            if (fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    }
    
}
@end
