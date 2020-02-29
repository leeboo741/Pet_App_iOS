//
//  OrderEntity.h
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@end

@interface OrderEntity : NSObject
@property (nonatomic, copy) NSString * orderNo; // 订单编号
@property (nonatomic, copy) NSString * orderTime; // 下单时间
@property (nonatomic, copy) NSString * outportTime; // 出发时间
@property (nonatomic, copy) NSString * startCity; // 出发城市
@property (nonatomic, copy) NSString * endCity; // 结束城市
@property (nonatomic, strong) PetType * petType; // 宠物种类
@property (nonatomic, strong) PetBreed * petBreed; // 宠物品种
@property (nonatomic, strong) OrderTransport * transport; // 订单运输类型
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
@property (nonatomic, strong) NSArray * waitUploadMediaList; // 等待上传的文件列表
@property (nonatomic, strong) NSArray * waitCommitMediaList; // 上传后等待提交的文件列表
@end

NS_ASSUME_NONNULL_END
