//
//  ApplyCenterItem.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyCenterItem.h"

@interface ApplyCenterItem ()
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation ApplyCenterItem

#pragma mark - life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return  self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return  self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return  self;
}

-(void)initView{
    self.layer.borderColor = Color_blue_2.CGColor;
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.6);
        make.width.equalTo(self.logoImageView.mas_height);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right);
        make.right.equalTo(self).offset(-30);
        make.centerY.equalTo(self.logoImageView);
        make.width.mas_equalTo(220);
    }];
}

#pragma mark - setters and getters

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
    }
    return _logoImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = Color_blue_2;
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(void)setItemTitle:(NSString *)itemTitle{
    _itemTitle = itemTitle;
    self.titleLabel.text = itemTitle;
}

-(void)setLogoImageName:(NSString *)logoImageName{
    _logoImageName = logoImageName;
    self.logoImageView.image = [UIImage imageNamed:logoImageName];
}

@end
