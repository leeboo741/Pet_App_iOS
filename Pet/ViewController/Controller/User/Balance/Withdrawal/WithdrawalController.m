//
//  WithdrawalController.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "WithdrawalController.h"
#import "WithdrawalView.h"
#import "WithdrawalFlowController.h"

@interface WithdrawalController () <WithdrawalViewDelegate>
@property (nonatomic, strong) WithdrawalView * withdrawalView;
@property (nonatomic, copy) NSString * withdrawalAmount;
@property (nonatomic, copy) NSString * balanceAmount;
@property (nonatomic, copy) NSString * ableWithdrawalAmount;
@property (nonatomic, copy) NSString * disableWithdrawalAmount;
@end

@implementation WithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";
    
    [self.view addSubview:self.withdrawalView];
    
    self.balanceAmount = @"1412";
    self.ableWithdrawalAmount = @"700";
    self.disableWithdrawalAmount = @"712";
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.withdrawalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - withdrawalview delegate

-(void)tapWithdrawalButtonAtWithdrawalView:(WithdrawalView *)view {
    if (kStringIsEmpty(self.withdrawalAmount) || [self.withdrawalAmount intValue] == 0) {
        return;
    }
    MSLog(@"点击提现 金额 : %@", self.withdrawalAmount);
}

-(void)tapWithdrawalFlowButtonAtWithdrawalView:(WithdrawalView *)view {
    MSLog(@"点击提现流水");
    WithdrawalFlowController * withdrawalFlowController = [[WithdrawalFlowController alloc]init];
    [self.navigationController pushViewController:withdrawalFlowController animated:YES];
}

-(BOOL)textShouldChange:(UITextField *)textField text:(NSString *)text atWithdrawalView:(WithdrawalView *)view{
    if (Util_IsNumberString(text)) {
        self.withdrawalAmount = text;
        return YES;
    }
    return NO;
}

-(BOOL)textShouldBeginEditing:(UITextField *)textField atWithdrawalView:(WithdrawalView *)view{
    return YES;
}

-(void)textDidEndEditing:(UITextField *)textField atWithdrawalView:(WithdrawalView *)view{
    if ([self.withdrawalAmount intValue] > [self.ableWithdrawalAmount intValue] || [self.withdrawalAmount intValue] == 0) {
        self.withdrawalAmount = 0;
        [self.withdrawalView clearWithdrawlInput];
    }
}

#pragma mark - setters and getters

-(WithdrawalView *)withdrawalView{
    if (!_withdrawalView) {
        _withdrawalView = [[WithdrawalView alloc]init];
        _withdrawalView.delegate = self;
    }
    return _withdrawalView;
}

-(void)setBalanceAmount:(NSString *)balanceAmount{
    _balanceAmount = balanceAmount;
    self.withdrawalView.balance = balanceAmount;
}

-(void)setAbleWithdrawalAmount:(NSString *)ableWithdrawalAmount{
    _ableWithdrawalAmount = ableWithdrawalAmount;
    self.withdrawalView.ableWithdrawal = ableWithdrawalAmount;
}

-(void)setDisableWithdrawalAmount:(NSString *)disableWithdrawalAmount{
    _disableWithdrawalAmount = disableWithdrawalAmount;
    self.withdrawalView.disableWithdrawal = disableWithdrawalAmount;
}

@end
