//
//  OrderEntity.h
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffEntity.h"
#import "StationEntity.h"
#import "StaffEntity.h"

NS_ASSUME_NONNULL_BEGIN
@interface PetType : NSObject
@property (nonatomic, copy) NSString * petTypeName;
@end

@interface PetBreed : NSObject
@property (nonatomic, copy) NSString * petBreedName;
@end

@interface OrderTransport : NSObject
@property (nonatomic, assign) NSInteger transportType;
@property (nonatomic, copy, readonly) NSString * transportTypeName;
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, copy) NSString * startCity;
@property (nonatomic, copy) NSString * endCity;
@end

@interface OrderTransportInfo : NSObject
@property (nonatomic, copy) NSString * transportNum; // 车次号
@property (nonatomic, copy) NSString * expressNum; // 快递单号
@property (nonatomic, copy) NSString * startCity; // 出发城市, 如果是航班添出发城市三字码
@property (nonatomic, copy) NSString * endCity; // 目的城市, 如果是航班填目的城市三字码
@property (nonatomic, copy) NSString * dateTime; // 预计出发时间
@end

@interface AddedInsure : NSObject
@property (nonatomic, assign) NSInteger insureNo;
@property (nonatomic, assign) CGFloat insureAmount;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) StationEntity * station;
@end

@interface OrderRemarks : NSObject
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, strong) StaffEntity * staff;
@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * dateTime;
@end

@interface OrderTempDeliver : NSObject
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, copy) NSString * recipientName; // 收件人手机
@property (nonatomic, copy) NSString * recipientPhone; // 收件人电话
@property (nonatomic, copy) NSString * address; // 派送地址
@property (nonatomic, copy) NSString * deliverTime; // 派送时间
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@end

@interface OrderPremium : NSObject
@property (nonatomic, copy) NSString * billNo; // 补价单编号
@property (nonatomic, copy) NSString * orderNo; // 原单据编号
@property (nonatomic, copy) NSString * reason; // 补价原因
@property (nonatomic, strong) StaffEntity * staff;
@property (nonatomic, copy) NSString * state; // 补价状态
@property (nonatomic, assign) double amount; // 补价金额
@property (nonatomic, copy) NSString * appendImages; // 图片地址
@end

@interface OrderMedia : NSObject
@property (nonatomic, copy) NSString * mediaType;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * mediaName;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, assign) int sn;
@property (nonatomic, copy) NSString * mediaNo;
@property (nonatomic, copy) NSString * mediaAddress;
@property (nonatomic, copy) NSString * viewAddress;
@end

@interface OrderStatus : NSObject
@property (nonatomic, copy) NSString * time;
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * orderType;
@property (nonatomic, assign) int sn;
@property (nonatomic, strong) NSArray<OrderMedia *> * orderMediaList;
@end

@interface OrderEntity : NSObject
@property (nonatomic, copy) NSString * orderNo; // 订单编号
@property (nonatomic, copy) NSString * orderDate; // 下单日期
@property (nonatomic, copy) NSString * orderTime; // 下单时间
@property (nonatomic, copy) NSString * outportTime; // 出发时间
@property (nonatomic, copy) NSString * startCity; // 出发城市
@property (nonatomic, copy) NSString * endCity; // 结束城市
@property (nonatomic, strong) PetType * petType; // 宠物种类
@property (nonatomic, strong) PetBreed * petBreed; // 宠物品种
@property (nonatomic, strong) OrderTransport * transport; // 订单运输类型
@property (nonatomic, strong) OrderTransportInfo * orderTransport; // 订单运输信息
@property (nonatomic, assign) NSInteger num; // 宠物数量
@property (nonatomic, assign) CGFloat weight; // 宠物重量
@property (nonatomic, copy) NSString * senderName; // 寄宠人名称
@property (nonatomic, copy) NSString * senderPhone; // 寄宠人电话
@property (nonatomic, copy) NSString * receiverName; // 收宠人名称
@property (nonatomic, copy) NSString * receiverPhone; // 收宠人电话
@property (nonatomic, copy) NSString * orderState; // 订单状态
@property (nonatomic, copy) NSString * orderAmount; // 订单金额
@property (nonatomic, copy) NSString * orderRemark; // 客户备注
@property (nonatomic, strong) NSArray<StaffEntity *> *assignmentedStaffArray; // 分配的员工列表
@property (nonatomic, copy, readonly) NSString * assignmentedStaffString; // 分配的员工名称拼接字串
@property (nonatomic, strong) NSArray<OrderTempDeliver *> * orderTempDelivers; // 临派
@property (nonatomic, strong) NSArray<OrderPremium *> * orderPremiumList; // 补价
@property (nonatomic, strong) NSArray<OrderStatus *> * orderStates; // 订单步骤
@property (nonatomic, strong) AddedInsure * addedInsure; // 保险;
@property (nonatomic, strong) NSArray<OrderRemarks *> * orderRemarksList; // 订单备注列表
@property (nonatomic, copy) NSString * outTradeNo;
@property (nonatomic, copy) NSString * petAge; // 宠物年龄

@property (nonatomic, strong) NSArray * waitUploadMediaList; // 等待上传的文件列表
@property (nonatomic, strong) NSArray * waitCommitMediaList; // 上传后等待提交的文件列表
@end

NS_ASSUME_NONNULL_END
