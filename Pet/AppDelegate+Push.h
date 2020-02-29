//
//  AppDelegate+Push.h
//  Pet
//
//  Created by mac on 2020/1/18.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import <CloudPushSDK/CloudPushSDK.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Push)
/**
 初始化 ali 推送 sdk
 */
-(void)initAliPush;
/**
 注册苹果推送，获取deviceToken用于推送
 
 @param  application application
 */
- (void)registerAPNS:(UIApplication *)application;
/**
 注册推送消息到来监听
 */
- (void)registerMessageReceive;
/**
 iOS 10以下版本
 程序启动 App处于关闭状态时，点击打开通知
 */
-(void)push_ApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
