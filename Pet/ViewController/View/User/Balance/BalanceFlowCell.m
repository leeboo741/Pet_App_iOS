//
//  BalanceFlowCell.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "BalanceFlowCell.h"

@interface BalanceFlowCell ()
@property (weak, nonatomic) IBOutlet UILabel *linkNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterBalanceAmoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowTimeLabel;

@end

@implementation BalanceFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLinkNo:(NSString *)linkNo{
    _linkNo = linkNo;
    self.linkNoLabel.text = linkNo;
}

-(void)setFlowTime:(NSString *)flowTime{
    _flowTime = flowTime;
    self.flowTimeLabel.text = flowTime;
}

-(void)setFlowType:(NSString *)flowType {
    _flowTime = flowType;
    self.flowTypeLabel.text = flowType;
}

-(void)setFlowAmount:(NSString *)flowAmount{
    _flowAmount = flowAmount;
    self.flowAmountLabel.text = [NSString stringWithFormat:@"￥%@",flowAmount];
    if ([flowAmount intValue] < 0) {
        self.flowAmountLabel.textColor = Color_red_1;
    } else {
        self.flowAmountLabel.textColor = Color_green_1;
    }
}

-(void)setAfterBalanceAmount:(NSString *)afterBalanceAmount{
    _afterBalanceAmount = afterBalanceAmount;
    self.afterBalanceAmoutLabel.text = [NSString stringWithFormat:@"￥%@",afterBalanceAmount];
}

@end
