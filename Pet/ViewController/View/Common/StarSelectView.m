//
//  StarSelectView.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "StarSelectView.h"
#import "StarSelectItem.h"

@interface StarSelectView ()
@property (weak, nonatomic) IBOutlet StarSelectItem *starItem1;
@property (weak, nonatomic) IBOutlet StarSelectItem *starItem2;
@property (weak, nonatomic) IBOutlet StarSelectItem *starItem3;
@property (weak, nonatomic) IBOutlet StarSelectItem *starItem4;
@property (weak, nonatomic) IBOutlet StarSelectItem *starItem5;

@property (nonatomic, strong) NSArray * itemsArray;

@end

@implementation StarSelectView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}


-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"StarSelectView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    self.starLevel = 5;
    
    [self.starItem1 addGestureRecognizer:[self getTapGestureRecognizer]];
    [self.starItem2 addGestureRecognizer:[self getTapGestureRecognizer]];
    [self.starItem3 addGestureRecognizer:[self getTapGestureRecognizer]];
    [self.starItem4 addGestureRecognizer:[self getTapGestureRecognizer]];
    [self.starItem5 addGestureRecognizer:[self getTapGestureRecognizer]];
}

-(UITapGestureRecognizer *)getTapGestureRecognizer{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStar:)];
    return tap;
}

-(void)setStarLevel:(NSInteger)starLevel{
    if (starLevel <= 0) {
        starLevel = 1;
    }
    if (starLevel > 5) {
        starLevel = 5;
    }
    _starLevel = starLevel;
    for (NSInteger index = 1; index <= self.itemsArray.count; index++) {
        StarSelectItem * item = self.itemsArray[index - 1];
        if (index <= starLevel) {
            item.isSelected = YES;
        } else {
            item.isSelected = NO;
        }
    }
}

-(void)tapStar:(UITapGestureRecognizer *)tap{
    StarSelectItem * item = (StarSelectItem *)tap.view;
    self.starLevel = [self.itemsArray indexOfObject:item] + 1;
    if (_delegate && [_delegate respondsToSelector:@selector(tapStarAtStarSelectView:withLevel:)]) {
        [_delegate tapStarAtStarSelectView:self withLevel:self.starLevel];
    }
}

-(NSArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = @[_starItem1,_starItem2,_starItem3,_starItem4,_starItem5];
    }
    return _itemsArray;
}

@end
