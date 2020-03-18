//
//  AssignmentsController.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AssignmentsReturnBlock)(NSArray<StaffEntity *> *assignmentedArray);

@interface AssignmentsController : UITableViewController
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, strong) NSArray<StaffEntity *> * selectStaffArray;
@property (nonatomic, copy) AssignmentsReturnBlock returnBlock;
@end

NS_ASSUME_NONNULL_END
