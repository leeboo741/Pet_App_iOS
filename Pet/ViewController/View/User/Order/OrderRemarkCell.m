//
//  OrderRemarkCell.m
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderRemarkCell.h"

@interface OrderRemarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *remarkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkTimeLabel;

@end

@implementation OrderRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRemarkContent:(NSString *)remarkContent{
    _remarkContent = remarkContent;
    self.remarkContentLabel.text = remarkContent;
}
-(void)setRemarkTime:(NSString *)remarkTime{
    _remarkTime = remarkTime;
    self.remarkTimeLabel.text = remarkTime;
}

@end
