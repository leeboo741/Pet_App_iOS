//
//  CustomerOrderCell.m
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CustomerOrderCell.h"
#import "OrderBaseInfoView.h"
#import "OrderOperateBoxView.h"

@interface CustomerOrderCell () <OrderOperateBoxViewDelegate>
@property (weak, nonatomic) IBOutlet OrderBaseInfoView *orderBaseInfoView;
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *orderOperateBoxView;
@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;
@end

@implementation CustomerOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.orderOperateBoxView.delegate = self;
    [self resetOperateButtonWithOrderType:CustomerOrderType_Unpay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - operate box view delegate

-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view{
    MSLog(@"%ld",model.index);
    if (_delegate && [_delegate respondsToSelector:@selector(tapCustomerOrderCell:operateType:atIndex:)]) {
        [_delegate tapCustomerOrderCell:self operateType:model.type atIndex:model.index];
    }
}

#pragma mark - setters and getters

-(NSMutableArray<OrderOperateButtonModel *> *)operateButtonModelArray{
    if (!_operateButtonModelArray) {
        _operateButtonModelArray = [NSMutableArray array];
    }
    return _operateButtonModelArray;
}

-(void)setOrderType:(CustomerOrderType)orderType{
    _orderType = orderType;
    [self resetOperateButtonWithOrderType:orderType];
}

-(void)setOrderEntity:(OrderEntity *)orderEntity {
    _orderEntity = orderEntity;
    self.orderBaseInfoView.orderNo = orderEntity.orderNo;
    self.orderBaseInfoView.orderTime = [NSString stringWithFormat:@"%@ %@",orderEntity.orderDate,orderEntity.orderTime];
    self.orderBaseInfoView.outportTime = orderEntity.outportTime;
    self.orderBaseInfoView.startCity = orderEntity.transport.startCity;
    self.orderBaseInfoView.endCity = orderEntity.transport.endCity;
    self.orderBaseInfoView.transportType = orderEntity.transport.transportTypeName;
    self.orderBaseInfoView.petType = orderEntity.petType.petTypeName;
    self.orderBaseInfoView.petBreed = orderEntity.petBreed.petBreedName;
    self.orderBaseInfoView.receiverName = orderEntity.receiverName;
    self.orderBaseInfoView.receiverPhone = orderEntity.receiverPhone;
    self.orderBaseInfoView.senderName = orderEntity.senderName;
    self.orderBaseInfoView.senderPhone = orderEntity.senderPhone;
    self.orderBaseInfoView.orderState = orderEntity.orderState;
    self.orderBaseInfoView.orderAmount = [NSString stringWithFormat:@"￥%@",orderEntity.orderAmount];
}

#pragma mark - private method

-(void)resetOperateButtonWithOrderType:(CustomerOrderType)orderType{
    
    [self.operateButtonModelArray removeAllObjects];
    switch (orderType) {
        case CustomerOrderType_Unpay:
        {
            [self insertButtonModelWithTitle:@"支付" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Pay];
            
            [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder];
            
            [self insertButtonModelWithTitle:@"修改订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_EditOrder];
            
            [self insertButtonModelWithTitle:@"取消订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_CancelOrder];
            
            [self insertButtonModelWithTitle:@"联系商家" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Call];
        }
            break;
        case CustomerOrderType_Unsend:
        {
            [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder];
            
            [self insertButtonModelWithTitle:@"修改订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_EditOrder];
            
            [self insertButtonModelWithTitle:@"联系商家" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Call];
        }
            break;
        case CustomerOrderType_Unreceive:
        {
            [self insertButtonModelWithTitle:@"确认收货" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_ConfirmReceive];
            
            [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder];
            
            [self insertButtonModelWithTitle:@"修改订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_EditOrder];
            
            [self insertButtonModelWithTitle:@"联系商家" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Call];
        }
            break;
        case CustomerOrderType_Complete:
        {
            [self insertButtonModelWithTitle:@"评价" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Evaluate];
            
            [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder];
            
            [self insertButtonModelWithTitle:@"联系商家" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Call];
        }
            break;
            
        default:
            break;
    }
    
    self.orderOperateBoxView.buttonModelArray = self.operateButtonModelArray;
}

-(void)insertButtonModelWithTitle:(NSString *)title style:(OrderOperateButtonStyle)style type:(OrderOperateButtonType)type{
    OrderOperateButtonModel * model = [[OrderOperateButtonModel alloc]init];
    model.title = title;
    model.style = style;
    model.type = type;
    [self.operateButtonModelArray addObject:model];
}

@end
