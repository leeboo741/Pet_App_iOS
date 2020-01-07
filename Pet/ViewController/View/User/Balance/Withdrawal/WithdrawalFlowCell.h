//
//  WithdrawalFlowCell.h
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawalFlowCell : UITableViewCell
@property (nonatomic, copy) NSString * amount; // 提现金额
@property (nonatomic, copy) NSString * time; // 提现时间
@property (nonatomic, copy) NSString * state; // 提现状态
@end

NS_ASSUME_NONNULL_END
