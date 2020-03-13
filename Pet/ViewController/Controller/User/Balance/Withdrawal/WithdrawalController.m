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
#import "SiteBalanceManager.h"
#import "BusinessBalanceManager.h"

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
    
    self.balanceAmount = [NSString stringWithFormat:@"%.2f",[[UserManager shareUserManager] getBalance]]; 
    self.ableWithdrawalAmount = @"0";
    self.disableWithdrawalAmount = @"0";
    // Do any additional setup after loading the view.
    
    [self getBalanceBuffer];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.withdrawalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - private method

-(void)getBalanceBuffer{
    __weak typeof(self) weakSelf = self;
    if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_STAFF) {
        [[SiteBalanceManager shareSiteBalanceManager] getBalanceBufferWithStationNo:[[UserManager shareUserManager] getStationNo] success:^(id  _Nonnull data) {
            SiteBalanceBuffer * buffer = (SiteBalanceBuffer *)data;
            weakSelf.ableWithdrawalAmount = [NSString stringWithFormat:@"%.2f",buffer.usable];
            weakSelf.disableWithdrawalAmount = [NSString stringWithFormat:@"%.2f",buffer.frozen];
        } fail:^(NSInteger code) {
        }];
    } else if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_BUSINESS) {
        [[BusinessBalanceManager shareBusinessBalanceManager] getBalanceBufferWithBusinessNo:[[UserManager shareUserManager] getBusinessNo] success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            BusinessBalanceBuffer * buffer = (BusinessBalanceBuffer *)data;
            weakSelf.ableWithdrawalAmount = [NSString stringWithFormat:@"%.2f",buffer.usable];
            weakSelf.disableWithdrawalAmount = [NSString stringWithFormat:@"%.2f",buffer.frozen];
        } fail:^(NSInteger code) {
        }];
    }
}

-(void)beWithdrawWithAmount:(CGFloat)amount{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:@"提交中..."];
    if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_STAFF) {
        [[SiteBalanceManager shareSiteBalanceManager] withDrawByCustomerNo:[[UserManager shareUserManager] getCustomerNo] amount:amount success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            [weakSelf handlerWithdrawData:data];
        } fail:^(NSInteger code) {
            
        }];
    } else if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_BUSINESS) {
        [[BusinessBalanceManager shareBusinessBalanceManager] withDrawByBusinessNo:[[UserManager shareUserManager] getBusinessNo] amount:amount success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            [weakSelf handlerWithdrawData:data];
        } fail:^(NSInteger code) {
            
        }];
    }
}

-(void)handlerWithdrawData:(id)data{
    if ([data intValue] >= 1) {
        [MBProgressHUD showTipMessageInWindow:@"提交成功,等待审核"];
        self.withdrawalAmount = 0;
        [self.withdrawalView clearWithdrawlInput];
        [self getBalanceBuffer];
    } else {
        [MBProgressHUD showTipMessageInWindow:@"提交失败,请稍后再试"];
    }
}

#pragma mark - withdrawalview delegate

-(void)tapWithdrawalButtonAtWithdrawalView:(WithdrawalView *)view {
    if (kStringIsEmpty(self.withdrawalAmount) || [self.withdrawalAmount intValue] == 0) {
        return;
    }
    [self beWithdrawWithAmount:[self.withdrawalAmount floatValue]];
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
        [MBProgressHUD showErrorMessage:@"超出可提现金额范围"];
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
