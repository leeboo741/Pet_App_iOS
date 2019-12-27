//
//  TransportPayContractConfirmCell.m
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportPayContractConfirmCell.h"

@interface TransportPayContractConfirmCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIImageView *confirmIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *contractInfoLabel;

@end

@implementation TransportPayContractConfirmCell

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isConfirm = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapConfirm)];
    [self.confirmView addGestureRecognizer:tap];
    self.contractInfoLabel.text = @"下单后会有专人联系您已确定发运航班等信息，如未发运，全额退款。";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - event action
-(void)tapConfirm{
    if (_delegate && [_delegate respondsToSelector:@selector(transportPayContractConfirmCellTapConfirm:)]) {
        [_delegate transportPayContractConfirmCellTapConfirm:self];
    }
}

#pragma mark - private method
-(void)changeConfirmState{
    self.confirmTitlelabel.text = @"已阅读并同意《宠物托运交易条款》";
    if (self.isConfirm) {
        self.confirmIconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_red_2)];
        self.confirmTitlelabel.textColor = Color_red_2;
    } else {
        self.confirmIconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_blue_1)];
        self.confirmTitlelabel.textColor = Color_blue_1;
    }
}


#pragma mark - setters and getters
-(void)setIsConfirm:(BOOL)isConfirm{
    _isConfirm = isConfirm;
    [self changeConfirmState];
}

@end
