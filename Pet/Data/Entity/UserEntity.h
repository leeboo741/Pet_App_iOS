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
};

@interface UserEntity : NSObject
@property (nonatomic, assign) USER_ROLE role;
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
