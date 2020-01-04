//
//  FormTableViewCell.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//


//////////// 稍后完成吧 这个拖时间了

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FormTableViewCell;
@protocol FormTableViewCellDataSource <NSObject>
@optional
-(UIView *)headerViewForFormTableViewCell:(FormTableViewCell *)cell;
-(UIView *)footerViewForFormTableViewCell:(FormTableViewCell *)cell;
-(UIView *)centerLeftViewForFormTableViewCell:(FormTableViewCell *)cell;
-(UIView *)centerRightViewForFormTableViewCell:(FormTableViewCell *)cell;
-(UIView *)flagViewForFormTableViewCell:(FormTableViewCell *)cell;
@end

@interface FormTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString * formTitle;
@property (nonatomic, copy) NSString * formDetail;
@property (nonatomic, assign) BOOL showFlag;
@property (nonatomic, copy) NSString * flagIconName;
@property (nonatomic, weak) id<FormTableViewCellDataSource>dataSource;
@end

NS_ASSUME_NONNULL_END
