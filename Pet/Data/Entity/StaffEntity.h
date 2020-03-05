//
//  StaffEntity.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface StaffEntity : NSObject
@property (nonatomic, copy) NSString * name; // staffName
@property (nonatomic, copy) NSString * staffNo; //
@property (nonatomic, copy) NSString * openId; //
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * sex;

@property (nonatomic, assign) BOOL assignmented; // 是否分配

@property (nonatomic, strong) StationEntity * station;
@end

NS_ASSUME_NONNULL_END
