//
//  OrderEvaluateStarCell.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderEvaluateStarCell.h"
#import "StarSelectView.h"

@interface OrderEvaluateStarCell () <StarSelectViewDelegate>
@property (weak, nonatomic) IBOutlet StarSelectView *starSelectView;

@end

@implementation OrderEvaluateStarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starSelectView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapStarAtStarSelectView:(StarSelectView *)view withLevel:(NSInteger)level{
    if (_delegate && [_delegate respondsToSelector:@selector(tapStarAtOrderEvaluateStarCell:withLevel:)]) {
        [_delegate tapStarAtOrderEvaluateStarCell:self withLevel:level];
    }
}

-(void)setStarLevel:(NSInteger)starLevel{
    _starLevel = starLevel;
    self.starSelectView.starLevel = starLevel;
}

@end
