//
//  ImageAndVideoSelectItemCell.m
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageAndVideoSelectItemCell.h"

@interface ImageAndVideoSelectItemCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ImageAndVideoSelectItemCell

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ableDelete = YES;
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.boxView addGestureRecognizer:tap];
    
}

#pragma mark - event action

-(void)deleteAction{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteImageAndVideoSelectItemCell:)]) {
        [_delegate deleteImageAndVideoSelectItemCell:self];
    }
}

-(void)tapAction{
    if (_delegate && [_delegate respondsToSelector:@selector(tapImageAndVideoSelectItemCell:)]) {
        [_delegate tapImageAndVideoSelectItemCell:self];
    }
}

#pragma mark - private method

-(void)changeItemState{
    NSAssert(self.model.type != MediaSelectItemType_UNKOWN, @"资源文件类型未知");
    if (self.model.type == MediaSelectItemType_IMG) {
        [self changeCoverImageViewShow:NO image:nil];
    } else if (self.model.type == MediaSelectItemType_VIDEO) {
        [self changeCoverImageViewShow:YES image:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Play, 32, Color_white_1)]];
    } else if (self.model.type == MediaSelectItemType_ADD) {
        [self changeCoverImageViewShow:YES image:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Add, 32, Color_gray_1)]];
    }
}

-(void)changeBoxViewBorderShow:(BOOL)show{
    if (show) {
        self.boxView.layer.cornerRadius = 10;
        self.boxView.layer.borderWidth = 1;
        self.boxView.layer.borderColor = Color_gray_1.CGColor;
    } else {
        self.boxView.layer.borderWidth = 0;
    }
}

-(void)changeCoverImageViewShow:(BOOL)show image:(UIImage *)image {
    self.coverImageView.hidden = !show;
    if (show) {
        self.coverImageView.image = image;
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
        self.contentImageView.image = self.model.coverImage;
    } else if (self.model.coverImagePath) {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImagePath] placeholderImage:[UIImage imageNamed:@"logo"]];
    } else if (self.model.type != MediaSelectItemType_ADD){
        [self.contentImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"logo"]];
    }
}

#pragma mark - setters and getters

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
