//
//  OrderPremiumCell.h
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderPremiumCell;
@protocol OrderPremiumCellDelegate <NSObject>

-(void)tapPremiumButtonWithState:(NSString *)premiumState atOrderPremiumCell:(OrderPremiumCell *)cell;

@end

@interface OrderPremiumCell : UITableViewCell
@property (nonatomic, copy) NSString * premiumAmount;
@property (nonatomic, copy) NSString * premiumReason;
@property (nonatomic, copy) NSString * premiumTime;
@property (nonatomic, copy) NSString * premiumState;
@property (nonatomic, weak) id<OrderPremiumCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
