//
//  StationInfoItem.m
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StationInfoItem.h"


@interface StationInfoItem ()
@property (nonatomic, weak) IBOutlet UIImageView* iconImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* valueLabel;


@end

@implementation StationInfoItem
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"StationInfoItem" owner:self options:nil];
        self.view.frame = self.bounds;
        [self addSubview:self.view];
        [self addIconKVO];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"StationInfoItem Dealloc");
    [self removeIconKVO];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark - KVO
-(void)addIconKVO{
    [self addObserver:self forKeyPath:@"iconFontName" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"iconSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"iconColor" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeIconKVO{
    
    [self removeObserver:self forKeyPath:@"iconFontName"];
    [self removeObserver:self forKeyPath:@"iconSize"];
    [self removeObserver:self forKeyPath:@"iconColor"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"iconFontName"] || [keyPath isEqualToString:@"iconSize"] || [keyPath isEqualToString:@"iconColor"]) {
        [self resetIconImage];
    }
}

#pragma mark - private method
-(void)resetIconImage{
    self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(self.iconFontName, self.iconSize.floatValue, self.iconColor)];
}

#pragma mark - setters and getters
-(NSString *)iconFontName{
    return !_iconFontName?IconFont_Pet:_iconFontName;
}
-(NSNumber *)iconSize{
    return !_iconSize?kFloatNumber(14):_iconSize;
}
-(UIColor *)iconColor{
    return !_iconColor?Color_black_1:_iconColor;
}
-(void)setTitleName:(NSString *)titleName{
    self.titleLabel.text = titleName;
}
-(void)setTitleSize:(NSNumber *)titleSize{
    self.titleLabel.font = kFontSize(titleSize.floatValue);
}
-(void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}
-(void)setValueName:(NSString *)valueName{
    _valueName = valueName;
    self.valueLabel.text = valueName;
}
-(void)setValueSize:(NSNumber *)valueSize{
    _valueSize = valueSize;
    self.valueLabel.font = kFontSize(valueSize.floatValue);
}
-(void)setValueColor:(UIColor *)valueColor{
    self.valueLabel.textColor = valueColor;
}

@end
