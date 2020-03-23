//
//  OrderStepCell.m
//  Pet
//
//  Created by lee on 2020/1/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderStepCell.h"

@interface OrderStepCell ()
@property (weak, nonatomic) IBOutlet OrderStepItem *orderStepItem;

@end

@implementation OrderStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStepTime:(NSString *)stepTime{
    _stepTime = stepTime;
    self.orderStepItem.stepTime = stepTime;
}

-(void)setStepTitle:(NSString *)stepTitle{
    _stepTitle = stepTitle;
    self.orderStepItem.stepTitle = stepTitle;
}

-(void)setType:(StepItemType)type{
    _type = type;
    self.orderStepItem.type = type;
}

-(void)setStepIndex:(NSInteger)stepIndex{
    _stepIndex = stepIndex;
    self.orderStepItem.stepIndex = stepIndex;
}

-(void)setMediaList:(NSArray *)mediaList{
    _mediaList = mediaList;
    self.orderStepItem.mediaList = mediaList;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
