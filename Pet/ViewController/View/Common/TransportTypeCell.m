//
//  TransportTypeCell.m
//  Pet
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportTypeCell.h"

typedef NS_ENUM(NSInteger, TransportTypeCell_State) {
    TransportTypeCell_State_Normal = 0,
    TransportTypeCell_State_Selected,
    TransportTypeCell_State_Disable,
};

@interface TransportTypeCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
//@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) TransportTypeCell_State state;

@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

@end

@implementation TransportTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addKVO];
    self.titleLabel.font = kFontSize(17);
    self.state = TransportTypeCell_State_Normal;
}

-(void)dealloc{
    [self removeKVO];
}

#pragma mark - KVO
-(void)addKVO{
    [self addObserver:self forKeyPath:@"cellTitle" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellIconName" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"cellSelectTitle" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellSelectColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellSelectIconName" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"cellDisableTitle" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellDisableColor" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"cellDisableIconName" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"typeIsSelected" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"typeIsDisable" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeKVO{
    [self removeObserver:self forKeyPath:@"cellTitle"];
    [self removeObserver:self forKeyPath:@"cellColor"];
    [self removeObserver:self forKeyPath:@"cellIconName"];
    
    [self removeObserver:self forKeyPath:@"cellSelectTitle"];
    [self removeObserver:self forKeyPath:@"cellSelectColor"];
    [self removeObserver:self forKeyPath:@"cellSelectIconName"];
    
    [self removeObserver:self forKeyPath:@"cellDisableTitle"];
    [self removeObserver:self forKeyPath:@"cellDisableColor"];
    [self removeObserver:self forKeyPath:@"cellDisableIconName"];
    
    [self removeObserver:self forKeyPath:@"typeIsDisable"];
    [self removeObserver:self forKeyPath:@"typeIsSelected"];
    
    [self removeObserver:self forKeyPath:@"state"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"cellTitle"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellColor"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellIconName"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellSelectTitle"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellSelectColor"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellSelectIconName"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellDisableTitle"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellDisableColor"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"cellDisableIconName"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"typeIsSelected"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"typeIsDisable"]) {
        [self resetUI];
    } else if ([keyPath isEqualToString:@"state"]) {
        [self changeState];
    }
}

#pragma mark - private
-(void)tapAction{
    if(_delegate && [_delegate respondsToSelector:@selector(transportTypeCellDidSelected:)]) {
        [_delegate transportTypeCellDidSelected:self];
    }
}

-(void)resetUI{
    if (self.state == TransportTypeCell_State_Normal) {
        self.titleLabel.textColor = self.cellColor;
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(self.cellIconName, 32, self.cellColor)];
        self.titleLabel.text = self.cellTitle;
    } else if (self.state == TransportTypeCell_State_Selected) {
        self.titleLabel.textColor = self.cellSelectColor;
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(self.cellSelectIconName, 32, self.cellSelectColor)];
        self.titleLabel.text = self.cellSelectTitle;
    } else if (self.state == TransportTypeCell_State_Disable) {
        self.titleLabel.textColor = self.cellDisableColor;
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(self.cellDisableIconName, 32, self.cellDisableColor)];
        self.titleLabel.text = self.cellDisableTitle;
    }
}

-(void)changeState{
    if (self.state == TransportTypeCell_State_Disable) {
        [self removeGestureRecognizer:self.tapGestureRecognizer];
        self.tapGestureRecognizer = nil;
    } else {
        [self tapGestureRecognizer];
    }
}

#pragma mark - setters and getters

-(UITapGestureRecognizer *)tapGestureRecognizer{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

-(NSString *)cellTitle{
    return _cellTitle?_cellTitle:@"";
}
-(NSString *)cellIconName{
    return _cellIconName?_cellIconName:IconFont_Pet;
}
-(UIColor *)cellColor{
    return _cellColor?_cellColor:Color_black_1;
}
-(NSString *)cellSelectTitle{
    return _cellSelectTitle?_cellSelectTitle:self.cellTitle;
}
-(NSString *)cellSelectIconName{
    return _cellSelectIconName?_cellSelectIconName:self.cellIconName;
}
-(UIColor *)cellSelectColor{
    return _cellSelectColor?_cellSelectColor:self.cellColor;
}
-(NSString *)cellDisableTitle {
    return !_cellDisableTitle?self.cellTitle:_cellDisableTitle;
}
-(NSString *)cellDisableIconName{
    return !_cellDisableIconName?self.cellIconName:_cellDisableIconName;
}
-(UIColor *)cellDisableColor{
    return !_cellDisableColor?self.cellColor:_cellDisableColor;
}

-(void)setTypeIsDisable:(BOOL)typeIsDisable{
    _typeIsDisable = typeIsDisable;
    [self setState:typeIsDisable?TransportTypeCell_State_Disable: TransportTypeCell_State_Normal];
}

-(void)setTypeIsSelected:(BOOL)typeIsSelected{
    _typeIsSelected = typeIsSelected;
    if (!self.typeIsDisable) {
        [self setState:typeIsSelected?TransportTypeCell_State_Selected: TransportTypeCell_State_Normal];
    }
}

@end
