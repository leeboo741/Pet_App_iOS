//
//  CustomerOrderCell.m
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CustomerOrderCell.h"
#import "OrderBaseInfoView.h"

@interface CustomerOrderCell ()
@property (weak, nonatomic) IBOutlet OrderBaseInfoView *orderBaseInfoView;

@end

@implementation CustomerOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
