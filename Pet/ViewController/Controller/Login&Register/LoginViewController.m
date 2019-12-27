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
        UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [self presentViewController:navi animated:YES completion:nil];
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
