//
//  TransportOrderBaseInfoCell.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TransportBaseInfo_Type) {
    TransportBaseInfo_Type_StartCity = 0, // 出发城市
    TransportBaseInfo_Type_EndCity, // 目的城市
    TransportBaseInfo_Type_Time, // 出发时间
    TransportBaseInfo_Type_Count, // 数量
    TransportBaseInfo_Type_Type, // 宠物类型
    TransportBaseInfo_Type_Breed, // 宠物品种
    TransportBaseInfo_Type_Weight, // 宠物重量
    TransportBaseInfo_Type_Age, // 宠物年龄
    TransportBaseInfo_Type_Name, // 宠物名称
};

@protocol TransportOrderBaseInfoCallDelegate <NSObject>

-(void)selectBaseInfoItem:(TransportBaseInfo_Type)baseInfoType;
-(void)inputBaseInfoItem:(TransportBaseInfo_Type)baseInfoType withText:(NSString *)text;
-(void)endingInputBaseInfoItem:(TransportBaseInfo_Type)baseInfoType;

@end

static NSString * TransportOrderCityChangeKey = @"TransportOrderBaseInfoCityChange";
static NSString * TransportOrderStartCityNotificationKey = @"StartCity";
static NSString * TransportOrderEndCityNotificationKey = @"EndCity";

@interface TransportOrderBaseInfoCell : UITableViewCell
@property (nonatomic, weak) id<TransportOrderBaseInfoCallDelegate> delegate;
@property (nonatomic, copy) NSString * startCity;
@property (nonatomic, copy) NSString * endCity;
@property (nonatomic, copy) NSString * outTime;
@property (nonatomic, copy) NSString * petCount;
@property (nonatomic, copy) NSString * petType;
@property (nonatomic, copy) NSString * petBreed;
@property (nonatomic, copy) NSString * petWeight;
@property (nonatomic, copy) NSString * petAge;
@property (nonatomic, copy) NSString * petName;
@end

NS_ASSUME_NONNULL_END
