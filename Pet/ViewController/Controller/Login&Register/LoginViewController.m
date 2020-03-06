//
//  LoginViewController.m
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "PrivacyPolicyView.h"
#import "HomeViewController.h"
#import "MainTabbarController.h"
#import "LocationManager.h"
#import "WechatManager.h"
#import "RegisterViewController.h"
#import "CommonManager.h"

@interface LoginViewController ()<LoginViewDelegate, PrivacyPolicyViewDelegate, WechatAuthDelegate,TimeCountButtonDelegate>
@property (nonatomic, strong) LoginView * loginView;
@property (nonatomic, strong) PrivacyPolicyView * privacyPolicyView;

@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * password; // 改成验证码了
@property (nonatomic, copy) NSString * jsessionid;
@property (nonatomic, assign) BOOL agreePrivacy;

@end

@implementation LoginViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.loginView];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}
#pragma mark - private method
-(BOOL)ableLoginWithLoginPhone:(BOOL)loginPhone{
    if (loginPhone) {
        if (kStringIsEmpty(self.account)) {
            [MBProgressHUD showTipMessageInWindow:@"请输入手机号"];
            return NO;
        }
        if (kStringIsEmpty(self.jsessionid)) {
            [MBProgressHUD showTipMessageInWindow:@"请获取验证码"];
            return NO;
        }
        if (kStringIsEmpty(self.password)) {
            [MBProgressHUD showTipMessageInWindow:@"请输入验证码"];
            return NO;
        }
    }
    if (!self.agreePrivacy) {
        [MBProgressHUD showTipMessageInWindow:@"请查看隐私条款"];
        return NO;
    }
    return YES;
}

