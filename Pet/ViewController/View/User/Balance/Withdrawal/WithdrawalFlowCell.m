//
//  WithdrawalFlowCell.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "WithdrawalFlowCell.h"

@interface WithdrawalFlowCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation WithdrawalFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAmount:(NSString *)amount{
    _amount = amount;
    self.amountLabel.text = [NSString stringWithFormat:@"￥%@",amount];
}

-(void)setTime:(NSString *)time{
    _time = time;
    self.timeLabel.text = time;
}

-(void)setState:(NSString *)state{
    _state = state;
    self.stateLabel.text = state;
    if ([state isEqualToString:@"已审核"]) {
        self.stateLabel.textColor = Color_green_1;
    } else if ([state isEqualToString:@"已驳回"]) {
        self.stateLabel.textColor = Color_red_1;
    } else if ([state isEqualToString:@"待审核"]) {
        self.stateLabel.textColor = Color_black_1;
    }
}

@end
