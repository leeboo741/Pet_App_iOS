//
//  ApprovalStaffCell.h
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderOperateBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@class ApprovalStaffCell;
@protocol ApprovalStaffCellDelegate <NSObject>

-(void)tapOperateButtonWithType:(OrderOperateButtonType)type atApprovalStaffCell:(ApprovalStaffCell *)cell;

@end

@interface ApprovalStaffCell : UITableViewCell
@property (nonatomic, weak) id<ApprovalStaffCellDelegate> delegate;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * phone;
@end

NS_ASSUME_NONNULL_END
