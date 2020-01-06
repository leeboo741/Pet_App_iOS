//
//  OrderRemarkView.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderRemarkView.h"

@interface OrderRemarkView ()
@property (weak, nonatomic) IBOutlet UILabel *customerRemarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFollowUpContentLabel;

@end

@implementation OrderRemarkView

#pragma mark - life cycle

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
    [[NSBundle mainBundle] loadNibNamed:@"OrderRemarkView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

#pragma mark - setters and getters

-(void)setCustomerRemark:(NSString *)customerRemark{
    _customerRemark = customerRemark;
    self.customerRemarkLabel.text = customerRemark;
}

-(void)setLastFollowUpContent:(NSString *)lastFollowUpContent{
    _lastFollowUpContent = lastFollowUpContent;
    self.lastFollowUpContentLabel.text = lastFollowUpContent;
}

@end
