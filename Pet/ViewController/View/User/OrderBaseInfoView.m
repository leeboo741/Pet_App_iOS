//
//  OrderBaseInfoView.m
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderBaseInfoView.h"

@interface OrderBaseInfoView ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *titleIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outPortTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *endCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *petTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *petBreedLabel;
@property (weak, nonatomic) IBOutlet UIView *senderLineView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderPhoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderLineHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *recevierLineView;
@property (weak, nonatomic) IBOutlet UILabel *recevierNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverLineHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@end

@implementation OrderBaseInfoView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"OrderBaseInfoView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.titleIconImageView.layer.cornerRadius = 15/2.0f;
    self.titleIconImageView.image = [UIImage jkr_imageWithColor:Color_blue_1 size:CGSizeMake(15, 15)];
}


#pragma mark - setters and getters

-(void)setOrderNo:(NSString *)orderNo{
    _orderNo = orderNo;
    self.orderNoLabel.text = orderNo;
}

-(void)setOrderTime:(NSString *)orderTime{
    _orderTime = orderTime;
    self.orderTimeLabel.text = orderTime;
}

-(void)setOutportTime:(NSString *)outportTime{
    _outportTime = outportTime;
    self.outPortTimeLabel.text = outportTime;
}

-(void)setStartCity:(NSString *)startCity{
    _startCity = startCity;
    self.startCityLabel.text = startCity;
}

-(void)setEndCity:(NSString *)endCity{
    _endCity = endCity;
    self.endCityLabel.text = endCity;
}

-(void)setTransportType:(NSString *)transportType{
    _transportType = transportType;
    self.transportTypeLabel.text = transportType;
}

-(void)setPetType:(NSString *)petType{
    _petType = petType;
    self.petTypeLabel.text = petType;
}

-(void)setPetBreed:(NSString *)petBreed{
    _petBreed = petBreed;
    self.petBreedLabel.text = petBreed;
}

-(void)setSenderName:(NSString *)senderName{
    _senderName = senderName;
    self.senderNameLabel.text = senderName;
}

-(void)setSenderPhone:(NSString *)senderPhone{
    _senderPhone = senderPhone;
    self.senderPhoneLabel.text = senderPhone;
}

-(void)setReceiverName:(NSString *)receiverName{
    _receiverName = receiverName;
    self.recevierNameLabel.text = receiverName;
}

-(void)setReceiverPhone:(NSString *)receiverPhone{
    _receiverPhone = receiverPhone;
    self.receiverPhoneLabel.text = receiverPhone;
}

-(void)setOrderState:(NSString *)orderState{
    _orderState = orderState;
    self.orderStateLabel.text = orderState;
}

-(void)setOrderAmount:(NSString *)orderAmount{
    _orderAmount = orderAmount;
    self.orderAmountLabel.text = orderAmount;
}
@end
