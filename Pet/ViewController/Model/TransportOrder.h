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
@end

NS_ASSUME_NONNULL_END
