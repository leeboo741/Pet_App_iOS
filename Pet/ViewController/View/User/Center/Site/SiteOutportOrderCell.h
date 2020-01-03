//
//  SiteOutportOrderCell.h
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"
#import "OrderOperateBoxView.h"
#import "MediaSelectBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@class SiteOutportOrderCell;
@protocol SiteOutportOrderCellDelegate <NSObject>

-(void)siteOutportOrderCell:(SiteOutportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData;
-(void)tapSiteOutportOrderCell:(SiteOutportOrderCell *)cell operateType:(OrderOperateButtonType)type;

@end

@interface SiteOutportOrderCell : UITableViewCell
@property (nonatomic, strong) NSArray<MediaSelectItemModel *>* selectImageDataList;
@property (nonatomic, strong) OrderEntity * orderEntity;
@property (nonatomic, weak) id<SiteOutportOrderCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
