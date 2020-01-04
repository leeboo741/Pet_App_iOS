//
//  AssignmentsItemCell.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssignmentsItemCell : UITableViewCell
@property (nonatomic, assign) BOOL assignmented; // 是否分配
@property (nonatomic, copy) NSString * name;
@end

NS_ASSUME_NONNULL_END
