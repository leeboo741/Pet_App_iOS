//
//  Station.h
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface StationContact : NSObject
@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * phoneNumber;

@end

@interface Station : NSObject
@property (nonatomic, copy) NSString * stationName; // 驿站名称
@property (nonatomic, copy) NSString * stationId; // 驿站Id
@property (nonatomic, copy) NSString * businessStartTime; // 开始时间
@property (nonatomic, copy) NSString * businessEndTime; // 结束营业时间
@property (nonatomic, copy) NSString * phoneNumber; // 联系电话
@property (nonatomic, copy) NSString * province; // 省份
@property (nonatomic, copy) NSString * city; // 城市
@property (nonatomic, copy) NSString * disctrict; // 区县
@property (nonatomic, copy) NSString * detailAddress; // 具体地址
@property (nonatomic, copy) NSString * logoImagePath; // logo地址
@property (nonatomic, assign) CGFloat latitude; // 纬度
@property (nonatomic, assign) CGFloat longitude; // 经度
@property (nonatomic, assign) StationContact * contact; // 联系人
@property (nonatomic, assign) NSInteger state; // 状态
@property (nonatomic, assign) NSInteger businessType; // 营业类型
@property (nonatomic, strong) NSArray * businessServices; // 服务项目
@end

NS_ASSUME_NONNULL_END
