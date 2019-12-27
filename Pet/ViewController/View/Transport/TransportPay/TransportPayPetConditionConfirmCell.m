//
//  TransportPayPetConditionConfirmCell.m
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportPayPetConditionConfirmCell.h"

@interface TransportPayPetConditionConfirmCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UILabel *confirmTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *confirmIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@end

@implementation TransportPayPetConditionConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isConfirm = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapConfirm)];
    [self.confirmView addGestureRecognizer:tap];
    self.conditionLabel.textColor = Color_gray_2;
    self.conditionText = @"1、处于未妊娠期。\n2、48小时以内未进行任何手术或分娩。\n3、宠物年龄不小于两个月。\n4、不患有任何疾病。";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - event action
-(void)tapConfirm{
    if (_delegate && [_delegate respondsToSelector:@selector(transportPayPetConditionConfirmCellTapConfirmButton:)]) {
        [_delegate transportPayPetConditionConfirmCellTapConfirmButton:self];
    }
}

#pragma mark - private method
-(void)changeConfirmState{
    self.confirmTitleLabel.text = @"请确认宠物符合以下条件";
    if (self.isConfirm) {
        self.confirmIconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_red_2)];
        self.confirmTitleLabel.textColor = Color_red_2;
    } else {
        self.confirmIconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_blue_1)];
        self.confirmTitleLabel.textColor = Color_blue_1;
    }
}


#pragma mark - setters and getters
-(void)setIsConfirm:(BOOL)isConfirm{
    _isConfirm = isConfirm;
    [self changeConfirmState];
}

-(void)setConditionText:(NSString *)conditionText{
    _conditionText = conditionText;
    if (Util_IsEmptyString(conditionText)) return;
    self.conditionLabel.text = conditionText;
    [UILabel changeLineSpaceForLabel:self.conditionLabel WithSpace:5.0];
}


@end
