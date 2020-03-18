//
//  AddTempDeliverController.h
//  Pet
//
//  Created by mac on 2020/3/18.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddTempDeliverSuccessBlock)(void);
@interface AddTempDeliverController : UITableViewController
@property (nonatomic, strong) OrderEntity * order;
@property (nonatomic, copy) AddTempDeliverSuccessBlock successBlock;
@end

NS_ASSUME_NONNULL_END
