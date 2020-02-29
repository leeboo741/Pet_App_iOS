//
//  PaymentTypeCell.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PaymentTypeCell.h"

@implementation PaymentTypeModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.isRecommend = NO;
    }
    return self;
}
@end

@interface PaymentTypeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommondLabel;

@end

@implementation PaymentTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recommondLabel.layer.cornerRadius = 5;
    self.recommondLabel.layer.borderColor = Color_red_1.CGColor;
    self.recommondLabel.layer.borderWidth = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PaymentTypeModel *)model{
    _model = model;
    self.typeLogoImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(model.typeIconName, 32, Color_green_wechat)];
    self.typeNameLabel.text = model.typeName;
    self.typeInfoLabel.text = model.typeInfo;
    self.recommondLabel.hidden = !model.isRecommend;
    if (model.isSelected) {
        self.selectImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_red_1)];
    } else {
        self.selectImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_gray_1)];
    }
}

@end
