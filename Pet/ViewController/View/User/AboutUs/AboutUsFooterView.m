//
//  AboutUsFooterView.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AboutUsFooterView.h"

@interface AboutUsFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation AboutUsFooterView

#pragma mark - life cycle

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

-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"AboutUsFooterView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    self.label1.text =  @"Copyright@2019-2020";
    self.label2.text = @"淘宠惠 版权所有";
}

@end
