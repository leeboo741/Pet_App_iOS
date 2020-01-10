//
//  BottomButtonCell.h
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BottomButtonCell;
@protocol BottomButtonCellDelegate <NSObject>

@end

@interface BottomButtonCell : UITableViewCell
-(void)addTarget:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;
@property (nonatomic, strong) UIColor * buttonColor;
@property (nonatomic, strong) UIColor * buttonTitleColor;
@property (nonatomic, copy) NSString * buttonTitle;
@end

NS_ASSUME_NONNULL_END
