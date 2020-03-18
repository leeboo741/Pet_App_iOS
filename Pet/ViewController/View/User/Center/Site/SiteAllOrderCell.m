//
//  SiteAllOrderCell.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteAllOrderCell.h"
#import "OrderBaseInfoView.h"
#import "OrderRemarkView.h"
#import "OrderOperateBoxView.h"
#import "MediaShowBox.h"

@interface SiteAllOrderCell () <OrderOperateBoxViewDelegate,MediaShowBoxDataSource>
@property (weak, nonatomic) IBOutlet OrderBaseInfoView *orderBaseInfoView;
@property (weak, nonatomic) IBOutlet OrderRemarkView *orderRemarkView;
@property (weak, nonatomic) IBOutlet MediaShowBox *mediaShowBoxView;
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *orderOperateBoxView;

@property (nonatomic, strong) NSArray<MediaShowItemModel *>* showImageDataList;

@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;
@end

@implementation SiteAllOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mediaShowBoxView.dataSource = self;
    self.orderOperateBoxView.delegate = self;
    [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder];
    self.orderOperateBoxView.buttonModelArray = self.operateButtonModelArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - media show box view delegate and datasource

-(NSInteger)itemColumnCountForMediaShowBox:(MediaShowBox *)showBox{
    return 4;
}
-(CGFloat)itemHeightForMediaShowBox:(MediaShowBox *)showBox{
    return 120;
}

#pragma mark - operate box view delegate

-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view{
    MSLog(@"%ld",model.index);
    if (_delegate && [_delegate respondsToSelector:@selector(tapSiteAllOrderCell:operateType:)]) {
        [_delegate tapSiteAllOrderCell:self operateType:model.type];
    }
}

#pragma mark - setters and getters

-(NSMutableArray<OrderOperateButtonModel *> *)operateButtonModelArray{
    if (!_operateButtonModelArray) {
        _operateButtonModelArray = [NSMutableArray array];
    }
    return _operateButtonModelArray;
}

-(void)setShowImageDataList:(NSArray<MediaShowItemModel *> *)showImageDataList{
    _showImageDataList = showImageDataList;
    self.mediaShowBoxView.data = [NSMutableArray arrayWithArray:showImageDataList];
}

-(void)setOrderEntity:(OrderEntity *)orderEntity{
    _orderEntity = orderEntity;
    self.orderBaseInfoView.orderNo = orderEntity.orderNo;
    self.orderBaseInfoView.orderNo = orderEntity.orderNo;
    self.orderBaseInfoView.endCity = orderEntity.transport.endCity;
    self.orderBaseInfoView.startCity = orderEntity.transport.startCity;
    self.orderBaseInfoView.orderAmount = orderEntity.orderAmount;
    self.orderBaseInfoView.orderState = orderEntity.orderState;
    self.orderBaseInfoView.orderTime = orderEntity.orderTime;
    self.orderBaseInfoView.outportTime = orderEntity.outportTime;
    self.orderBaseInfoView.petBreed = orderEntity.petBreed.petBreedName;
    self.orderBaseInfoView.petType = orderEntity.petType.petTypeName;
    self.orderBaseInfoView.receiverName = orderEntity.receiverName;
    self.orderBaseInfoView.receiverPhone = orderEntity.receiverPhone;
    self.orderBaseInfoView.senderName = orderEntity.senderName;
    self.orderBaseInfoView.senderPhone = orderEntity.senderPhone;
    self.orderBaseInfoView.transportType = orderEntity.transport.transportTypeName;
    self.orderRemarkView.customerRemark = orderEntity.orderRemark;
    if (!kArrayIsEmpty(orderEntity.orderRemarksList)) {
        OrderRemarks * remarks = orderEntity.orderRemarksList[0];
        self.orderRemarkView.lastFollowUpContent = remarks.remarks;
    }
    // 上一步骤 图片列表
    OrderStatus * status = [orderEntity.orderStates lastObject];
    NSMutableArray * showMediaList = [NSMutableArray array];
    for (OrderMedia * media in status.orderMediaList) {
        MediaShowItemModel * model = [[MediaShowItemModel alloc]init];
        model.resourcePath = media.mediaAddress;
        [showMediaList addObject:model];
    }
    self.showImageDataList = showMediaList;
}


#pragma mark - private method

-(void)insertButtonModelWithTitle:(NSString *)title style:(OrderOperateButtonStyle)style type:(OrderOperateButtonType)type{
    OrderOperateButtonModel * model = [[OrderOperateButtonModel alloc]init];
    model.title = title;
    model.style = style;
    model.type = type;
    [self.operateButtonModelArray addObject:model];
}
@end
