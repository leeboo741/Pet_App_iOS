//
//  UserEntity.h
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffEntity.h"
#import "BusinessEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, USER_ROLE) {
    USER_ROLE_UNKOWN = 0, // 未知
    USER_ROLE_CUSTOMER, // 客户
    USER_ROLE_BUSINESS, // 商家
    USER_ROLE_MANAGER, // 站点管理员
    USER_ROLE_DRIVER, // 司机
    USER_ROLE_SERVICE, // 客服
    USER_ROLE_B_MANAGER, // 商家+管理员
    USER_ROLE_B_DRIVER, // 商家+司机
    USER_ROLE_B_SERVICE, // 商家+客服
};

typedef NS_ENUM(NSInteger, CURRENT_USER_ROLE) {
    CURRENT_USER_ROLE_CUSTOMER = 0,
    CURRENT_USER_ROLE_BUSINESS = 1,
    CURRENT_USER_ROLE_STAFF = 2,
};

@interface UserEntity : NSObject
@property (nonatomic, assign) CURRENT_USER_ROLE currentRole; // 当前的角色 用于管理页面展示和权限控制 客户 商家 员工
@property (nonatomic, assign) int staffRole; // 服务器下发的角色 客户 客服 管理 司机
@property (nonatomic, assign, readonly) USER_ROLE userRole; // 根据数据拼出来的 应有角色 控制权限
@property (nonatomic, copy) NSString * userName; // customerName
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * customerNo; 
@property (nonatomic, copy) NSString * shareBusiness; // shareBusiness
@property (nonatomic, copy) NSString * shareStation; // shareStation
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * avaterImagePath;
@property (nonatomic, assign) CGFloat points;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, copy) NSString * unionId;
@property (nonatomic, copy) NSString * openId;

@property (nonatomic, strong) StaffEntity * staff;
@property (nonatomic, strong) BusinessEntity * business;

@property (nonatomic, copy) NSString * lastLogintime;
@property (nonatomic, copy) NSString * registrationDate;
@end

NS_ASSUME_NONNULL_END
