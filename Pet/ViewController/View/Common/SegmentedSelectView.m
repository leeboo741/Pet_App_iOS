//
//  SegmentedSelectView.m
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SegmentedSelectView.h"

#pragma mark - ItemModel

@implementation SegmentedSelectItemModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.itemIsSelected = NO;
        self.normalColor = Color_blue_2;
        self.selectedColor = Color_yellow_1;
        self.style = SegmentedItemStyle_Bottom;
    }
    return self;
}

-(SegmentedItemStyle)style{
    return SegmentedItemStyle_Bottom;
}
@end

#pragma mark - Item

@interface SegmentedSelectItem ()
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIView * bottomLine;
@end

@implementation SegmentedSelectItem

#pragma mark - item | life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetConstrant];
}

#pragma mark - item | setters and getters

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
    }
    return _label;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
    }
    return _bottomLine;
}

-(void)setModel:(SegmentedSelectItemModel *)model{
    _model = model;
    if (kStringIsEmpty(model.title)) {
        if ([self.subviews containsObject:self.label]) {
            [self.label removeFromSuperview];
        }
    } else {
        if (![self.subviews containsObject:self.label]) {
            [self addSubview:self.label];
        }
        self.label.text = model.title;
        if (model.itemIsSelected) {
            self.label.textColor = model.selectedColor;
        } else {
            self.label.textColor = model.normalColor;
        }
    }
    
    if (kStringIsEmpty(model.iconfontName) && kStringIsEmpty(model.imageName)) {
        if ([self.subviews containsObject:self.imageView]) {
            [self.imageView removeFromSuperview];
        }
    } else {
        if (![self.subviews containsObject:self.imageView]) {
            [self addSubview:self.imageView];
        }
        if (!kStringIsEmpty(model.iconfontName)) {
            if (model.itemIsSelected) {
                self.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(model.iconfontName, 32, model.selectedColor)];
            } else {
                self.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(model.iconfontName, 32, model.normalColor)];
            }
        }
        if (!kStringIsEmpty(model.imageName)) {
            self.imageView.image = [UIImage imageNamed:model.imageName];
        }
    }
    
    if (model.style == SegmentedItemStyle_Bottom) {
        if (![self.subviews containsObject:self.bottomLine]) {
            [self addSubview:self.bottomLine];
        }
        if (model.itemIsSelected) {
            self.bottomLine.backgroundColor = model.selectedColor;
        } else {
            self.bottomLine.backgroundColor = Color_white_1;
        }
    } else {
        if ([self.subviews containsObject:self.bottomLine]) {
            [self.bottomLine removeFromSuperview];
        }
    }
}

#pragma mark - private method
-(void)resetConstrant{
    if ([self.subviews containsObject:self.label]) {
        if ([self.subviews containsObject:self.imageView]) {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.top.equalTo(self).offset(8);
                make.right.lessThanOrEqualTo(self).offset(-8);
                make.left.equalTo(self.imageView.mas_right).offset(3);
            }];
        } else {
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(8);
            }];
        }
    }
    
    if ([self.subviews containsObject:self.imageView]) {
        if ([self.subviews containsObject:self.label]) {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.top.equalTo(self).offset(8);
                make.left.greaterThanOrEqualTo(self).offset(8);
                make.right.equalTo(self.label.mas_left).offset(-3);
            }];
        } else {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self);
                make.width.equalTo(self.imageView.mas_height);
                make.top.equalTo(self).offset(8);
            }];
        }
    }
    
    if ([self.subviews containsObject:self.bottomLine]) {
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(2);
        }];
    }
}

@end

#pragma mark - BoxView

@interface SegmentedSelectView ()
@property (nonatomic, strong) NSMutableArray<SegmentedSelectItem *>* itemsArray;
@end

@implementation SegmentedSelectView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetConstant];
}

#pragma mark - setters and getters

-(void)setModelArray:(NSArray<SegmentedSelectItemModel *> *)modelArray{
    _modelArray = modelArray;
    [self resetUI];
}

-(NSMutableArray<SegmentedSelectItem *> *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

#pragma mark - private method

-(void)resetUI{
    for (SegmentedSelectItem * item in self.itemsArray) {
        [item removeFromSuperview];
    }
    [self.itemsArray removeAllObjects];
    for (SegmentedSelectItemModel * model in self.modelArray) {
        SegmentedSelectItem * item = [[SegmentedSelectItem alloc]init];
        item.model = model;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItem:)];
        [item addGestureRecognizer:tap];
        [self.itemsArray addObject:item];
        [self addSubview:item];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)resetConstant{
    SegmentedSelectItem * preItem = nil;
    NSInteger count = self.itemsArray.count;
    for (NSInteger index = 0; index < count; index ++) {
        SegmentedSelectItem * item = self.itemsArray[index];
        if (preItem) {
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.7);
                make.width.equalTo(self).multipliedBy(1.0/count);
                make.left.equalTo(preItem.mas_right);
            }];
        } else {
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.7);
                make.width.equalTo(self).multipliedBy(1.0/count);
                make.left.equalTo(self);
            }];
        }
        preItem = item;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - event action
-(void)tapItem:(UITapGestureRecognizer *)tap{
    SegmentedSelectItem * item = (SegmentedSelectItem *)tap.view;
//    for (NSInteger index = 0; index < self.itemsArray.count; index++) {
//        SegmentedSelectItem * tempItem = self.itemsArray[index];
//        if (tempItem.)
//    }
}


@end
