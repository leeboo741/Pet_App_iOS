//
//  BalanceFlowCell.h
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceFlowCell : UITableViewCell
@property (nonatomic, copy) NSString * linkNo;
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * flowAmount;
@property (nonatomic, copy) NSString * afterBalanceAmount;
@property (nonatomic, copy) NSString * flowTime;
@end

NS_ASSUME_NONNULL_END
