//
//  OrderInfoCell.m
//  Pet
//
//  Created by lee on 2020/1/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderInfoCell.h"

@interface OrderInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;

@end

@implementation OrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoTitle:(NSString *)infoTitle{
    _infoTitle = infoTitle;
    self.infoTitleLabel.text = infoTitle;
}

-(void)setInfoValue:(NSString *)infoValue{
    _infoValue = infoValue;
    self.infoValueLabel.text = infoValue;
}

-(void)setInfoDetail:(NSString *)infoDetail{
    _infoDetail = infoDetail;
    self.infoDetailLabel.text = infoDetail;
}

@end
