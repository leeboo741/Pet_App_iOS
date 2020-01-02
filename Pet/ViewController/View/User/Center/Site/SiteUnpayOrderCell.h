//
//  SiteUnpayOrderCell.h
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"
#import "OrderOperateBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@class SiteUnpayOrderCell;
@protocol SiteUnpayOrderCellDelegate <NSObject>
-(void)tapSiteUnpayOrderCell:(SiteUnpayOrderCell *)cell operateType:(OrderOperateButtonType)type;
@end

@interface SiteUnpayOrderCell : UITableViewCell
@property (nonatomic, strong) OrderEntity * orderEntity;
@property (nonatomic, weak) id<SiteUnpayOrderCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
