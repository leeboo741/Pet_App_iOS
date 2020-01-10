//
//  StarSelectItem.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "StarSelectItem.h"

@interface StarSelectItem ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation StarSelectItem


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
    [[NSBundle mainBundle] loadNibNamed:@"StarSelectItem" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Star, 32, Color_yellow_1)];
    } else {
        self.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Star, 32, Color_gray_1)];
    }
}

@end
