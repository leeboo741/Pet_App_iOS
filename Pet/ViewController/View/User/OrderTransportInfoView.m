//
//  OrderTransportInfoView.m
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderTransportInfoView.h"

@interface OrderTransportInfoView ()
@property (nonatomic, strong) UITextField * transportNumTextField;
@property (nonatomic, strong) UITextField * startCityCodeTextField;
@property (nonatomic, strong) UITextField * endCityCodeTextField;
@property (nonatomic, strong) UITextField * departureDateTextField;
@property (nonatomic, strong) UITextField * expressNumTextField;
@end

@implementation OrderTransportInfoView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"showAirportLine" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"hidden"];
    [self removeObserver:self forKeyPath:@"showAirportLine"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"hidden"] || [keyPath isEqualToString:@"showAirportLine"]) {
        [self resetUI];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetConstraint];
}

-(UITextField *)transportNumTextField{
    if (!_transportNumTextField) {
        _transportNumTextField = [[UITextField alloc]init];
        _transportNumTextField.borderStyle = UITextBorderStyleRoundedRect;
        _transportNumTextField.placeholder = @"请输入航班号/车次号";
        [self addSubview:_transportNumTextField];
    }
    return _transportNumTextField;
}

-(UITextField *)startCityCodeTextField{
    if (!_startCityCodeTextField) {
        _startCityCodeTextField = [[UITextField alloc]init];
        _startCityCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
        _startCityCodeTextField.placeholder = @"始发机场三字码";
    }
    return _startCityCodeTextField;
}

-(UITextField *)endCityCodeTextField{
    if (!_endCityCodeTextField) {
        _endCityCodeTextField = [[UITextField alloc]init];
        _endCityCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
        _endCityCodeTextField.placeholder = @"目的机场三字码";
    }
    return _endCityCodeTextField;
}

-(UITextField *)departureDateTextField{
    if (!_departureDateTextField) {
        _departureDateTextField = [[UITextField alloc]init];
        _departureDateTextField.borderStyle = UITextBorderStyleRoundedRect;
        _departureDateTextField.placeholder = @"请选择出发时间";
        [self addSubview:_departureDateTextField];
    }
    return _departureDateTextField;
}

-(UITextField *)expressNumTextField{
    if (!_expressNumTextField) {
        _expressNumTextField = [[UITextField alloc]init];
        _expressNumTextField.borderStyle = UITextBorderStyleRoundedRect;
        _expressNumTextField.placeholder = @"请输入快递单号";
        [self addSubview:_expressNumTextField];
    }
    return _expressNumTextField;
}

-(void)setTransportNum:(NSString *)transportNum{
    _transportNum = transportNum;
    self.transportNumTextField.text = transportNum;
}

-(void)setStartAirportCode:(NSString *)startAirportCode{
    _startAirportCode = startAirportCode;
    self.startCityCodeTextField.text = startAirportCode;
}

-(void)setEndAirportCode:(NSString *)endAirportCode{
    _endAirportCode = endAirportCode;
    self.endCityCodeTextField.text = endAirportCode;
}

-(void)setDepartureDate:(NSString *)departureDate{
    _departureDate = departureDate;
    self.departureDateTextField.text = departureDate;
}

-(void)setExpressNum:(NSString *)expressNum{
    _expressNum = expressNum;
    self.expressNumTextField.text = expressNum;
}

-(void)resetUI{
    if (self.showAirportLine) {
        if (![self.subviews containsObject:self.startCityCodeTextField]) {
            [self addSubview:self.startCityCodeTextField];
        }
        if (![self.subviews containsObject:self.endCityCodeTextField]) {
            [self addSubview:self.endCityCodeTextField];
        }
    } else {
        if ([self.subviews containsObject:self.startCityCodeTextField]) {
            [self.startCityCodeTextField removeFromSuperview];
        }
        if ([self.subviews containsObject:self.endCityCodeTextField]) {
            [self.endCityCodeTextField removeFromSuperview];
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)resetConstraint{
    if (self.hidden) {
        [self.transportNumTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.1);
        }];
        [self.departureDateTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.height.equalTo(self.transportNumTextField);
        }];
        [self.expressNumTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.height.equalTo(self.transportNumTextField);
        }];
        if (self.showAirportLine) {
            [self.startCityCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.height.equalTo(self.transportNumTextField);
            }];
            [self.endCityCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.height.equalTo(self.transportNumTextField);
            }];
        }
    } else {
        [self.transportNumTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
        }];
        if (self.showAirportLine) {
            [self.startCityCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.transportNumTextField.mas_bottom).offset(5);
                make.left.equalTo(self.transportNumTextField);
                make.right.equalTo(self.transportNumTextField.mas_centerX).offset(-2.5);
            }];
            [self.endCityCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.startCityCodeTextField.mas_right).offset(5);
                make.centerY.width.equalTo(self.startCityCodeTextField);
            }];
            [self.departureDateTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.transportNumTextField);
                make.top.equalTo(self.startCityCodeTextField.mas_bottom).offset(5);
            }];
        } else {
            [self.departureDateTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.transportNumTextField);
                make.top.equalTo(self.transportNumTextField.mas_bottom).offset(5);
            }];
        }
        [self.expressNumTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.departureDateTextField.mas_bottom).offset(5);
            make.left.right.equalTo(self.departureDateTextField);
            make.bottom.equalTo(self).offset(-8);
        }];
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
