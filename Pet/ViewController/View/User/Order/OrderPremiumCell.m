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
@property (weak, nonatomic) IBOutlet UILabel *orderPremiumStateLabel;

@end

@implementation OrderPremiumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

#pragma mark - setters and getters

-(void)setPremiumAmount:(NSString *)premiumAmount {
    _premiumAmount = premiumAmount;
    self.orderPremiumAmountLabel.text = premiumAmount;
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
}

@end
