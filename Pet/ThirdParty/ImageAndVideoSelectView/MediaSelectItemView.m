//
//  MediaSelectItemView.m
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "MediaSelectItemView.h"

@interface MediaSelectItemView ()
@property (nonatomic, strong) UIView * boxView;
@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UIImageView * centerImageView;
@property (nonatomic, strong) UIButton * deleteButton;
@end

@implementation MediaSelectItemView

#pragma mark - life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.centerImageView];
    [self.boxView addSubview:self.deleteButton];
    [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.boxView addGestureRecognizer:tap];
    self.ableDelete = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.boxView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(8);
        make.right.bottom.equalTo(self).offset(-8);
    }];
    
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.boxView).offset(10);
        make.right.bottom.equalTo(self.boxView).offset(-10);
    }];
    
    [self.centerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImageView);
        make.height.with.mas_equalTo(80);
    }];
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.boxView);
        make.width.height.mas_equalTo(30);
    }];
}

#pragma mark - event action

-(void)tapAction{
    if (_delegate && [_delegate respondsToSelector:@selector(tapMediaSelectItem:)]){
        [_delegate tapMediaSelectItem:self];
    }
}
-(void)deleteAction{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteMediaSelectItem:)]) {
        [_delegate deleteMediaSelectItem:self];
    }
}

#pragma mark - private method

-(void)changeItemState{
    NSAssert(self.model.type != MediaSelectItemType_UNKOWN, @"资源文件类型未知");
    if (self.model.type == MediaSelectItemType_IMG) {
        [self changeCenterImageViewShow:NO image:nil];
        [self changeBoxViewBorderShow:NO];
    } else if (self.model.type == MediaSelectItemType_VIDEO) {
        [self changeCenterImageViewShow:YES image:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Play, 36, Color_yellow_1)]];
        [self changeBoxViewBorderShow:NO];
    } else if (self.model.type == MediaSelectItemType_ADD) {
        [self changeCenterImageViewShow:YES image:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Add, 32, Color_gray_4)]];
        [self changeBoxViewBorderShow:YES];
    } else {
        [self changeCenterImageViewShow:NO image:nil];
        [self changeBoxViewBorderShow:NO];
    }
}

-(void)changeBoxViewBorderShow:(BOOL)show{
    if (show) {
        self.boxView.layer.cornerRadius = 10;
        self.boxView.layer.borderWidth = 2;
        self.boxView.layer.borderColor = Color_gray_4.CGColor;
    } else {
        self.boxView.layer.borderWidth = 0;
    }
}

-(void)changeCenterImageViewShow:(BOOL)show image:(UIImage *)image {
    self.centerImageView.hidden = !show;
    if (show) {
        self.centerImageView.image = image;
    }
}

-(void)changeDeleteButtonShow{
    if (self.model.type != MediaSelectItemType_ADD && self.ableDelete) {
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
}

-(void)setContentImageViewContent{
    if (self.model.coverImage) {
        self.coverImageView.image = self.model.coverImage;
    } else if (self.model.coverImagePath) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImagePath] placeholderImage:[UIImage imageNamed:@"logo"]];
    } else if (self.model.type != MediaSelectItemType_ADD){
        [self.coverImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"logo"]];
    }
}


#pragma mark - setters and getters

-(UIView *)boxView{
    if (!_boxView) {
        _boxView = [[UIView alloc]init];
        _boxView.userInteractionEnabled = YES;
    }
    return _boxView;
}

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.userInteractionEnabled = YES;
    }
    return _coverImageView;
}

-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init];
        _centerImageView.userInteractionEnabled = YES;
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerImageView;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Delete, 32, Color_red_1)] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

-(void)setModel:(id<MediaSelectItemProtocol>)model{
    _model = model;
    [self changeItemState];
    [self changeDeleteButtonShow];
    [self setContentImageViewContent];
}

-(void)setAbleDelete:(BOOL)ableDelete{
    _ableDelete = ableDelete;
    [self changeDeleteButtonShow];
}

@end
