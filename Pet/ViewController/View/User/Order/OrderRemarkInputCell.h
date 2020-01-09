//
//  OrderRemarkInputCell.h
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderRemarkInputCell;
@protocol OrderRemarkInputCellDelegate <NSObject>

-(void)remarkInputShouldReturnAtCell:(OrderRemarkInputCell *)cell text:(NSString *)text;

@end

@interface OrderRemarkInputCell : UITableViewCell
@property (nonatomic, weak) id<OrderRemarkInputCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
