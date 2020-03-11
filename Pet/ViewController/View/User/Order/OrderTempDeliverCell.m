//
//  OrderTempDeliverCell.m
//  Pet
//
//  Created by mac on 2020/3/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderTempDeliverCell.h"

@interface OrderTempDeliverCell ()
@property (weak, nonatomic) IBOutlet UILabel *tempDeliverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDeliverPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDeliverAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempDeliverTimeLabel;

@end

@implementation OrderTempDeliverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTempDeliverName:(NSString *)tempDeliverName{
    _tempDeliverName = tempDeliverName;
    self.tempDeliverNameLabel.text = tempDeliverName;
}

-(void)setTempDeliverPhone:(NSString *)tempDeliverPhone{
    _tempDeliverPhone = tempDeliverPhone;
    self.tempDeliverPhoneLabel.text = tempDeliverPhone;
}

-(void)setTempDeliverAddress:(NSString *)tempDeliverAddress{
    _tempDeliverAddress = tempDeliverAddress;
    self.tempDeliverAddressLabel.text = tempDeliverAddress;
}

-(void)setTempDeliverTime:(NSString *)tempDeliverTime{
    _tempDeliverTime = tempDeliverTime;
    self.tempDeliverTimeLabel.text = [NSString stringWithFormat:@"预定时间:%@",tempDeliverTime];
}

@end
