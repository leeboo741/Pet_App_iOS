//
//  OrderBaseInfoView.h
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderBaseInfoView : UIView
@property (nonatomic, strong) IBOutlet UIView * view;

@property (nonatomic, copy) NSString * orderNo; // 订单编号
@property (nonatomic, copy) NSString * orderTime; // 下单时间
@property (nonatomic, copy) NSString * outportTime; // 出发时间
@property (nonatomic, copy) NSString * startCity; // 开始城市
@property (nonatomic, copy) NSString * endCity; // 结束城市
@property (nonatomic, copy) NSString * transportType; // 运输方式
@property (nonatomic, copy) NSString * petType; // 宠物类型
@property (nonatomic, copy) NSString * petBreed; // 宠物品种
@property (nonatomic, copy) NSString * senderName; // 寄宠人名称
@property (nonatomic, copy) NSString * senderPhone; // 寄宠人电话
@property (nonatomic, copy) NSString * receiverName; // 收宠人名称
@property (nonatomic, copy) NSString * receiverPhone; // 收宠人电话
@property (nonatomic, copy) NSString * orderState; // 订单状态
@property (nonatomic, copy) NSString * orderAmount; // 订单金额
@end

NS_ASSUME_NONNULL_END
