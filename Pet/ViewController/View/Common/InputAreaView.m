//
//  InputAreaView.m
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "InputAreaView.h"

@interface InputAreaView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UITextField * inputView;
@end

@implementation InputAreaView

#pragma mark - life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = kRGBColor(245, 245, 245);
        self.layer.cornerRadius = 10;
        self.secureTextEntry = NO;
        [self addSubview:self.iconImageView];
        [self addSubview:self.inputView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.height.equalTo(self).offset(-16);
        make.width.equalTo(self.mas_height).offset(-16);
    }];
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
}

#pragma mark - textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(inputAreaViewInputAction:atInputArea:)]) {
        [_delegate inputAreaViewInputAction:[textField.text stringByReplacingCharactersInRange:range withString:string] atInputArea:self];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(inputAreaViewInputAction:atInputArea:)]) {
        [_delegate inputAreaViewInputAction:@"" atInputArea:self];
    }
    return YES;
}


#pragma mark - setters and getters

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:self.iconImageName];
    }
    return _iconImageView;
}

-(UIView *)inputView{
    if (_inputView == nil) {
        _inputView = [[UITextField alloc]init];
        _inputView.delegate = self;
        _inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputView.placeholder = self.placeholder;
        _inputView.secureTextEntry = self.secureTextEntry;
    }
    return _inputView;
}

-(NSString *)placeholder{
    if (_placeholder == nil) {
        _placeholder = @"请输入内容";
    }
    return _placeholder;
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    self.inputView.secureTextEntry = secureTextEntry;
}

-(void)setText:(NSString *)text{
    _text = text;
    if (![self.inputView.text isEqualToString:text]) {
        self.inputView.text = text;
    }
}

-(void)setIconImageName:(NSString *)iconImageName{
    _iconImageName = iconImageName;
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
}

@end
