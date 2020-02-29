//
//  PaymentInfoCell.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PaymentInfoCell.h"

@interface PaymentInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation PaymentInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPaymentPrice:(CGFloat)paymentPrice{
    _paymentPrice = paymentPrice;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",paymentPrice];
}

@end
