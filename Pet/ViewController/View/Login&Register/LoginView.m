//
//  LoginView.m
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "LoginView.h"
#import "InputAreaView.h"
#import "PrivacyPolicyView.h"

@interface LoginView ()<InputAreaViewDelegate>
@property (nonatomic, strong) UIImageView * logoImageView; // logo
@property (nonatomic, strong) InputAreaView * accoutInputView; // 账号输入框
@property (nonatomic, strong) InputAreaView * passwordInputView; // 密码输入框
@property (nonatomic, strong) UIButton * loginButton; // 登录按钮
@property (nonatomic, strong) UIButton * forgetPasswordButton; // 忘记密码按钮
@property (nonatomic, strong) UIButton * registerButton; // 注册按钮
@property (nonatomic, strong) UIButton * pravicyButton; // 隐私声明按钮
@property (nonatomic, strong) PrivacyPolicyView * privacyPolicyView; // 隐私政策弹窗

@end

@implementation LoginView

#pragma mark - life cycle
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.logoImageView];
        [self addSubview:self.accoutInputView];
        [self addSubview:self.passwordInputView];
        [self addSubview:self.loginButton];
        [self addSubview:self.forgetPasswordButton];
        [self addSubview:self.registerButton];
        [self addSubview:self.pravicyButton];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(160);
        make.top.equalTo(self).offset(160);
        make.centerX.equalTo(self);
    }];
    
    [self.accoutInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
        make.height.mas_equalTo(50);
    }];
    
    [self.passwordInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self.accoutInputView);
        make.top.equalTo(self.accoutInputView.mas_bottom).offset(30);
    }];
    
    [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.passwordInputView);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.passwordInputView.mas_bottom).offset(30);
    }];
    
    [self.forgetPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton);
        make.top.equalTo(self.loginButton.mas_bottom).offset(30);
    }];
    
    [self.registerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginButton);
        make.centerY.equalTo(self.forgetPasswordButton);
    }];
    
    [self.pravicyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-60);
        make.width.centerX.equalTo(self.loginButton);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - action
-(void)tapLoginButton{
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
        [_delegate loginViewTapActionType:LoginViewTapActionType_Login];
    }
}

-(void)tapPravicayButton{
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
        [_delegate loginViewTapActionType:LoginViewTapActionType_Privacy];
    }
}

-(void)forgetPassword{
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
        [_delegate loginViewTapActionType:LoginViewTapActionType_ForgetPassword];
    }
}

-(void)registerAction{
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
        [_delegate loginViewTapActionType:LoginViewTapActionType_Register];
    }
}

#pragma mark - inputAreaView delegate
-(void)inputAreaViewInputAction:(NSString *)text atInputArea:(nonnull InputAreaView *)inputAreaView{
    LoginViewInputActionType tempType = LoginViewInputActionType_Account;
    if (inputAreaView == _passwordInputView) {
        tempType = LoginViewInputActionType_Password;
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(loginViewInputActionType:inputText:)]) {
        [_delegate loginViewInputActionType:tempType inputText:text];
    }
}

#pragma mark - setters and getters
-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:self.logoImageName];
    }
    return _logoImageView;
}

-(InputAreaView *)accoutInputView{
    if (_accoutInputView == nil) {
        _accoutInputView = [[InputAreaView alloc]init];
        _accoutInputView.iconImageName = Image_Account;
        _accoutInputView.delegate = self;
    }
    return _accoutInputView;
}

-(InputAreaView *)passwordInputView{
    if (_passwordInputView == nil) {
        _passwordInputView = [[InputAreaView alloc]init];
        _passwordInputView.iconImageName = Image_Password;
        _passwordInputView.secureTextEntry = YES;
        _passwordInputView.delegate = self;
    }
    return _passwordInputView;
}

-(UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = kRGBColor(255, 165, 0);
        _loginButton.layer.cornerRadius = 10;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize: 20];
        [_loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)forgetPasswordButton{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [[UIButton alloc]init];
        NSString * title = @"忘记密码?";
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:Color_blue_1,NSUnderlineStyleAttributeName:kIntegerNumber(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:15],NSUnderlineColorAttributeName:Color_blue_1}];
        [_forgetPasswordButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [_forgetPasswordButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}

-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc]init];
        NSString * title = @"没有账号,前往注册!";
        
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:Color_blue_1,NSUnderlineStyleAttributeName:kIntegerNumber(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:15],NSUnderlineColorAttributeName:Color_blue_1}];
        [_registerButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIButton *)pravicyButton {
    if(_pravicyButton == nil) {
        _pravicyButton = [[UIButton alloc]init];
        [_pravicyButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_blue_1)] forState:UIControlStateNormal];
        
        [_pravicyButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_blue_1)] forState:UIControlStateSelected];
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:Color_blue_1};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"您已阅读并同意<隐私条款>" attributes:attribtDic];
        [_pravicyButton setAttributedTitle:attribtStr forState:UIControlStateNormal];
        _pravicyButton.titleLabel.font = kFontSize(15);
        [_pravicyButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
        _pravicyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_pravicyButton addTarget:self action:@selector(tapPravicayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pravicyButton;
}

-(PrivacyPolicyView *)privacyPolicyView{
    if (_privacyPolicyView == nil) {
        _privacyPolicyView = [[PrivacyPolicyView alloc]init];
    }
    return _privacyPolicyView;
}

-(NSString *)logoImageName{
    if (_logoImageName == nil) {
        _logoImageName = @"logo";
    }
    return _logoImageName;
}

-(void)setAccount:(NSString *)account{
    _account = account;
    if (![self.accoutInputView.text isEqualToString:account]) {
        self.accoutInputView.text = account;
    }
}

-(void)setPassword:(NSString *)password{
    _password = password;
    if (![self.passwordInputView.text isEqualToString:password]) {
        self.passwordInputView.text = password;
    }
}

-(void)setAgreePrivacy:(BOOL)agreePrivacy{
    _agreePrivacy = agreePrivacy;
    self.pravicyButton.selected = agreePrivacy;
}
@end
