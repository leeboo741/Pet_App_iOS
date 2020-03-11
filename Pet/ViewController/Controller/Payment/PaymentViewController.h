//
//  PaymentViewController.h
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Payment_Order_Type) {
    Payment_Order_Type_Transport, // 运输订单支付
    Payment_Order_Type_Premium, // 补价支付
    Payment_Order_Type_Recharge, // 充值支付
};

typedef void(^PaymentCompleteBlock)(BOOL paySuccess);

@interface PaymentViewController : UIViewController
@property (nonatomic, copy) NSString * orderNo; // 订单编号
@property (nonatomic, assign) CGFloat payAmount; // 订单金额
@property (nonatomic, assign) Payment_Order_Type paymentType; // 支付类型
@property (nonatomic, copy) PaymentCompleteBlock completeBlock;
@end

NS_ASSUME_NONNULL_END
