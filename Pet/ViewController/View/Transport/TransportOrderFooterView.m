//
//  TransportOrderFooterView.m
//  Pet
//
//  Created by mac on 2019/12/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrderFooterView.h"

@interface TransportOrderFooterView ()
@property (nonatomic, strong) UIButton * phoneButton;
@property (nonatomic, strong) UIView * spliceLine;
@property (nonatomic, strong) UILabel * priceTitle;
@property (nonatomic, strong) UILabel * priceValue;
@property (nonatomic, strong) UIButton * orderButton;
@end

@implementation TransportOrderFooterView
#pragma mark - life cycle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    self.backgroundColor = Color_white_1;
    [self addViews];
    [self initPropertys];
}

-(void)initPropertys{
    self.type = TransportOrderFooterView_Type_Order;
}

-(void)addViews{
    [self addSubview:self.phoneButton];
    [self addSubview:self.spliceLine];
    [self addSubview:self.priceTitle];
    [self addSubview:self.priceValue];
    [self addSubview:self.orderButton];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.phoneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.height.equalTo(self).multipliedBy(0.8);
    }];
    [self.spliceLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.phoneButton.mas_right).offset(12);
        make.height.equalTo(self).multipliedBy(0.8);
        make.width.mas_equalTo(1);
    }];
    [self.priceTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.spliceLine.mas_right).offset(12);
        make.height.equalTo(self).multipliedBy(0.8);
    }];
    [self.priceValue mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.priceTitle.mas_right).offset(5);
        make.height.equalTo(self).multipliedBy(0.8);
    }];
    [self.orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12);
        make.height.equalTo(self).multipliedBy(0.8);
        make.width.mas_equalTo(100);
        make.left.greaterThanOrEqualTo(self.priceValue.mas_right).offset(12);
    }];
}

#pragma mark - private method
-(void)tapCallButton{
    if (_delegate && [_delegate respondsToSelector:@selector(transportOrderFooterTapCall)]) {
        [_delegate transportOrderFooterTapCall];
    }
}
-(void)tapOrderButton{
    if (_delegate && [_delegate respondsToSelector:@selector(transportOrderFooterTapOrder)]) {
        [_delegate transportOrderFooterTapOrder];
    }
}

#pragma mark - setters and getters
-(UIButton *)phoneButton{
    if (!_phoneButton) {
        _phoneButton = [[UIButton alloc]init];
        [_phoneButton setTitle:@"斑马客服" forState:UIControlStateNormal];
        [_phoneButton setTitleColor:Color_red_2 forState:UIControlStateNormal];
        [_phoneButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Phone, 24, Color_red_2)] forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = kFontSize(12);
        [_phoneButton addTarget:self action:@selector(tapCallButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneButton;
}

-(UIView *)spliceLine{
    if (!_spliceLine) {
        _spliceLine = [[UIView alloc]init];
        _spliceLine.backgroundColor = Color_gray_2;
    }
    return _spliceLine;
}

-(UILabel *)priceTitle{
    if (!_priceTitle) {
        _priceTitle = [[UILabel alloc]init];
        _priceTitle.textColor = Color_gray_2;
        _priceTitle.font = kFontSize(16);
        _priceTitle.text = @"预估金额";
    }
    return _priceTitle;
}

-(UILabel *)priceValue{
    if (!_priceValue) {
        _priceValue = [[UILabel alloc]init];
        _priceValue.textColor = Color_red_2;
        _priceValue.font = kFontSize(18);
    }
    return _priceValue;
}

-(UIButton *)orderButton{
    if (!_orderButton) {
        _orderButton = [[UIButton alloc]init];
        [_orderButton setBackgroundColor:Color_red_2];
        [_orderButton setTitle:@"预定" forState:UIControlStateNormal];
        [_orderButton setTitleColor:Color_white_1 forState:UIControlStateNormal];
        _orderButton.titleLabel.font = kFontSize(18);
        _orderButton.layer.cornerRadius = 10;
        [_orderButton addTarget:self action:@selector(tapOrderButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

-(void)setPrice:(NSString *)price{
    _price = price;
    _priceValue.text = [NSString stringWithFormat:@"￥%@",price];
}

-(void)setType:(TransportOrderFooterView_Type)type{
    _type = type;
    if (type == TransportOrderFooterView_Type_Pay) {
        [self.orderButton setTitle:@"付款" forState:UIControlStateNormal];
    } else if (type == TransportOrderFooterView_Type_Order) {
        [self.orderButton setTitle:@"下单" forState:UIControlStateNormal];
    } else if (type == TransportOrderFooterView_Type_Commit) {
        [self.orderButton setTitle:@"提交" forState:UIControlStateNormal];
    }
}

@end
