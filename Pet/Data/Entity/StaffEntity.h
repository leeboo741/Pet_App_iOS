//
//  StaffEntity.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffEntity : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * staffNo;
@property (nonatomic, assign) BOOL assignmented;
@end

NS_ASSUME_NONNULL_END
