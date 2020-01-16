//
//  OrderManager.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface CityModel : NSObject
@property (nonatomic, copy) NSString * cityName; // 名称
@property (nonatomic, copy) NSString * cityPinYin; // 全拼
@property (nonatomic, copy) NSString * cityPY; // 首字母
@property (nonatomic, copy) NSString * first; // 第一个字母
@end

static NSString * City_Body_Key = @"cityBody";
static NSString * City_Index_Key = @"cityIndex";

@interface InsureRateModel : NSObject
@property (nonatomic, strong, nullable) id station;
@property (nonatomic, copy, nullable) NSString * insureNo;
@property (nonatomic, assign) CGFloat insureAmount;
@property (nonatomic, assign) CGFloat rate;
@end

typedef NS_ENUM(NSInteger, OrderTransportType) {
    OrderTransportType_ZHUANCHE = 1, // 专车
    OrderTransportType_HUOCHE = 2, // 火车
    OrderTransportType_DANFEI = 3, // 单飞
    OrderTransportType_SUIJI = 4, // 随机
    OrderTransportType_DABA = 5, // 大巴
};

// 获取城市数据回调
// dataList 数据列表
// index 索引列表
typedef void(^GetCityDataReturnBlock)(NSArray * _Nullable dataList, NSArray * _Nullable indexList);

@interface OrderManager : NSObject
SingleInterface(OrderManager);
/**
 查询最大箱子重量
 */
-(void)getMaxPetCageWeightWithStartCity:(NSString *)startCity endCity:(NSString *)endCity transportType:(OrderTransportType)type success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 查询可用运输方式
 */
-(void)getAbleTransportTypeWithStartCity:(NSString *)startCity endCity:(NSString *)endCity success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 通过城市获取保险费率
 */
-(void)getInsureRateByStartCity:(NSString *)startCity success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 通过城市获取商家电话
 */
-(void)getServicePhoneByStartCity:(NSString *)startCity success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 获取宠物类型
 */
-(void)getPetTypeSuccess:(SuccessBlock)success fail:(FailBlock)fail;
/**
 获取起始城市
 */
-(void)getStartCityWithKeyword:(NSString *)keyword success:(GetCityDataReturnBlock)success fail:(FailBlock)fail;
/**
 获取目的城市
 */
-(void)getEndCityWithStartCity:(NSString *)startCity keyword:(NSString *)keyword success:(GetCityDataReturnBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
