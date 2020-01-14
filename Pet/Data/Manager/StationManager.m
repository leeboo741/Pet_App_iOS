//
//  StationManager.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "StationManager.h"

@interface StationManager ()

@end

@implementation StationManager
SingleImplementation(StationManager);
-(void)getStationWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize latitude:(double)latitude longitude:(double)longitude success:(SuccessBlock)success fail:(FailBlock)fail{
        NSDictionary * paramers = @{
                                    @"latitude": @(latitude),
                                    @"longitude": @(longitude),
                                    @"limit":@(pageSize),
                                    @"offset":@(pageIndex)
                                    };
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Staion_List paramers:paramers successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            NSArray * stationArray = [Station mj_objectArrayWithKeyValuesArray:data];
            if (success) {
                success(stationArray);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            [[HttpManager shareHttpManager]handlerFailWithCode:code msg:errorMsg];
            if (fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
@end