#pragma mark - login view delegate
-(void)loginViewTapActionType:(LoginViewTapActionType)type{
    if (type == LoginViewTapActionType_Login) {
        if (![self ableLoginWithLoginPhone:YES]) {
            return;
        }
        [MBProgressHUD showActivityMessageInWindow:@"登录中..."];
        __weak typeof(self) weakSelf = self;
        [[UserManager shareUserManager] loginWithPhone:self.account jsessionId:self.jsessionid code:self.password success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            UserEntity * user = [UserEntity mj_objectWithKeyValues:data];
            [[UserManager shareUserManager] saveUser:user];
            MainTabbarController * mainTabbarController = [MainTabbarController shareMainTabbarController];
            UIWindow * window = kKeyWindow;
            window.rootViewController = mainTabbarController;
            [window makeKeyAndVisible];
        } fail:^(NSInteger code) {
            if (code == HttpResponseCode_NOT_EXISTS) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"账号未注册" message:@"是否前往注册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"前往注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    RegisterUserInfo * registerUserInfo = [[RegisterUserInfo alloc]init];
                    registerUserInfo.phone = weakSelf.account;
                    RegisterViewController * registervc = [[RegisterViewController alloc]init];
                    registervc.registerUserInfo = registerUserInfo;
                    [weakSelf presentViewController:registervc animated:YES completion:nil];
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不注册" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:confirmAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        
    } else if (type == LoginViewTapActionType_Privacy) {
        [self.privacyPolicyView addPopViewToWindow];
    } else if (type == LoginViewTapActionType_ForgetPassword) {
        MSLog(@"忘记密码");
    } else if (type == LoginViewTapActionType_Register) {
        MSLog(@"注册");
    } else if (type == LoginViewTapActionType_Wechat) {
        MSLog(@"微信登录");
        if (![self ableLoginWithLoginPhone:NO]) {
            return;
        }
        [MBProgressHUD showActivityMessageInWindow:@"授权中..."];
        [[WechatManager shareWechatManager] sendAuthRequestWithController:self delegate:self complete:^(BOOL success) {
            if (success) {
                MSLog(@"请求微信登录成功");
            } else {
                MSLog(@"请求微信登录失败");
                [MBProgressHUD hideHUD];
            }
        }];
    }
}

-(void)loginViewInputActionType:(LoginViewInputActionType)type inputText:(NSString *)inputText{
    if (type == LoginViewInputActionType_Account) {
        self.account = inputText;
    } else if (type == LoginViewInputActionType_Password) {
        self.password = inputText;
    }
}

#pragma mark - wechat auth delegate

-(void)wechatAuthCancel{
    MSLog(@"微信授权取消");
    [MBProgressHUD hideHUD];
    [MBProgressHUD showTipMessageInWindow:@"授权取消"];
}

-(void)wechatAuthDenied{
    MSLog(@"微信授权失败");
    [MBProgressHUD hideHUD];
    [MBProgressHUD showTipMessageInWindow:@"授权失败"];
}

-(void)wechatAuthSucceed:(NSString *)code{
    MSLog(@"微信授权成功: code: %@",code);
    [MBProgressHUD hideHUD];
    [MBProgressHUD showActivityMessageInWindow:@"登录中..."];
    __weak typeof(self) weakSelf = self;
    [[WechatManager shareWechatManager] getWechatTokenWithCode:code success:^(id  _Nonnull data) {
        WechatToken * wechatToken = (WechatToken *)data;
        [[UserManager shareUserManager] loginWithWechatUnionid:wechatToken.unionid success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            UserEntity * user = [UserEntity mj_objectWithKeyValues:data];
            [[UserManager shareUserManager] saveUser:user];
            MainTabbarController * mainTabbar = [[MainTabbarController alloc]init];
            UIWindow * window = kKeyWindow;
            window.rootViewController = mainTabbar;
            [window makeKeyAndVisible];
        } fail:^(NSInteger code) {
            [MBProgressHUD hideHUD];
            if (code == HttpResponseCode_NOT_EXISTS) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"账号未注册" message:@"是否前往注册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"前往注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[WechatManager shareWechatManager] getWechatUserInfo:wechatToken.access_token openid:wechatToken.openid success:^(id  _Nonnull data) {
                        WechatUserInfo * wechatUserInfo = (WechatUserInfo *)data;
                        RegisterUserInfo * registerUserInfo = [RegisterUserInfo getUserInfoFromWechatUserInfo:wechatUserInfo];
                        RegisterViewController * registervc = [[RegisterViewController alloc]init];
                        registervc.registerUserInfo = registerUserInfo;
                        [weakSelf presentViewController:registervc animated:YES completion:nil];
                    } fail:^(NSInteger code) {
                        
                    }];
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不注册" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:confirmAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    } fail:^(NSInteger code) {

    }];
}

#pragma mark - privacyPolicy view delegate
-(void)privacyPolicyViewTapButtonAction:(PrivacyPolicyButtonType)buttonType{
    if (buttonType == PrivacyPolicyButtonType_Disagree) {
        self.agreePrivacy = NO;
    } else if (buttonType == PrivacyPolicyButtonType_Agree) {
        self.agreePrivacy = YES;
    } else {
        
    }
}

#pragma mark - time count delegate

-(void)startCountWithTimeCountButton:(TimeCountButton *)timeCountButton{
    MSLog(@"开始获取验证码");
    __weak typeof(self) weakSelf = self;
    [[CommonManager shareCommonManager] getPhoneCodeByPhoneNumber:self.account success:^(id  _Nonnull data) {
        [MBProgressHUD showTipMessageInWindow:@"短信发送成功"];
    } fail:^(NSInteger code) {
        
    } jsessionidReturnBlock:^(NSString * _Nonnull jsessionid) {
        weakSelf.jsessionid = jsessionid;
    }];
}
-(void)stopCountWithTimeCountButton:(TimeCountButton *)timeCountButton{
    MSLog(@"停止倒计时");
}

#pragma mark - setters and getters
-(LoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[LoginView alloc]init];
        _loginView.delegate = self;
        _loginView.ableWechatLogin = [[WechatManager shareWechatManager] isWechatInstalled];
        _loginView.timeCountDelegate = self;
    }
    return _loginView;
}

-(PrivacyPolicyView *)privacyPolicyView{
    if (_privacyPolicyView == nil) {
        _privacyPolicyView = [[PrivacyPolicyView alloc]init];
        _privacyPolicyView.delegate = self;
    }
    return _privacyPolicyView;
}

-(void)setAgreePrivacy:(BOOL)agreePrivacy{
    _agreePrivacy = agreePrivacy;
    self.loginView.agreePrivacy = agreePrivacy;
}

@end
