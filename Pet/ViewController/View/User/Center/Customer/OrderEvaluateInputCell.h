//
//  OrderEvaluateInputCell.h
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderEvaluateInputCell;
@protocol OrderEvaluateInputCellDelegte <NSObject>
-(void)inputText:(NSString *)text atOrderEvaluateInputCell:(OrderEvaluateInputCell *)cell;
@end

@interface OrderEvaluateInputCell : UITableViewCell
@property (nonatomic, weak) id <OrderEvaluateInputCellDelegte> delegate;
@end

NS_ASSUME_NONNULL_END
