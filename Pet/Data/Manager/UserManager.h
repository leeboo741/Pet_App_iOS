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
#import "HttpManager.h"
#import "WechatManager.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 用户注册对象
typedef NS_ENUM(NSInteger, SEX) {
    SEX_MALE = 1,
    SEX_FEMALE = 0
};

@interface RegisterUserInfo : NSObject
@property (nonatomic, copy) NSString * headImageUrl; // 头像
@property (nonatomic, copy) NSString * phone; // 电话
@property (nonatomic, assign) SEX sex; // 性别
@property (nonatomic, copy, readonly) NSString * sexStr;
@property (nonatomic, copy) NSString * nickName; // 昵称
@property (nonatomic, copy) NSString * unionid; // unionid
@property (nonatomic, copy) NSString * openid; // openid
@property (nonatomic, copy) NSString * appType; // app类型 iOS / Android / Weapp
@property (nonatomic, copy) NSString * shareBusinessNo; // 商家分享id
@property (nonatomic, copy) NSString * shareStationNo; // 站点分享id
@property (nonatomic, copy) NSString * verificationCode; // 验证码
+(RegisterUserInfo *)getUserInfoFromWechatUserInfo:(WechatUserInfo *)wechatUserInfo;
@end

#pragma mark - 用户管理中心
static NSString * USER_CHANGE_NOTIFICATION_NAME = @"UserChangeNotificationName"; // 用户改变
static NSString * USER_ROLE_CHANGE_NOTIFICATION_NAME = @"UserRoleChangeNotificationName"; // 用户角色改变
static NSString * USER_BALANCE_CHANGE_NOTIFICATION_NAME = @"UserBalanceChangeNotificationName"; // 用户余额改变
static NSString * USER_POINTS_CHANGE_NOTIFICATION_NAME = @"UserPointsChangeNotificationName"; // 用户积分改变
static NSString * USER_AVATER_CHANGE_NOTIFICATION_NAME = @"UserAvaterChangeNotificationName"; // 用户头像改变

@interface UserManager : NSObject
/**
 *  获取单例
 */
SingleInterface(UserManager)

/**
 手机号码登录
 
 @param phone 手机号码
 @param jsessionId jsessionId
 @param code 短信验证码
 @param success success
 @param fail fail
 */
-(void)loginWithPhone:(NSString *)phone
           jsessionId:(NSString *)jsessionId
                 code:(NSString *)code
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;

/**
 微信 unionid 登录
 
 @param unionid 微信 unionid
 @param success success
 @param fail fail
 */
-(void)loginWithWechatUnionid:(NSString *)unionid
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail;

/**
 注册用户
 
 @param registerUserInfo 注册用户
 @param jsessionid jsessionid
 @param success success
 @param fail fail
 */
-(void)registerUser:(RegisterUserInfo *)registerUserInfo
         jsessionid:(NSString *)jsessionid
            success:(SuccessBlock)success
               fail:(FailBlock)fail;

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
-(void)changeUserRole:(CURRENT_USER_ROLE)role;
/**
 *  获取用户当前角色
 */
-(CURRENT_USER_ROLE)getCurrentUserRole;
/**
 获取用户角色
 */
-(USER_ROLE)getUserRole;
/**
 是否是员工
 是否是管理员
 是否是司机
 是否是客服
 是否是商家
 */
-(BOOL)isStaff;
-(BOOL)isManager;
-(BOOL)isDriver;
-(BOOL)isService;
-(BOOL)isBusiness;

/**
 获取员工对象
 */
-(StaffEntity *)getStaff;

/**
 获取站点信息
 */
-(StationEntity *)getStation;

/**
 获取商家信息
 */
-(BusinessEntity *)getBusiness;

/**
 获取员工编号
 */
-(NSString *)getStaffNo;
/**
 获取站点编号
 */
-(NSString *)getStationNo;
/**
 获取商家编号
 */
-(NSString *)getBusinessNo;
/**
 获取用户编号
 */
-(NSString *)getCustomerNo;
/**
 *  获取手机号
 */
-(NSString *)getPhone;
/**
 获取余额
 */
-(CGFloat)getBalance;
/**
 获取积分
 */
-(CGFloat)getPoints;
/**
 获取头像地址
 */
-(NSString *)getAvaterImagePath;

/**
 登出 退出
 */
-(void)logout;

/**
 刷新 用户 余额
 */
-(void)refreshBalance;

/**
 *  注册UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 *  @parma action 注册响应方法
 */
-(void)registerUserManagerNotificationWithObserver:(id)observer
                                  notificationName:(NSString *)notificationName
                                            action:(SEL)action;
/**
 *  移除UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 */
-(void)removeObserverForUserManager:(id)observer
                   notificationName:(NSString *)notificationName;
@end

NS_ASSUME_NONNULL_END
