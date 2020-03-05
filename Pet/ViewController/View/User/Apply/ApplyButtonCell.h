//
//  ApplyButtonCell.h
//  Pet
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ApplyButtonCell;

@protocol ApplyButtonCellDelegate <NSObject>

-(void)tapApplyButton:(ApplyButtonCell *)cell;

@end

@interface ApplyButtonCell : UITableViewCell
@property (nonatomic, weak) id<ApplyButtonCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
