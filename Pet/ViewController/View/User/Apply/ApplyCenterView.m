//
//  ApplyCenterView.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyCenterView.h"
#import "ApplyCenterItem.h"

@interface ApplyCenterView ()
@property (nonatomic, strong) ApplyCenterItem * stationItem;
@property (nonatomic, strong) ApplyCenterItem * staffItem;
@end

@implementation ApplyCenterView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = Color_white_1;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = Color_white_1;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_white_1;
    }
    return self;
}

#pragma mark - life cycle

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.stationItem mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-20);
        make.centerX.equalTo(self);
    }];
    [self.staffItem mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(20);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - event action

-(void)tapItem:(UITapGestureRecognizer *)tap{
    ApplyCenterItem * item = (ApplyCenterItem *)tap.view;
    ApplyType type = ApplyType_Station;
    if (item == self.stationItem) {
        type = ApplyType_Station;
    } else if (item == self.staffItem) {
        type = ApplyType_Staff;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(tapApplyCenterView:withType:)]) {
        [_delegate tapApplyCenterView:self withType:type];
    }
}

#pragma mark - setters and getters
-(ApplyCenterItem *)stationItem{
    if (!_stationItem) {
        _stationItem = [[ApplyCenterItem alloc]init];
        _stationItem.logoImageName = @"station";
        _stationItem.itemTitle = @"商家入驻申请";
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItem:)];
        [_stationItem addGestureRecognizer:tap];
        [self addSubview:_stationItem];
    }
    return _stationItem;
}

-(ApplyCenterItem *)staffItem{
    if (!_staffItem) {
        _staffItem = [[ApplyCenterItem alloc]init];
        _staffItem.logoImageName = @"staff";
        _staffItem.itemTitle = @"员工入驻申请";
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItem:)];
        [_staffItem addGestureRecognizer:tap];
        [self addSubview:_staffItem];
    }
    return _staffItem;
}
@end
