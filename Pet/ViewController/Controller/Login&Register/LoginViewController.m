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

@interface LoginViewController ()<LoginViewDelegate, PrivacyPolicyViewDelegate, WechatAuthDelegate>
@property (nonatomic, strong) LoginView * loginView;
@property (nonatomic, strong) PrivacyPolicyView * privacyPolicyView;

@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * password;
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


#pragma mark - login view delegate
-(void)loginViewTapActionType:(LoginViewTapActionType)type{
    if (type == LoginViewTapActionType_Login) {
        [[UserManager shareUserManager] loginWithPhone:self.account success:^(id  _Nonnull data) {
            
        } fail:^(NSInteger code) {
            
        }];
        MSLog(@"登录\n账户:%@\n密码:%@\n是否同意条款:%d",self.account,self.password,self.agreePrivacy);
        if ([[UserManager shareUserManager] getUser] == nil) {
            UserEntity * user = [[UserEntity alloc]init];
            user.userName = @"李静波";
            user.role = USER_ROLE_CUSTOMER;
            user.phone = @"16607093121";
            user.avaterImagePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576732013190&di=a566b0fff9b908ef63b10ad32e17e769&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Frushidao%2Fpics%2Fhv1%2F20%2F108%2F1744%2F113431160.jpg";
            [[UserManager shareUserManager] saveUser:user];
        }
        MainTabbarController * mainTabbarController = [MainTabbarController shareMainTabbarController];
        UIWindow * window = kKeyWindow;
        window.rootViewController = mainTabbarController;
        [window makeKeyAndVisible];
    } else if (type == LoginViewTapActionType_Privacy) {
        [self.privacyPolicyView addPopViewToWindow];
    } else if (type == LoginViewTapActionType_ForgetPassword) {
        MSLog(@"忘记密码");
    } else if (type == LoginViewTapActionType_Register) {
        MSLog(@"注册");
    } else if (type == LoginViewTapActionType_Wechat) {
        MSLog(@"微信登录");
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

#pragma mark - setters and getters
-(LoginView *)loginView{
    if (_loginView == nil) {
        _loginView = [[LoginView alloc]init];
        _loginView.delegate = self;
        _loginView.ableWechatLogin = [[WechatManager shareWechatManager] isWechatInstalled];
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
