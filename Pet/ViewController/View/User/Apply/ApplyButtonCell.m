//
//  ApplyButtonCell.m
//  Pet
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ApplyButtonCell.h"

@interface ApplyButtonCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ApplyButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.button.backgroundColor = Color_yellow_1;
    self.button.layer.cornerRadius = 8;
    self.button.layer.masksToBounds = YES;
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button setTitleColor:Color_white_1 forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapApplyButton:)]) {
        [self.delegate tapApplyButton:self];
    }
}

@end
