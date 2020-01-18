//
//  StationManager.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "StationManager.h"

@implementation StationModel
@end

@interface StationManager ()
@property (nonatomic, strong) NSMutableDictionary * stationListByCityDict;
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
            if (fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
-(void)getStationListWithProvince:(NSString *)province city:(NSString *)city success:(SuccessBlock)success fail:(FailBlock)fail{
    NSString * dictKey = [NSString stringWithFormat:@"%@-%@",province,city];
    id result = [self.stationListByCityDict objectForKey:dictKey];
    if (result) {
        if (success) {
            success(result);
        }
    } else {
        NSDictionary * paramers = @{
                                    @"province":province,
                                    @"city":city
                                    };
        __weak typeof(self) weakSelf = self;
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_StatonListByCity paramers:paramers successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            NSArray * resultArray = [StationModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf.stationListByCityDict setObject:resultArray forKey:dictKey];
            if (success) {
                success(resultArray);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            if (fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    }
}

#pragma mark - setters and getters

-(NSMutableDictionary *)stationListByCityDict{
    if (!_stationListByCityDict) {
        _stationListByCityDict = [NSMutableDictionary dictionary];
    }
    return _stationListByCityDict;
}
@end
