//
//  StationManager.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "Station.h"

NS_ASSUME_NONNULL_BEGIN

@interface StationModel : NSObject
@property (nonatomic, copy) NSString * stationName;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * openId;
@property (nonatomic, copy) NSString * contact;
@property (nonatomic, copy) NSString * stationNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@end

@interface StationManager : NSObject
SingleInterface(StationManager);
/**
 查询站点列表
 */
-(void)getStationWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize latitude:(double)latitude longitude:(double)longitude success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 通过城市查询站点列表
 */
-(void)getStationListWithProvince:(NSString *)province city:(NSString *)city success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
