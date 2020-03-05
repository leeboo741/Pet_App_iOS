//
//  TransportOrder.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 运输类型
 */
@interface TransportType : NSObject
@property (nonatomic, copy) NSString * typeName; // 运输类型名称
@property (nonatomic, assign) CGFloat * price; // 运输价格
@property (nonatomic, copy) NSString * typeId; // 运输类型id
@end

typedef NS_ENUM(NSInteger, TransportOrder_AddValue_SelectType) {
    TransportOrder_AddValue_SelectType_Selected = 1,
    TransportOrder_AddValue_SelectType_Unselected = 0,
};

/**
 运输订单
 */
@interface TransportOrder : NSObject
@property (nonatomic, copy) NSString * startCity; // 出发城市
@property (nonatomic, copy) NSString * endCity; // 目的城市
@property (nonatomic, copy) NSString * outTime; // 出发时间
@property (nonatomic, copy) NSString * petCount; // 宠物数量
@property (nonatomic, copy) NSString * petType; // 宠物种类
@property (nonatomic, copy) NSString * petBreed; // 宠物品种
@property (nonatomic, copy) NSString * petWeight; // 宠物重量
@property (nonatomic, copy) NSString * petAge; // 宠物年龄
@property (nonatomic, copy) NSString * petName; // 宠物名称
@property (nonatomic, strong) TransportType * transportType; // 运输方式
@property (nonatomic, copy) NSString * senderName; // 寄件人名称
@property (nonatomic, copy) NSString * senderPhone; // 寄件人电话
@property (nonatomic, copy) NSString * receiverName; // 收件人名称
@property (nonatomic, copy) NSString * receiverPhone; // 收件人电话
@property (nonatomic, copy) NSString * remark; // 订单备注信息
@property (nonatomic, copy) NSString * customerNo; // openid
@property (nonatomic, assign) TransportOrder_AddValue_SelectType buyPetCage; // 是否购买宠物箱
@property (nonatomic, assign) TransportOrder_AddValue_SelectType giveFood;
@property (nonatomic, assign) TransportOrder_AddValue_SelectType guarantee; // 中介担保
@property (nonatomic, assign) TransportOrder_AddValue_SelectType water; // 饮水器
@property (nonatomic, assign) TransportOrder_AddValue_SelectType warmCloth; // 保暖外套
@property (nonatomic, assign) TransportOrder_AddValue_SelectType wo; // 暖窝
@property (nonatomic, assign) TransportOrder_AddValue_SelectType receipt; // 接宠
@property (nonatomic, copy) NSString * receiptAddress; // 接宠地址
@property (nonatomic, assign) double receiptLongitude; // 接宠经度
@property (nonatomic, assign) double receiptLatitude; // 接宠纬度
@property (nonatomic, assign) TransportOrder_AddValue_SelectType send; // 送宠
@property (nonatomic, copy) NSString * sendAddress; // 送宠地址
@property (nonatomic, assign) double sendLongitude; // 送宠经度
@property (nonatomic, assign) double sendLatitude; // 送宠纬度
@property (nonatomic, assign) TransportOrder_AddValue_SelectType insuredPrice; // 保价
@property (nonatomic, assign) double petAmount; // 声明价值
@end

NS_ASSUME_NONNULL_END
