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
@property (nonatomic, strong) TimeCountButton * getCodeButton; // 验证码获取按钮
@property (nonatomic, strong) UIButton * loginButton; // 登录按钮
//@property (nonatomic, strong) UIButton * forgetPasswordButton; // 忘记密码按钮
//@property (nonatomic, strong) UIButton * registerButton; // 注册按钮
@property (nonatomic, strong) UIButton * pravicyButton; // 隐私声明按钮
@property (nonatomic, strong) PrivacyPolicyView * privacyPolicyView; // 隐私政策弹窗
@property (nonatomic, strong) UIButton * wechatLoginButton;

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
        [self addSubview:self.getCodeButton];
        [self addSubview:self.loginButton];
        [self addSubview:self.wechatLoginButton];
//        [self addSubview:self.forgetPasswordButton];
//        [self addSubview:self.registerButton];
        [self addSubview:self.pravicyButton];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.3);
        make.height.equalTo(self.logoImageView.mas_width);
        make.centerY.equalTo(self).multipliedBy(0.4);
        make.centerX.equalTo(self);
    }];
    
    [self.accoutInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
        make.height.mas_equalTo(50);
    }];
    
    [self.passwordInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.accoutInputView);
        make.left.equalTo(self.accoutInputView);
        make.width.equalTo(self.accoutInputView).multipliedBy(0.5);
        make.top.equalTo(self.accoutInputView.mas_bottom).offset(20);
    }];
    
    [self.getCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.passwordInputView);
        make.left.equalTo(self.passwordInputView.mas_right).offset(5);
        make.right.equalTo(self.accoutInputView);
        make.centerY.equalTo(self.passwordInputView);
    }];
    
    [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.accoutInputView);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.passwordInputView.mas_bottom).offset(20);
    }];
    
    [self.wechatLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.loginButton);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
    }];
    
//    [self.forgetPasswordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.wechatLoginButton);
//        make.top.equalTo(self.wechatLoginButton.mas_bottom).offset(20);
//    }];
//
//    [self.registerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.loginButton);
//        make.centerY.equalTo(self.forgetPasswordButton);
//    }];
    [self.pravicyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
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

//-(void)forgetPassword{
//    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
//        [_delegate loginViewTapActionType:LoginViewTapActionType_ForgetPassword];
//    }
//}
//
//-(void)registerAction{
//    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
//        [_delegate loginViewTapActionType:LoginViewTapActionType_Register];
//    }
//}

-(void)wechatLogin{
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewTapActionType:)]) {
        [_delegate loginViewTapActionType:LoginViewTapActionType_Wechat];
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
        _accoutInputView.placeholder = @"请输入手机号";
        _accoutInputView.inputKeyboardType = UIKeyboardTypePhonePad;
    }
    return _accoutInputView;
}

-(InputAreaView *)passwordInputView{
    if (_passwordInputView == nil) {
        _passwordInputView = [[InputAreaView alloc]init];
        _passwordInputView.iconImageName = Image_Password;
        _passwordInputView.secureTextEntry = YES;
        _passwordInputView.placeholder = @"验证码";
        _passwordInputView.delegate = self;
        _passwordInputView.hideIcon = YES;
        _passwordInputView.inputAlignment = NSTextAlignmentCenter;
        _passwordInputView.inputKeyboardType = UIKeyboardTypeNumberPad;
    }
    return _passwordInputView;
}

-(TimeCountButton *)getCodeButton{
    if (_getCodeButton == nil) {
        _getCodeButton = [[TimeCountButton alloc]init];
        _getCodeButton.delegate = self.timeCountDelegate;
    }
    return _getCodeButton;
}

-(void)setTimeCountDelegate:(id<TimeCountButtonDelegate>)timeCountDelegate{
    _timeCountDelegate = timeCountDelegate;
    self.getCodeButton.delegate = timeCountDelegate;
}

-(TimeCountState)state{
    return self.getCodeButton.state;
}

-(UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton setTitle:@"手机号登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = kRGBColor(255, 165, 0);
        _loginButton.layer.cornerRadius = 10;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize: 18];
        [_loginButton addTarget:self action:@selector(tapLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton *)wechatLoginButton{
    if (_wechatLoginButton == nil) {
        _wechatLoginButton = [[UIButton alloc] init];
//        [_wechatLoginButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Wechat, 32, Color_green_wechat)] forState:UIControlStateNormal];
//        [_wechatLoginButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Wechat, 32, Color_gray_1)]  forState:UIControlStateDisabled];
//        _wechatLoginButton.enabled = self.ableWechatLogin;
        [_wechatLoginButton setTitle:@"微信授权登录" forState:UIControlStateNormal];
        [_wechatLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wechatLoginButton setTitle:@"尚未安装微信" forState:UIControlStateDisabled];
        [_wechatLoginButton setTitleColor:Color_gray_1 forState:UIControlStateDisabled];
        _wechatLoginButton.enabled = self.ableWechatLogin;
        if (self.ableWechatLogin) {
            [self.wechatLoginButton setBackgroundColor:Color_green_wechat];
        } else {
            [self.wechatLoginButton setBackgroundColor:Color_gray_2];
        }
        _wechatLoginButton.layer.cornerRadius = 10;
        _wechatLoginButton.titleLabel.font = [UIFont systemFontOfSize: 18];
        [_wechatLoginButton addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatLoginButton;
}

//-(UIButton *)forgetPasswordButton{
//    if (!_forgetPasswordButton) {
//        _forgetPasswordButton = [[UIButton alloc]init];
//        NSString * title = @"忘记密码?";
//        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:Color_blue_1,NSUnderlineStyleAttributeName:kIntegerNumber(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:15],NSUnderlineColorAttributeName:Color_blue_1}];
//        [_forgetPasswordButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        [_forgetPasswordButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _forgetPasswordButton;
//}
//
//-(UIButton *)registerButton{
//    if (!_registerButton) {
//        _registerButton = [[UIButton alloc]init];
//        NSString * title = @"没有账号,前往注册!";
//
//        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:Color_blue_1,NSUnderlineStyleAttributeName:kIntegerNumber(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:15],NSUnderlineColorAttributeName:Color_blue_1}];
//        [_registerButton setAttributedTitle:attributeStr forState:UIControlStateNormal];
//        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _registerButton;
//}

-(UIButton *)pravicyButton {
    if(_pravicyButton == nil) {
        _pravicyButton = [[UIButton alloc]init];
        [_pravicyButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_blue_1)] forState:UIControlStateNormal];
        
        [_pravicyButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_blue_1)] forState:UIControlStateSelected];
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName:kIntegerNumber(NSUnderlineStyleSingle) ,NSForegroundColorAttributeName:Color_blue_1};
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

-(void)setAbleWechatLogin:(BOOL)ableWechatLogin{
    _ableWechatLogin = ableWechatLogin;
    self.wechatLoginButton.enabled = ableWechatLogin;
    if (ableWechatLogin) {
        [self.wechatLoginButton setBackgroundColor:Color_green_wechat];
    } else {
        [self.wechatLoginButton setBackgroundColor:Color_gray_2];
    }
}
@end
