//
//  CustomerOrderCell.h
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"
#import "OrderOperateBoxView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomerOrderType) {
    CustomerOrderType_Unpay = 0, // 未支付订单
    CustomerOrderType_Unsend, // 已支付订单
    CustomerOrderType_Unreceive, // 待签收订单
    CustomerOrderType_Complete, // 已完成订单
};

@class CustomerOrderCell;
@protocol CustomerOrderCellDelegate <NSObject>

-(void)tapCustomerOrderCell:(CustomerOrderCell *)cell operateType:(OrderOperateButtonType)type atIndex:(NSInteger)index;

@end

@interface CustomerOrderCell : UITableViewCell
@property (nonatomic, strong) OrderEntity * orderEntity;
@property (nonatomic, assign) CustomerOrderType orderType;
@property (nonatomic, weak) id<CustomerOrderCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
