//
//  OrderAssignmentsView.h
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//
//  订单分配人员栏
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderAssignmentsView : UIView
@property (nonatomic, strong) NSArray * assignmentsList;
@property (nonatomic, copy) NSString * assignmentsStr;
@end

NS_ASSUME_NONNULL_END
