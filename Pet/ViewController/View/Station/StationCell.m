//
//  StationCell.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StationCell.h"
#import "StationInfoItem.h"

@interface StationCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet StationInfoItem *businessTimeItem;
@property (weak, nonatomic) IBOutlet StationInfoItem *phoneItem;
@property (weak, nonatomic) IBOutlet StationInfoItem *locationItem;

@end

@implementation StationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = Color_Cell_Bg;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _boxView.layer.cornerRadius = 10;
    _logoImageView.layer.cornerRadius = 50;
    _nameLabel.font = kBlodFontSize(22);
    
    _businessTimeItem.iconFontName = IconFont_Time;
    _businessTimeItem.iconColor = Color_blue_2;
    _businessTimeItem.iconSize = kFloatNumber(14);
    _businessTimeItem.titleName = @"营业时间:";
    _businessTimeItem.titleColor = Color_blue_2;
    _businessTimeItem.titleSize = kFloatNumber(14);
    _businessTimeItem.valueColor = Color_blue_2;
    _businessTimeItem.valueSize = kFloatNumber(14);
    
    _phoneItem.iconFontName = IconFont_Phone;
    _phoneItem.iconColor = Color_blue_2;
    _phoneItem.iconSize = kFloatNumber(14);
    _phoneItem.titleName = @"电话:";
    _phoneItem.titleColor = Color_blue_2;
    _phoneItem.titleSize = kFloatNumber(14);
    _phoneItem.valueColor = Color_blue_2;
    _phoneItem.valueSize = kFloatNumber(14);
    
    _locationItem.iconFontName = IconFont_Location;
    _locationItem.iconColor = Color_blue_2;
    _locationItem.iconSize = kFloatNumber(14);
    _locationItem.titleName = @"地址:";
    _locationItem.titleColor = Color_blue_2;
    _locationItem.titleSize = kFloatNumber(14);
    _locationItem.valueColor = Color_blue_2;
    _locationItem.valueSize = kFloatNumber(14);

}

-(void)setLogoPath:(NSString *)logoPath{
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoPath] placeholderImage:[UIImage imageNamed:@"logo"]];
}
-(void)setStationName:(NSString *)stationName{
    self.nameLabel.text = stationName;
}
-(void)setBusinessTime:(NSString *)businessTime{
    self.businessTimeItem.valueName = businessTime;
}
-(void)setPhoneNumber:(NSString *)phoneNumber{
    self.phoneItem.valueName = phoneNumber;
}
-(void)setAddress:(NSString *)address{
    self.locationItem.valueName = address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
