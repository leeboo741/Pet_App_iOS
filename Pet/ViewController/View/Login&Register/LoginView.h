//
//  LoginView.h
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeCountButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LoginViewTapActionType) {
    LoginViewTapActionType_Login = 0, // 登录
    LoginViewTapActionType_ForgetPassword, // 忘记密码
    LoginViewTapActionType_Register, // 注册
    LoginViewTapActionType_Privacy, // 隐私政策
    LoginViewTapActionType_Wechat, // 微信登录
};

typedef NS_ENUM(NSInteger, LoginViewInputActionType) {
    LoginViewInputActionType_Account = 0, // 账户输入
    LoginViewInputActionType_Password, // 密码输入
};

@protocol LoginViewDelegate <NSObject>

-(void)loginViewTapActionType:(LoginViewTapActionType)type;
-(void)loginViewInputActionType:(LoginViewInputActionType)type inputText:(NSString *)inputText;

@end

@interface LoginView : UIView

@property (nonatomic, copy) NSString * logoImageName;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, assign) BOOL agreePrivacy;
@property (nonatomic, weak) id<LoginViewDelegate> delegate;
@property (nonatomic, assign) BOOL ableWechatLogin;
@property (nonatomic, assign)TimeCountState state;
@property (nonatomic, weak) id<TimeCountButtonDelegate> timeCountDelegate;


@end

NS_ASSUME_NONNULL_END
