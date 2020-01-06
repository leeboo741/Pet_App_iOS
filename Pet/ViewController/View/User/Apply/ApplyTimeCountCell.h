//
//  ApplyTimeCountCell.h
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ApplyTimeCountCell;
@protocol ApplyTimeCountCellDelegate <NSObject>
-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyTimeCountCell:(ApplyTimeCountCell *)cell;
-(void)tapTimeCountingAtApplyTimeCountCell:(ApplyTimeCountCell *)cell;
@end

@interface ApplyTimeCountCell : UITableViewCell
@property (nonatomic, assign) BOOL showFlag;
@property (nonatomic, copy) NSString * cellPlaceholder;
@property (nonatomic, copy) NSString * cellValue;
@property (nonatomic, weak) id<ApplyTimeCountCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
