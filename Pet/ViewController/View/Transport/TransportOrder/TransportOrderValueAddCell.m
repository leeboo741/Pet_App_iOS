//
//  TransportOrderValueAddCell.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrderValueAddCell.h"

@interface TransportOrderValueAddCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UIView *headerArea;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceContractLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (nonatomic, strong) UITapGestureRecognizer * headerAreaTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer * contractTapGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIView *inputArea;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputAreaHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *infoArea;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoAreaHeightConstraint;


@end

@implementation TransportOrderValueAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.inputArea];
    [self.boxView addSubview:self.infoArea];
    [self addKVO];
    self.inputTextField.delegate = self;
    self.serviceEnableTap = YES;
    self.serviceIsSelected = NO;
    self.showInfoArea = NO;
    self.showInputArea = NO;
    self.infoLabel.textColor = Color_red_2;
    self.serviceContractLabel.textColor = Color_blue_1;
    self.serviceDetailLabel.textColor = Color_red_2;
    self.inputTextField.textColor = Color_black_1;
    self.inputTextField.font = kFontSize(16);
    self.serviceInfo = @"";
    [self contractTapGestureRecognizer];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [self removeKVO];
}

#pragma mark - KVO
-(void)addKVO{
    [self addObserver:self forKeyPath:@"serviceEnableTap" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"serviceIsSelected" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"showInputArea" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"showInfoArea" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeKVO{
    [self removeObserver:self forKeyPath:@"serviceEnableTap"];
    [self removeObserver:self forKeyPath:@"serviceIsSelected"];
    [self removeObserver:self forKeyPath:@"showInputArea"];
    [self removeObserver:self forKeyPath:@"showInfoArea"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"serviceEnableTap"]) {
        [self addHeaderTap];
    } else if ([keyPath isEqualToString:@"serviceIsSelected"]) {
        [self serviceSelect];
    } else if ([keyPath isEqualToString:@"showInputArea"]) {
        [self changeServiceValueShow];
    } else if ([keyPath isEqualToString:@"showInfoArea"]) {
        [self changeServiceInfoShow];
    }
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(valueAddCell:serviceValueInputShouldBeginEditing:)]) {
        return [_delegate valueAddCell:self serviceValueInputShouldBeginEditing:textField];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_delegate && [_delegate respondsToSelector:@selector(valueAddCell:serviceValueinput:afterChangeText:)]) {
        return [_delegate valueAddCell:self serviceValueinput:textField afterChangeText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(valueAddCell:serviceValueinputDidEndEditing:)]) {
        [_delegate valueAddCell:self serviceValueinputDidEndEditing:textField];
    }
}

#pragma mark - private method
-(void)serviceSelect{
    [self changeHeaderShow];
    [self changeServiceValueShow];
}

-(void)changeHeaderShow{
    if (self.serviceIsSelected) {
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_red_2)];
        self.serviceNameLabel.textColor = Color_red_2;
    } else {
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_gray_2)];
        self.serviceNameLabel.textColor = Color_gray_2;
    }
}

-(void)changeServiceValueShow{
    CGFloat constant;
    if (self.serviceIsSelected && self.showInputArea) {
        constant = 60;
        self.inputTextField.text = self.serviceValue;
    } else {
        constant = 0.01;
        self.inputTextField.text = @"";
    }
    self.inputAreaHeightConstraint.constant = constant;
    
}
-(void)changeServiceInfoShow{
    CGFloat constant;
    if (self.showInfoArea) {
        constant = 60;
    } else {
        constant = 0.01;
    }
    self.infoAreaHeightConstraint.constant = constant;
}

-(void)addHeaderTap{
    if (self.serviceEnableTap) {
        [self headerAreaTapGestureRecognizer];
    } else {
        [self.headerArea removeGestureRecognizer:self.headerAreaTapGestureRecognizer];
        self.headerAreaTapGestureRecognizer = nil;
    }
}

-(void)tapHeaderArea{
    if (_delegate && [_delegate respondsToSelector:@selector(valueAddCellTapHeadder:)]) {
        [_delegate valueAddCellTapHeadder:self];
    }
}

-(void)tapContract{
    if (_delegate && [_delegate respondsToSelector:@selector(valueAddCellTapContract:)]) {
        [_delegate valueAddCellTapContract:self];
    }
}

-(NSMutableAttributedString* )getTextFieldAttributeWithPlaceholder:(NSString *)placeholder{
    if (placeholder == nil) {
        return nil;
    }
    NSMutableAttributedString *attrString
    = [[NSMutableAttributedString alloc]
       initWithString:placeholder
       attributes:@{
                    NSForegroundColorAttributeName:Color_gray_2,
                    NSFontAttributeName:[UIFont boldSystemFontOfSize:16]
                    }];
    return attrString;
}

#pragma mark - setters and getters
-(UITapGestureRecognizer *)headerAreaTapGestureRecognizer{
    if (!_headerAreaTapGestureRecognizer) {
        _headerAreaTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderArea)];
        [self.headerArea addGestureRecognizer:_headerAreaTapGestureRecognizer];
    }
    return _headerAreaTapGestureRecognizer;
}

-(UITapGestureRecognizer *)contractTapGestureRecognizer{
    if (!_contractTapGestureRecognizer) {
        _contractTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContract)];
        [self.serviceContractLabel addGestureRecognizer:_contractTapGestureRecognizer];
    }
    return _contractTapGestureRecognizer;
}

-(void)setServiceName:(NSString *)serviceName{
    _serviceName = serviceName;
    self.serviceNameLabel.text = serviceName;
}

-(void)setServiceDetail:(NSString *)serviceDetail{
    _serviceDetail = serviceDetail;
    if (!Util_IsEmptyString(serviceDetail)) {
        self.serviceDetailLabel.text = [NSString stringWithFormat:@"（%@）",serviceDetail];
    } else {
        self.serviceDetailLabel.text = @"";
    }
}

-(void)setServiceContract:(NSString *)serviceContract{
    _serviceContract = serviceContract;
    if (!Util_IsEmptyString(serviceContract)) {
        self.serviceContractLabel.text = [NSString stringWithFormat:@"《%@》",serviceContract];
    } else {
        self.serviceContractLabel.text = @"";
    }
}

-(void)setServiceValue:(NSString *)serviceValue{
    _serviceValue = serviceValue;
    if (self.showInputArea) {
        self.inputTextField.text = serviceValue;
    } else {
        self.inputTextField.text = @"";
    }
}

-(void)setServiceValuePlaceholder:(NSString *)serviceValuePlaceholder{
    _serviceValuePlaceholder = serviceValuePlaceholder;
    self.inputTextField.attributedPlaceholder = [self getTextFieldAttributeWithPlaceholder:serviceValuePlaceholder];;
}

-(void)setServiceInfo:(NSString *)serviceInfo{
    _serviceInfo = serviceInfo;
    self.infoLabel.text = serviceInfo;
    self.showInfoArea = !Util_IsEmptyString(serviceInfo);
}
@end
