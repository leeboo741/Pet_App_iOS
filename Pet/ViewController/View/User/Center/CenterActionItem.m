//
//  CenterActionItem.m
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "CenterActionItem.h"

@implementation CenterActionItemModel


@end

@interface CenterActionItem ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@end

@implementation CenterActionItem

#pragma mark - life cycle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(self.iconImageView.mas_height).multipliedBy(1.0f);
        make.height.lessThanOrEqualTo(self).multipliedBy(0.6f);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(-10);
        make.width.lessThanOrEqualTo(self).offset(10);
    }];
}

#pragma mark - setters and getters
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = Color_gray_2;
    }
    return _nameLabel;
}

-(void)setModel:(CenterActionItemModel *)model{
    _model = model;
    self.nameLabel.text = model.actionName;
    self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(model.actionIconName, 32, Color_yellow_1)];
}
@end
