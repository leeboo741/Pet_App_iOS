//
//  OrderEvaluateStarCell.h
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderEvaluateStarCell;
@protocol OrderEvaluateStarCellDelegate <NSObject>

-(void)tapStarAtOrderEvaluateStarCell:(OrderEvaluateStarCell *)cell withLevel:(NSInteger)level;

@end

@interface OrderEvaluateStarCell : UITableViewCell
@property (nonatomic, weak)id<OrderEvaluateStarCellDelegate>delegate;
@property (nonatomic, assign) NSInteger starLevel;
@end

NS_ASSUME_NONNULL_END
