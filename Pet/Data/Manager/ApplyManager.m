//
//  ApplyManager.m
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyManager.h"

@implementation ApplyStaffModel
-(NSString *)staffName{
    return !_staffName?@"":_staffName;
}
-(NSString *)customerNo{
    return !_customerNo?@"":_customerNo;
}
-(NSString *)phone{
    return !_phone?@"":_phone;
}
-(NSString *)verificationCode{
    return !_verificationCode?@"":_verificationCode;
}
-(StationEntity *)station{
    return !_station?[[StationEntity alloc]init]:_station;
}
@end
@implementation ApplyStationModel
@end

@interface ApplyManager ()

@end

@implementation ApplyManager
SingleImplementation(ApplyManager);

/**
 请求注册 员工
 
 @param applyStaffModel 员工申请
 @param success success
 @param fail fail
 */
-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail{
    NSDictionary *dict =[applyStaffModel mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStaff paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",applyStaffModel.jsessionId];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 申请成为商家
 
 @param applyStationModel 商家申请
 @param success success
 @param fail fail
 */
-(void)requestStationApply:(ApplyStationModel *)applyStationModel
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail{
    NSDictionary * dict = [applyStationModel mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStation paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",applyStationModel.jsessionId];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
@end
