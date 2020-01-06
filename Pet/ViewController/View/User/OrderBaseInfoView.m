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
@property (weak, nonatomic) IBOutlet UILabel *headerSpliteLine;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outPortTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *outPortTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *citySpliteLine;
@property (weak, nonatomic) IBOutlet UILabel *endCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *transportTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *petTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *petBreedLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderPhoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *senderPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *recevierNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneLabel;
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

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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

//    self.titleIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.headerSpliteLine.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderTimeTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.outPortTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.outPortTimeTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.startCityLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.citySpliteLine.translatesAutoresizingMaskIntoConstraints = NO;
//    self.endCityLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.transportTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.petTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.petBreedLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.senderNameTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.senderNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.senderPhoneTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.senderPhoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.receiverNameTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.recevierNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.receiverPhoneTitle.translatesAutoresizingMaskIntoConstraints = NO;
//    self.receiverPhoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.orderAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self resetConstraint];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"BaseView 布局 %@",NSStringFromCGRect(self.frame));
//    [self resetConstraint];
    
}

#pragma mark - private method

-(void)resetConstraint {
    [self.titleIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.equalTo(self.titleIconImageView);
        make.left.equalTo(self.boxView).offset(10);
    }];
    [self.orderNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxView).offset(10);
        make.right.equalTo(self.boxView).offset(-10);
        make.left.equalTo(self.titleIconImageView.mas_right).offset(8);
        make.centerY.equalTo(self.titleIconImageView);
        make.height.mas_equalTo(20);
    }];
    
    [self.headerSpliteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleIconImageView);
        make.right.equalTo(self.orderNoLabel);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
    }];
    
    [self.orderTimeTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerSpliteLine);
        make.top.equalTo(self.headerSpliteLine.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    [self.orderTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderTimeTitle.mas_right).offset(8);
        make.right.equalTo(self.headerSpliteLine);
        make.top.equalTo(self.orderTimeTitle);
        make.height.equalTo(self.orderTimeTitle);
    }];
    
    [self.outPortTimeTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orderTimeTitle);
        make.top.equalTo(self.orderTimeLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];
    [self.outPortTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outPortTimeTitle.mas_right).offset(8);
        make.right.equalTo(self.orderTimeLabel);
        make.top.equalTo(self.outPortTimeTitle);
        make.height.equalTo(self.outPortTimeTitle);
    }];
    
    [self.startCityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.outPortTimeTitle.mas_bottom).offset(8);
        make.left.equalTo(self.outPortTimeTitle);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    [self.citySpliteLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startCityLabel);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(20);
        make.left.equalTo(self.startCityLabel.mas_right);
    }];
    [self.endCityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.citySpliteLine.mas_right);
        make.width.equalTo(self.startCityLabel);
        make.centerY.equalTo(self.startCityLabel);
        make.height.equalTo(self.startCityLabel);
    }];
    [self.transportTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endCityLabel.mas_right);
        make.centerY.equalTo(self.endCityLabel);
        make.height.equalTo(self.endCityLabel);
        make.right.equalTo(self.outPortTimeLabel);
    }];
    
    [self.petTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startCityLabel);
        make.top.equalTo(self.startCityLabel.mas_bottom).offset(8);
        make.right.equalTo(self.boxView.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    [self.petBreedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView.mas_centerX);
        make.right.equalTo(self.transportTypeLabel);
        make.centerY.equalTo(self.petTypeLabel);
        make.height.equalTo(self.petTypeLabel);
    }];
    
    [self.senderNameTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.petTypeLabel);
        make.top.equalTo(self.petTypeLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];
    [self.senderNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.senderNameTitle.mas_right);
        make.top.equalTo(self.senderNameTitle);
        make.right.equalTo(self.boxView.mas_centerX).offset(-20);
        make.height.mas_equalTo(20);
    }];
    [self.senderPhoneTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.senderNameLabel.mas_right);
        make.top.equalTo(self.senderNameTitle);
        make.height.mas_equalTo(20);
    }];
    [self.senderPhoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.senderPhoneTitle.mas_right);
        make.top.equalTo(self.senderNameTitle);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.petBreedLabel);
    }];
    
    [self.receiverNameTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.senderNameTitle.mas_bottom).offset(8);
        make.left.equalTo(self.senderNameTitle);
        make.right.equalTo(self.senderNameTitle);
        make.height.mas_equalTo(20);
    }];
    [self.recevierNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiverNameTitle);
        make.left.right.equalTo(self.senderNameLabel);
        make.height.mas_equalTo(20);
    }];
    [self.receiverPhoneTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiverNameTitle);
        make.left.right.equalTo(self.senderPhoneTitle);
        make.height.mas_equalTo(20);
    }];
    [self.receiverPhoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiverNameTitle);
        make.left.right.equalTo(self.senderPhoneLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.orderStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recevierNameLabel.mas_bottom).offset(8);
        make.left.equalTo(self.receiverNameTitle);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.boxView).offset(-8);
    }];
    [self.orderAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.receiverPhoneLabel);
        make.centerY.equalTo(self.orderStateLabel);
        make.height.equalTo(self.orderStateLabel);
    }];
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
