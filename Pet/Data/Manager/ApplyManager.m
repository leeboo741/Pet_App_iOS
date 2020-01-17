//
//  ApplyManager.m
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyManager.h"

@implementation ApplyStaffModel
@end
@implementation ApplyStationModel
@end

@interface ApplyManager ()

@end

@implementation ApplyManager
SingleImplementation(ApplyManager);

-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel success:(SuccessBlock)success fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStaff paramers:applyStaffModel successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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

-(void)requestStationApply:(ApplyStationModel *)applyStationModel success:(SuccessBlock)success fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStation paramers:applyStationModel successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
