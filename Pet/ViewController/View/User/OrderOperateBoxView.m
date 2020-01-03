//
//  OrderOperateBoxView.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderOperateBoxView.h"

#pragma mark - model

@implementation OrderOperateButtonModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.show = YES;
    }
    return self;
}

@end

#pragma mark - button

@interface OrderOperateButton ()
@property (nonatomic, strong) UIButton * button;

@end

@implementation OrderOperateButton

#pragma mark - button | life cycle

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
}

#pragma mark - button | setters and getters

-(void)setModel:(OrderOperateButtonModel *)model{
    _model = model;
    [self.button setTitle:model.title forState:UIControlStateNormal];
    [self.button setTitleColor:Color_white_1 forState:UIControlStateNormal];
    [self setButtonColorWithStyle:model.style];
}

-(UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]init];
        _button.layer.cornerRadius = 8;
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

#pragma mark - button | event action

-(void)tapButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tapOrderOperateButton:model:)]) {
        [_delegate tapOrderOperateButton:self model:self.model];
    }
}

#pragma mark - button | private method

-(void)setButtonColorWithStyle:(OrderOperateButtonStyle)style{
    switch (style) {
        case OrderOperateButtonStyle_Blue:
            [self.button setBackgroundColor:Color_blue_2];
            break;
        case OrderOperateButtonStyle_Red:
            [self.button setBackgroundColor:Color_red_1];
            break;
        case OrderOperateButtonStyle_Yellow:
            [self.button setBackgroundColor:Color_yellow_1];
            break;
        default:
            break;
    }
}

@end

#pragma mark - boxView

static NSInteger MAX_BUTTON_COUNT = 4;

@interface OrderOperateBoxView () <OrderOperateButtonDelegate>
@property (nonatomic, strong) NSMutableArray<OrderOperateButton *> *buttonArray;
@property (nonatomic, strong) OrderOperateButton * moreButton;
@property (nonatomic, strong) NSMutableArray * moreArray;
@end

@implementation OrderOperateBoxView

#pragma mark - boxView | life cycle

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resetConstraint];
}

#pragma mark - boxView | setters and getters

-(NSMutableArray<OrderOperateButton *> *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(NSMutableArray *)moreArray{
    if (!_moreArray) {
        _moreArray = [NSMutableArray array];
    }
    return _moreArray;
}

-(void)setButtonModelArray:(NSArray<OrderOperateButtonModel *> *)buttonModelArray{
    _buttonModelArray = buttonModelArray;
    [self resetUI];
}

-(OrderOperateButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[OrderOperateButton alloc]init];
        OrderOperateButtonModel * model = [[OrderOperateButtonModel alloc]init];
        model.title = @"更多";
        model.style = OrderOperateButtonStyle_Blue;
        model.type = OrderOperateButtonType_More;
        _moreButton.model = model;
        _moreButton.delegate = self;
    }
    return _moreButton;
}

#pragma mark - boxView | private method

-(void)resetUI{
    for (OrderOperateButton * button in self.buttonArray) {
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    NSMutableArray * showButtonModelArray = [NSMutableArray array];
    for (NSInteger index = 0; index < self.buttonModelArray.count; index ++) {
        OrderOperateButtonModel * model = self.buttonModelArray[index];
        model.index = index;
        if (model.show) {
            [showButtonModelArray addObject:model];
        }
    }
    for (NSInteger index = 0; index < showButtonModelArray.count; index ++) {
        OrderOperateButtonModel * model = showButtonModelArray[index];
        if (index < (MAX_BUTTON_COUNT - 1) ||
            (index == (MAX_BUTTON_COUNT - 1) && showButtonModelArray.count <= MAX_BUTTON_COUNT)) {
            OrderOperateButton * button = [[OrderOperateButton alloc]init];
            button.model = model;
            button.delegate = self;
            [self.buttonArray addObject:button];
            [self addSubview:button];
        } else {
            if (![self.subviews containsObject:self.moreButton]) {
                [self.buttonArray addObject:self.moreButton];
                [self addSubview:self.moreButton];
            }
            [self.moreArray addObject:model];
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)resetConstraint{
    OrderOperateButton * preButton = nil;
    for (OrderOperateButton * button in self.buttonArray) {
        if (preButton == nil) {
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self);
                make.width.equalTo(self).multipliedBy(1.0/MAX_BUTTON_COUNT);
            }];
        } else {
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.width.equalTo(preButton);
                make.right.equalTo(preButton.mas_left);
            }];
        }
        preButton = button;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - boxView | button delegate

-(void)tapOrderOperateButton:(OrderOperateButton *)button model:(nonnull OrderOperateButtonModel *)model{
    if (model.type == OrderOperateButtonType_More) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"更多" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (OrderOperateButtonModel * model in self.moreArray) {
            __weak typeof(self) weakSelf = self;
            UIAlertAction * action = [UIAlertAction actionWithTitle:model.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onClickButtonWithModel:atOrderOperateBoxView:)]) {
                    [weakSelf.delegate onClickButtonWithModel:model atOrderOperateBoxView:weakSelf];
                }
            }];
            [alertController addAction:action];
        }
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        UIViewController * viewcontroller = Util_GetCurrentVC;
        [viewcontroller presentViewController:alertController animated:YES completion:nil];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(onClickButtonWithModel:atOrderOperateBoxView:)]) {
            [_delegate onClickButtonWithModel:model atOrderOperateBoxView:self];
        }
    }
}

@end
