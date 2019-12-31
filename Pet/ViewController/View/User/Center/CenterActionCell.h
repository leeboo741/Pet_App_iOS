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

@interface CenterActionCell : UITableViewCell
@property (nonatomic, strong) NSArray<CenterActionItemModel*> * modelArray;
@end

NS_ASSUME_NONNULL_END
