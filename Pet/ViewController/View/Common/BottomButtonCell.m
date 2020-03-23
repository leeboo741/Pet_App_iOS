//
//  BottomButtonCell.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "BottomButtonCell.h"

@interface BottomButtonCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation BottomButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.button.layer.cornerRadius = 10;
    self.button.layer.masksToBounds = NO;
    self.button.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.button.layer.shadowOffset  = CGSizeMake(0, 0);
    self.button.layer.shadowOpacity = 0.8;
    self.button.layer.shadowRadius  = 8;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

-(void)setButtonColor:(UIColor *)buttonColor{
    [self.button setBackgroundColor:buttonColor];
}

-(void)setButtonTitle:(NSString *)buttonTitle{
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)setButtonTitleColor:(UIColor *)buttonTitleColor{
    [self.button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
}

@end
