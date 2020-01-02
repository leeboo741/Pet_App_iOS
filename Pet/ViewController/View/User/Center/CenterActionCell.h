//
//  CenterActionCell.h
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterActionItem.h"

NS_ASSUME_NONNULL_BEGIN

@class CenterActionCell;
@protocol CenterActionCellDelegate <NSObject>

-(void)tapActionAtIndex:(NSInteger)index atActionCell:(CenterActionCell *)cell;

@end

@interface CenterActionCell : UITableViewCell
@property (nonatomic, strong) NSArray<CenterActionItemModel*> * modelArray;
@property (nonatomic, weak) id<CenterActionCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
