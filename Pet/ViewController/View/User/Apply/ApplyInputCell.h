//
//  ApplyInputCell.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ApplyInputCell;
@protocol ApplyInputCellDelegate <NSObject>

-(BOOL)shouldBeganEditing:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell;
-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell;

@end

@interface ApplyInputCell : UITableViewCell
@property (nonatomic, assign) BOOL showFlag;
@property (nonatomic, copy) NSString * cellPlaceholder;
@property (nonatomic, copy) NSString * cellValue;
@property (nonatomic, copy) NSString * cellTitle;
@property (nonatomic, weak) id<ApplyInputCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
