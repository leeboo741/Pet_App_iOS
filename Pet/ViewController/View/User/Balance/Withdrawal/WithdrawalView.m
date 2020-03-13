//
//  WithdrawalView.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "WithdrawalView.h"

@interface WithdrawalView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ableWithdrawalLabel;
@property (weak, nonatomic) IBOutlet UILabel *disableWithdrawalLabel;
@property (weak, nonatomic) IBOutlet UITextField *withdrawalTextField;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalFlowButton;

@end

@implementation WithdrawalView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    [[NSBundle mainBundle] loadNibNamed:@"WithdrawalView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.withdrawalButton.layer.cornerRadius = 10;
    self.withdrawalTextField.delegate = self;
    self.withdrawalTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.backgroundColor = Color_white_1;
}

#pragma mark - event action

- (IBAction)tapButton:(id)sender {
    [self.withdrawalTextField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(tapWithdrawalButtonAtWithdrawalView:)]) {
        [_delegate tapWithdrawalButtonAtWithdrawalView:self];
    }
}

- (IBAction)tapFlowButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tapWithdrawalFlowButtonAtWithdrawalView:)]) {
        [_delegate tapWithdrawalFlowButtonAtWithdrawalView:self];
    }
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(textShouldBeginEditing:atWithdrawalView:)]) {
        return [_delegate textShouldBeginEditing:textField atWithdrawalView:self];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_delegate && [_delegate respondsToSelector:@selector(textShouldChange:text:atWithdrawalView:)]) {
        return [_delegate textShouldChange:textField text:text atWithdrawalView:self];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(textDidEndEditing:atWithdrawalView:)]) {
        [_delegate textDidEndEditing:textField atWithdrawalView:self];
    }
}

#pragma mark - setters and getters

-(void)setBalance:(NSString *)balance{
    _balance = balance;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@元",balance];
}

-(void)setAbleWithdrawal:(NSString *)ableWithdrawal{
    _ableWithdrawal = ableWithdrawal;
    self.ableWithdrawalLabel.text = [NSString stringWithFormat:@"%@元",ableWithdrawal];
}

-(void)setDisableWithdrawal:(NSString *)disableWithdrawal{
    _disableWithdrawal = disableWithdrawal;
    self.disableWithdrawalLabel.text = [NSString stringWithFormat:@"%@元",disableWithdrawal];
}

#pragma mark - public method

-(void)clearWithdrawlInput{
    
    self.withdrawalTextField.text = @"";
}

@end
