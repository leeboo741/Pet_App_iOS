//
//  FormTableViewCell.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "FormTableViewCell.h"

@interface FormTableViewCell ()
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * centerView;
@property (nonatomic, strong) UIView * centerLeftView;
@property (nonatomic, strong) UIView * centerRightView;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UIImageView * flagIconImageView;
@end

@implementation FormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showFlag = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)headerView{
    UIView * customerView = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(headerViewForFormTableViewCell:)]) {
        customerView= [_dataSource headerViewForFormTableViewCell:self];
    }
    if (customerView) {
        if (![self.subviews containsObject:customerView]) {
            [self addSubview:customerView];
        }
        return customerView;
    } else {
        return nil;
    }
}

-(UIView *)footerView{
    UIView * customerView = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(footerViewForFormTableViewCell:)]) {
        customerView= [_dataSource footerViewForFormTableViewCell:self];
    }
    if (customerView) {
        if (![self.subviews containsObject:customerView]) {
            [self addSubview:customerView];
        }
        return customerView;
    } else {
        return nil;
    }
}

-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
        [self addSubview:_centerView];
    }
    return _centerView;
}



@end
