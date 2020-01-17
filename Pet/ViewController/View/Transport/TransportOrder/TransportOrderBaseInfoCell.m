//
//  TransportOrderBaseInfoCell.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrderBaseInfoCell.h"
#import "SelectActionLabel.h"

@interface TransportOrderBaseInfoCell ()<SelectActionLabelDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet SelectActionLabel *startCitySelectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;
@property (weak, nonatomic) IBOutlet SelectActionLabel *endCitySelectLabel;
@property (weak, nonatomic) IBOutlet SelectActionLabel *timeSelectLabel;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet SelectActionLabel *typeSelectLabel;
@property (weak, nonatomic) IBOutlet UITextField *breedTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet SelectActionLabel *ageSelectLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation TransportOrderBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = Color_gray_1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _boxView.layer.cornerRadius = 10;
    _transportImageView.layer.cornerRadius = 20;
    _transportImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_AirPlane, 35, Color_yellow_1)];
    
    _startCitySelectLabel.placeholderStr = @"出发城市";
    _startCitySelectLabel.textAlignment = NSTextAlignmentCenter;
    _startCitySelectLabel.delegate = self;
    _endCitySelectLabel.placeholderStr = @"目的城市";
    _endCitySelectLabel.textAlignment = NSTextAlignmentCenter;
    _endCitySelectLabel.delegate = self;
    _timeSelectLabel.placeholderStr = @"请选择出发时间";
    _timeSelectLabel.textAlignment = NSTextAlignmentCenter;
    _timeSelectLabel.delegate = self;
    _typeSelectLabel.placeholderStr = @"宠物种类";
    _typeSelectLabel.textAlignment = NSTextAlignmentCenter;
    _typeSelectLabel.delegate = self;
    _ageSelectLabel.placeholderStr = @"宠物年龄";
    _ageSelectLabel.textAlignment = NSTextAlignmentCenter;
    _ageSelectLabel.delegate = self;
    
    _countTextField.attributedPlaceholder = [self getTextFieldAttributeWithPlaceholder:@"数量"];
    _countTextField.keyboardType = UIKeyboardTypeNumberPad;
    _countTextField.delegate = self;
    _countTextField.textColor = Color_black_1;
    _countTextField.font = kFontSize(17);
    _countTextField.textAlignment = NSTextAlignmentCenter;
    _breedTextField.attributedPlaceholder = [self getTextFieldAttributeWithPlaceholder:@"宠物品种"];
    _breedTextField.delegate = self;
    _breedTextField.textColor = Color_black_1;
    _breedTextField.font = kFontSize(17);
    _breedTextField.textAlignment = NSTextAlignmentCenter;
    _weightTextField.attributedPlaceholder = [self getTextFieldAttributeWithPlaceholder:@"重量"];
    _weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _weightTextField.delegate = self;
    _weightTextField.textColor = Color_black_1;
    _weightTextField.font = kFontSize(17);
    _weightTextField.textAlignment = NSTextAlignmentCenter;
    _nameTextField.attributedPlaceholder = [self getTextFieldAttributeWithPlaceholder:@"宠物姓名"];
    _nameTextField.delegate = self;
    _nameTextField.textColor = Color_black_1;
    _nameTextField.font = kFontSize(17);
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:TransportOrderCityChangeKey object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - notification

-(void)cityChange:(NSNotification *)notification{
    NSString * startCity = [notification.userInfo objectForKey:TransportOrderStartCityNotificationKey];
    NSString * endCity = [notification.userInfo objectForKey:TransportOrderEndCityNotificationKey];
    if (!kStringIsEmpty(startCity)) {
        self.startCity = startCity;
    }
    if (!kStringIsEmpty(endCity)) {
        self.endCity = endCity;
    }
}

#pragma mark - select action label delegate
-(void)selectActionLabelClickAction:(SelectActionLabel *)selectActionLabel{
    TransportBaseInfo_Type type = TransportBaseInfo_Type_StartCity;
    if (selectActionLabel == self.startCitySelectLabel) {
        type = TransportBaseInfo_Type_StartCity;
    } else if (selectActionLabel == self.endCitySelectLabel) {
        type = TransportBaseInfo_Type_EndCity;
    } else if (selectActionLabel == self.timeSelectLabel) {
        type = TransportBaseInfo_Type_Time;
    } else if (selectActionLabel == self.typeSelectLabel) {
        type = TransportBaseInfo_Type_Type;
    } else if (selectActionLabel == self.ageSelectLabel) {
        type = TransportBaseInfo_Type_Age;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectBaseInfoItem:)]) {
        [_delegate selectBaseInfoItem:type];
    }
}

#pragma mark - textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    TransportBaseInfo_Type type = TransportBaseInfo_Type_Count;
    if (textField == self.countTextField) {
        type = TransportBaseInfo_Type_Count;
    } else if (textField == self.breedTextField) {
        type = TransportBaseInfo_Type_Breed;
    }else if (textField == self.weightTextField) {
        type = TransportBaseInfo_Type_Weight;
    } else if (textField == self.nameTextField) {
        type = TransportBaseInfo_Type_Name;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(endingInputBaseInfoItem:)]) {
        [_delegate endingInputBaseInfoItem:type];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    TransportBaseInfo_Type type = TransportBaseInfo_Type_Count;
    if (textField == self.countTextField) {
        if (![Utils isNumberString:text] && ![text isEqualToString:@""]) {
            return NO;
        }
        type = TransportBaseInfo_Type_Count;
    } else if (textField == self.breedTextField) {
        type = TransportBaseInfo_Type_Breed;
    } else if (textField == self.weightTextField) {
        if (![Utils isNumberString:text] && ![text isEqualToString:@""]) {
            return NO;
        }
        type = TransportBaseInfo_Type_Weight;
    } else if (textField == self.nameTextField) {
        type = TransportBaseInfo_Type_Name;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputBaseInfoItem:withText:)]) {
        [_delegate inputBaseInfoItem:type withText:text];
    }
    return YES;
}

#pragma mark - private method
-(NSMutableAttributedString* )getTextFieldAttributeWithPlaceholder:(NSString *)placeholder{
    NSMutableAttributedString *attrString
    = [[NSMutableAttributedString alloc]
       initWithString:placeholder
       attributes:@{
                     NSForegroundColorAttributeName:Color_gray_2,
                     NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                    }];
    return attrString;
}

#pragma mark - setters and getters
-(void)setStartCity:(NSString *)startCity{
    _startCity = startCity;
    self.startCitySelectLabel.normalStr = startCity;
}
-(void)setEndCity:(NSString *)endCity{
    _endCity = endCity;
    self.endCitySelectLabel.normalStr = endCity;
}
-(void)setPetType:(NSString *)petType{
    _petType = petType;
    self.typeSelectLabel.normalStr = petType;
}
-(void)setOutTime:(NSString *)outTime{
    _outTime = outTime;
    self.timeSelectLabel.normalStr = outTime;
}
-(void)setPetAge:(NSString *)petAge{
    _petAge = petAge;
    self.ageSelectLabel.normalStr = petAge;
}
-(void)setPetCount:(NSString *)petCount{
    _petCount = petCount;
    self.countTextField.text = petCount;
}
-(void)setPetWeight:(NSString *)petWeight{
    _petWeight = petWeight;
    self.weightTextField.text = petWeight;
}
-(void)setPetBreed:(NSString *)petBreed{
    _petBreed = petBreed;
    self.breedTextField.text = petBreed;
}
-(void)setPetName:(NSString *)petName{
    _petName = petName;
    self.nameTextField.text = petName;
}

@end
