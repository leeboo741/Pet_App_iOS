//
//  UserManager.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UserManager.h"
#import <WXApi.h>

static NSString * User_Key = @"USER_KEY";

@interface UserManager ()
@property (nonatomic, strong) UserEntity * user;
@end

@implementation UserManager

#pragma mark - life cycle
/**
 *  单例
 */
SingleImplementation(UserManager)
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"user" options:NSKeyValueObservingOptionNew context:nil];
        [self.user addObserver:self forKeyPath:@"role" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - public method

/// 登录
/// @param phone 电话号码
-(void)loginWithPhone:(NSString *)phone{
    
}
/**
 *  保存用户
 *  @param user 用户
 */
-(void)saveUser:(UserEntity *)user{
    self.user = user;
    [UserDataBaseHandler updateUser:user];
}
/**
 *  获取用户
 */
-(UserEntity *)getUser{
    return self.user;
}
/**
 *  改变用户角色
 *  @param role 角色
 */
-(void)changeUserRole:(USER_ROLE)role{
    self.user.role = role;
}
/**
 *  获取用户角色
 */
-(USER_ROLE)getUserRole{
    return self.user.role;
}
/**
 *  获取客户编号
 */
-(NSString *)getCustomerNo{
    return self.user.customerNo;
}
/**
 *  获取商户编号
 */
-(NSString *)getBusinessNo{
    return self.user.businessNo;
}
/**
 *  获取站点编号
 */
-(NSString *)getStationNo{
    return self.user.stationNo;
}

/**
 *  获取手机号
 */
-(NSString *)getPhone{
    return self.user.phone;
}

/**
 *  注册UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 *  @parma action 注册响应方法
 */
-(void)registerUserManagerNotificationWithObserver:(id)observer notificationName:(NSString *)notificationName action:(SEL)action{
    // observer: 观察者
    // selector: 响应方法
    // name: 通知名称
    // object: 观察者只接收来自于object对象的发出的所注册通知
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:action name:notificationName object:self];
}

/**
 *  移除UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 */
-(void)removeObserverForUserManager:(id)observer notificationName:(NSString *)notificationName{
    // observer: 观察者
    // name: 通知名称
    // object: 观察者只接收来自于object对象的发出的所注册通知
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:notificationName object:self];
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"user"]) {
        [self postUserChangeNotification];
    } else if ([keyPath isEqualToString:@"role"]) {
        [self postUserRoleChangeNotification];
    }
}

#pragma mark - notification

/**
 *  发送通知
 *  @param notificationName 通知名称
 *  @param data 附带数据
 */
-(void)postNotificationWithName:(NSString *)notificationName userInfoData:(id)data{
    // name: notification 注册名
    // object: 发送通知的对象
    // userInfo: 给观察者的额外信息
    NSDictionary * userInfo = nil;
    if (data != nil) {
        userInfo = @{@"data":data};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:userInfo];
}

/**
 *  发送用户改变通知
 */
-(void)postUserChangeNotification{
    [self postNotificationWithName:USER_CHANGE_NOTIFICATION_NAME userInfoData:self.user];
}

/**
 *  发送用户角色改变通知
 */
-(void)postUserRoleChangeNotification{
    [self postNotificationWithName:USER_ROLE_CHANGE_NOTIFICATION_NAME userInfoData:kIntegerNumber(self.user.role)];
}

#pragma mark - setters and getters
-(UserEntity *)user{
    if (!_user) {
        _user = [UserDataBaseHandler getUser];
    }
    return _user;
}

@end
