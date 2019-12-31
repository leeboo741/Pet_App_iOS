//
//  UserEntity.h
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * customerNo;
@property (nonatomic, copy) NSString * businessNo;
@property (nonatomic, copy) NSString * stationNo;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * avaterImagePath;
@end

NS_ASSUME_NONNULL_END
