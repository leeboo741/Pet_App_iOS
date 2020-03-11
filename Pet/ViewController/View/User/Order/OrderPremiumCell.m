//
//  OrderPremiumCell.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderPremiumCell.h"

@interface OrderPremiumCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderPremiumAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPremiumReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPremiumTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *orderPremiumStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonWidthConstraint;

@end

static NSString * unpayStr = @"待付款";
@implementation OrderPremiumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cancelButton.layer.cornerRadius = 8;
    self.button.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tapPremiumButtonWithState:atOrderPremiumCell:)]) {
        [_delegate tapPremiumButtonWithState:self.premiumState atOrderPremiumCell:self];
    }
}
- (IBAction)tapCancelButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tapPremiumCancelButtonAtOrderPremiumCell:)]) {
        [_delegate tapPremiumCancelButtonAtOrderPremiumCell:self];
    }
}

#pragma mark - setters and getters

-(void)setPremiumAmount:(NSString *)premiumAmount {
    _premiumAmount = premiumAmount;
    self.orderPremiumAmountLabel.text = [NSString stringWithFormat:@"￥%@",premiumAmount];
}

-(void)setPremiumReason:(NSString *)premiumReason {
    _premiumReason = premiumReason;
    self.orderPremiumReasonLabel.text = premiumReason;
}

-(void)setPremiumTime:(NSString *)premiumTime {
    _premiumTime = premiumTime;
    self.orderPremiumTimeLabel.text = premiumTime;
}

-(void)setPremiumState:(NSString *)premiumState {
    _premiumState = premiumState;
    self.orderPremiumStateLabel.text = premiumState;
    if ([unpayStr isEqualToString:premiumState]) {
        self.orderPremiumStateLabel.textColor = Color_red_1;
    } else {
        self.orderPremiumStateLabel.textColor = Color_blue_1;
    }
    [self changePayButtonShow];
    [self changeCancelButtonShow];
}

-(void)changePayButtonShow{
    if (![unpayStr isEqualToString:self.premiumState]
        || [[UserManager shareUserManager] getCurrentUserRole] != CURRENT_USER_ROLE_CUSTOMER) {
        self.button.hidden = YES;
        self.payButtonWidthConstraint.constant = 0;
    } else {
        self.button.hidden = NO;
        self.payButtonWidthConstraint.constant = 60;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)changeCancelButtonShow{
    if (![unpayStr isEqualToString:self.premiumState] || [[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_CUSTOMER) {
        self.cancelButton.hidden = YES;
        self.cancelButtonWidthConstraint.constant = 0;
    } else {
        self.cancelButton.hidden = NO;
        self.cancelButtonWidthConstraint.constant = 60;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
