//
//  UserManager.h
//  用户管理
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleInstanceMacro.h"
#import "UserEntity.h"
#import "UserDataBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * USER_CHANGE_NOTIFICATION_NAME = @"UserChangeNotificationName"; // 用户改变
static NSString * USER_ROLE_CHANGE_NOTIFICATION_NAME = @"UserRoleChangeNotificationName"; // 用户角色改变

@interface UserManager : NSObject
/**
 *  获取单例
 */
SingleInterface(UserManager)


/// 登录
/// @param phone 电话号码
-(void)loginWithPhone:(NSString *)phone;

/**
 *  保存用户
 *  @param user 用户
 */
-(void)saveUser:(UserEntity *)user;
/**
 *  获取用户
 */
-(UserEntity *)getUser;
/**
 *  改变用户角色
 *  @param role 角色
 */
-(void)changeUserRole:(USER_ROLE)role;
/**
 *  获取用户角色
 */
-(USER_ROLE)getUserRole;
/**
 *  获取手机号
 */
-(NSString *)getPhone;
/**
 *  注册UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 *  @parma action 注册响应方法
 */
-(void)registerUserManagerNotificationWithObserver:(id)observer notificationName:(NSString *)notificationName action:(SEL)action;
/**
 *  移除UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 */
-(void)removeObserverForUserManager:(id)observer notificationName:(NSString *)notificationName;
@end

NS_ASSUME_NONNULL_END
