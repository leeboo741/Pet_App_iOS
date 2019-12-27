//
//  HomeActionCell.m
//  Pet
//
//  Created by mac on 2019/12/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HomeActionCell.h"

@interface HomeActionCell ()
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) UILabel * label;
@end

@implementation HomeActionCell

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = NO;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_width).multipliedBy(0.3);
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
}


#pragma mark - setters and getters
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        [self addSubview:_label];
    }
    return _label;
}

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"logo"]];
}

-(void)setActionTitle:(NSString *)actionTitle{
    _actionTitle = actionTitle;
    self.label.text = actionTitle;
}


@end
