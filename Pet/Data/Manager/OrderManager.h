//
//  OrderManager.h
//  下单管理
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OrderTransportType) {
    OrderTransportType_ZHUANCHE = 1, // 专车
    OrderTransportType_HUOCHE = 2, // 火车
    OrderTransportType_DANFEI = 3, // 单飞
    OrderTransportType_SUIJI = 4, // 随机
    OrderTransportType_DABA = 5, // 大巴
};

@interface PredictPriceModel: NSObject
@property (nonatomic, copy) NSString * startCity; // 开始城市
@property (nonatomic, copy) NSString * endCity; // 结束城市
@property (nonatomic, assign) OrderTransportType transportType; // 运输方式
@property (nonatomic, assign) CGFloat weight; // 重量
@property (nonatomic, assign) NSInteger num; // 数量
@property (nonatomic, copy) NSString * leaveDate; // 出发时间
@property (nonatomic, copy) NSString * petClassify; // 宠物品种
@property (nonatomic, copy) NSString * petAge; // 宠物年龄
@property (nonatomic, copy) NSString * petType; // 宠物类型
@end

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
@property (nonatomic, assign) CGFloat rate; // 费率
@end

/**
 获取城市数据回调

 @param dataList 数据列表
 @param indexList 索引列表
 */
typedef void(^GetCityDataReturnBlock)(NSArray * _Nullable dataList, NSArray * _Nullable indexList);

@interface OrderManager : NSObject
SingleInterface(OrderManager);

/**
 查询预估价格

 @param predictPriceModel 预估价格查询条件
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getPredictPriceWithModel:(PredictPriceModel *)predictPriceModel success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 查询可接受最大箱子重量

 @param startCity 开始城市
 @param endCity 目的城市
 @param type 运输类型
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getMaxPetCageWeightWithStartCity:(NSString *)startCity endCity:(NSString *)endCity transportType:(OrderTransportType)type success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 查询可用运输方式

 @param startCity 开始城市
 @param endCity 结束城市
 @param success 成功回调
 @param fail 结束回调
 */
-(void)getAbleTransportTypeWithStartCity:(NSString *)startCity endCity:(NSString *)endCity success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 通过城市获取保险费率

 @param startCity 开始城市
 @param success 成功回调
 @param fail 结束回调
 */
-(void)getInsureRateByStartCity:(NSString *)startCity success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 通过城市获取商家电话

 @param startCity 开始城市
 @param success 成功回调
 @param fail 结束回调
 */
-(void)getServicePhoneByStartCity:(NSString *)startCity success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 获取宠物类型列表

 @param success 成功回调
 @param fail 结束回调
 */
-(void)getPetTypeSuccess:(SuccessBlock)success fail:(FailBlock)fail;

/**
 获取开始城市列表

 @param keyword 关键字
 @param success 成功回调
 @param fail 结束回调
 */
-(void)getStartCityWithKeyword:(NSString *)keyword success:(GetCityDataReturnBlock)success fail:(FailBlock)fail;

/**
 获取结束城市列表

 @param startCity 开始城市
 @param keyword 关键字
 @param success 成功回调
 @param fail 结束回调
 */
-(void)getEndCityWithStartCity:(NSString *)startCity keyword:(NSString *)keyword success:(GetCityDataReturnBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
