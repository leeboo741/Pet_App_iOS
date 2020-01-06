//
//  PreviewMediaUnknowCell.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PreviewMediaUnknowCell.h"

@interface PreviewMediaUnknowCell ()
@property (nonatomic, strong) UILabel * label;
@end

@implementation PreviewMediaUnknowCell
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.centerY.equalTo(self);
    }];
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"無法識別的資源地址！";
        _label.textColor = Color_white_1;
        _label.font = [UIFont systemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

@end
