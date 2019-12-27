//
//  selectActionLabel.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SelectActionLabel.h"

@implementation SelectActionLabel
#pragma mark - life cycle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addKVO];
        [self addClickAction];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addKVO];
        [self addClickAction];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addKVO];
        [self addClickAction];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"normalStr"];
    [self removeObserver:self forKeyPath:@"normalColor"];
    [self removeObserver:self forKeyPath:@"placeholderStr"];
    [self removeObserver:self forKeyPath:@"placeholderColor"];
}
#pragma mark - KVO Callback

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"normalStr"]
        || [keyPath isEqualToString:@"normalColor"]
        || [keyPath isEqualToString:@"placeholderStr"]
        || [keyPath isEqualToString:@"placeholderColor"]) {
        [self resetContentAndColor];
    }
}

#pragma mark - private method

-(void)selectActionLabelTapAction{
    if(_delegate && [_delegate respondsToSelector:@selector(selectActionLabelClickAction:)]){
        [_delegate selectActionLabelClickAction:self];
    }
}

-(void)addClickAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectActionLabelTapAction)];
    [self addGestureRecognizer:tap];
}

-(void)addKVO{
    [self addObserver:self forKeyPath:@"normalStr" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"normalColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"placeholderStr" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"placeholderColor" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)resetContentAndColor{
    if ([self emptyNormalContent]) {
        self.text = self.placeholderStr;
        self.textColor = self.placeholderColor;
    } else {
        self.text = self.normalStr;
        self.textColor = self.normalColor;
    }
}

-(BOOL)emptyNormalContent{
    return self.normalStr == nil || [self.normalStr isEqualToString:@""];
}

#pragma mark - setters and getters
-(UIColor *)placeholderColor{
    return !_placeholderColor?Color_gray_2:_placeholderColor;
}
-(UIColor *)normalColor{
    return !_normalColor?Color_black_1:_normalColor;
}

@end
