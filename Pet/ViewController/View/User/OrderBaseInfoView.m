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
}

@end
