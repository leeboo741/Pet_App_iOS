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

@interface LoginViewController ()<LoginViewDelegate, PrivacyPolicyViewDelegate>
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
        NSLog(@"登录\n账户:%@\n密码:%@\n是否同意条款:%d",self.account,self.password,self.agreePrivacy);
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
    }
}

-(void)loginViewInputActionType:(LoginViewInputActionType)type inputText:(NSString *)inputText{
    if (type == LoginViewInputActionType_Account) {
        self.account = inputText;
    } else if (type == LoginViewInputActionType_Password) {
        self.password = inputText;
    }
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
