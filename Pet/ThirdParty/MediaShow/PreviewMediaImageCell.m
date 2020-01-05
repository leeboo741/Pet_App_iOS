//
//  PreviewMediaImageCell.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PreviewMediaImageCell.h"

@interface PreviewMediaImageCell ()
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation PreviewMediaImageCell

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {\
        make.left.top.right.bottom.equalTo(self);
    }];
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(void)setModel:(MediaShowItemModel *)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.resourcePath] placeholderImage:[UIImage imageNamed:@"logo"]];
}
@end
