//
//  PaymentViewController.h
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentViewController : UIViewController
@property (nonatomic, assign) CGFloat paymentPrice; // 支付金额
@property (nonatomic) id orderObject; // 订单对象
@end

NS_ASSUME_NONNULL_END
