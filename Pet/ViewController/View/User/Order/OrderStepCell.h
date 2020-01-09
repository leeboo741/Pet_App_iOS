//
//  OrderStepCell.h
//  Pet
//
//  Created by lee on 2020/1/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStepItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderStepCell : UITableViewCell
@property (nonatomic, assign) StepItemType type;
@property (nonatomic, copy) NSString * stepTitle;
@property (nonatomic, copy) NSString * stepTime;
@property (nonatomic, strong) NSArray * mediaList;
@property (nonatomic, assign) NSInteger stepIndex;
@end

NS_ASSUME_NONNULL_END
