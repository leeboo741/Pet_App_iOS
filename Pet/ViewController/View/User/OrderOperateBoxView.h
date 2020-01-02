//
//  OrderOperateBoxView.h
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OrderOperateButtonStyle) {
    OrderOperateButtonStyle_Blue = 0,
    OrderOperateButtonStyle_Red,
    OrderOperateButtonStyle_Yellow,
};

typedef NS_ENUM(NSInteger, OrderOperateButtonType) {
    OrderOperateButtonType_Pay = 0, // 支付
    OrderOperateButtonType_Call, // 拨打电话
    OrderOperateButtonType_Evaluate, // 评价
    OrderOperateButtonType_ConfirmReceive, // 确认收货
    OrderOperateButtonType_EditOrder, // 修改订单
    OrderOperateButtonType_CancelOrder, // 取消订单
    OrderOperateButtonType_DetailOrder, // 订单详情
    OrderOperateButtonType_ChangePrice, // 订单改价
    OrderOperateButtonType_More, // 更多
};

@interface OrderOperateButtonModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) OrderOperateButtonStyle style;
@property (nonatomic, assign) OrderOperateButtonType type;
@property (nonatomic, assign) NSInteger index;
@end


@class OrderOperateButton;
@protocol OrderOperateButtonDelegate <NSObject>
-(void)tapOrderOperateButton:(OrderOperateButton *)button model:(OrderOperateButtonModel *)model;
@end

@interface OrderOperateButton : UIView
@property (nonatomic, strong) OrderOperateButtonModel * model;
@property (nonatomic, weak) id<OrderOperateButtonDelegate> delegate;
@end

@class OrderOperateBoxView;
@protocol OrderOperateBoxViewDelegate <NSObject>
-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view;
@end

@interface OrderOperateBoxView : UIView
@property (nonatomic, strong) IBOutlet UIView * view;
@property (nonatomic, strong) NSArray<OrderOperateButtonModel *> *buttonModelArray;
@property (nonatomic, weak) id<OrderOperateBoxViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
