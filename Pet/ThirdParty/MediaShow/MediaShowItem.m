//
//  MediaShowItem.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MediaShowItem.h"

@interface MediaShowItem ()
@property (nonatomic, strong) UIImageView * contentImageView;
@property (nonatomic, strong) UIImageView * centerImageView;
@end

@implementation MediaShowItem

#pragma mark - life cycle

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.left.equalTo(self).offset(10);
    }];
    
    [self.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentImageView);
        make.width.equalTo(self.contentImageView).multipliedBy(0.5);
        make.height.equalTo(self.centerImageView.mas_width);
    }];
}

#pragma mark - setters and getters
-(void)setModel:(MediaShowItemModel *)model{
    _model = model;
    if (model.mediaType == MediaType_Video) {
        self.centerImageView.hidden = NO;
        self.centerImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Play, 32, Color_white_1)];
    } else if (model.mediaType == MediaType_Unknow) {
        self.centerImageView.hidden = NO;
        self.centerImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Delete, 32, Color_white_1)];
    } else {
        self.centerImageView.hidden = YES;
    }
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImagePath] placeholderImage:[UIImage imageNamed:@"logo"]];
}

-(UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]init];
        [self addSubview:_contentImageView];
    }
    return _contentImageView;
}

-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Play, 32, Color_white_1)];
        [self.contentImageView addSubview:_centerImageView];
    }
    return _centerImageView;
}
@end
