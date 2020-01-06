//
//  ApprovalStationCell.h
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderOperateBoxView.h"

NS_ASSUME_NONNULL_BEGIN
@class ApprovalStationCell;
@protocol ApprovalStationCellDelegate <NSObject>

-(void)tapOperateButtonWithType:(OrderOperateButtonType)type atApprovalStationCell:(ApprovalStationCell *)cell;

@end

@interface ApprovalStationCell : UITableViewCell
@property (nonatomic, weak) id<ApprovalStationCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
