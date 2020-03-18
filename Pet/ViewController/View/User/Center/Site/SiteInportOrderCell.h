//
//  SiteInportOrderCell.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"
#import "OrderOperateBoxView.h"
#import "MediaSelectBoxView.h"
#import "MediaShowBox.h"

NS_ASSUME_NONNULL_BEGIN

@class SiteInportOrderCell;
@protocol SiteInportOrderCellDelegate <NSObject>

-(void)siteInportOrderCell:(SiteInportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData;
-(void)tapSiteInportOrderCell:(SiteInportOrderCell *)cell operateType:(OrderOperateButtonType)type;

@end

@interface SiteInportOrderCell : UITableViewCell

@property (nonatomic, strong) OrderEntity * orderEntity;
@property (nonatomic, weak) id<SiteInportOrderCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
