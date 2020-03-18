//
//  SiteOutportOrderCell.m
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteOutportOrderCell.h"
#import "OrderBaseInfoView.h"
#import "OrderOperateBoxView.h"
#import "OrderRemarkView.h"
#import "OrderAssignmentsView.h"
#import "MediaShowBox.h"
#import "SiteOrderManager.h"

@interface SiteOutportOrderCell () <OrderOperateBoxViewDelegate,MediaSelectBoxViewDelegate,MediaSelectBoxViewConfig,MediaShowBoxDelegate,MediaShowBoxDataSource>
@property (weak, nonatomic) IBOutlet OrderBaseInfoView *orderBaseInfoView;
@property (weak, nonatomic) IBOutlet OrderAssignmentsView *orderAssignmentsView;
@property (weak, nonatomic) IBOutlet OrderRemarkView *orderRemarkView;
@property (weak, nonatomic) IBOutlet MediaShowBox *mediaShowBox;
@property (weak, nonatomic) IBOutlet MediaShowBox *uploadMediaShowBox;
@property (weak, nonatomic) IBOutlet MediaSelectBoxView *mediaSelectBoxView;
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *orderOperateBoxView;
@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;

@property (nonatomic, strong) NSArray<MediaSelectItemModel *>* selectImageDataList;
@property (nonatomic, strong) NSArray<MediaShowItemModel *> * showImageDataList;
@property (nonatomic, strong) NSArray<MediaShowItemModel *> * commitImageDataList;

@end

@implementation SiteOutportOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.orderOperateBoxView.delegate = self;
    self.mediaSelectBoxView.delegate = self;
    self.mediaSelectBoxView.config = self;
    self.mediaShowBox.dataSource = self;
    self.uploadMediaShowBox.dataSource = self;
    if (![[UserManager shareUserManager] isManager]) {
        self.orderAssignmentsView.hidden = YES;
    } else {
        self.orderAssignmentsView.hidden = NO;
    }
    [self initButtonArray];
    
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

#pragma mark - media select box view delegate and config

-(void)mediaSelectBoxView:(MediaSelectBoxView *)view dataSourceDidChanged:(NSArray<MediaSelectItemModel *> *)dataSource{
    if (_delegate && [_delegate respondsToSelector:@selector(siteOutportOrderCell:selectImageDataChange:)]) {
        [_delegate siteOutportOrderCell:self selectImageDataChange:dataSource];
    }
    [self initButtonArray];
}

-(NSInteger)numberOfMediaSelectBoxColumn{
    return 4;
}
-(CGFloat)heightOfMediaSelectBoxItem {
    return 120;
}

#pragma mark - operate box view delegate

-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view{
    MSLog(@"%ld",model.index);
    if (_delegate && [_delegate respondsToSelector:@selector(tapSiteOutportOrderCell:operateType:)]) {
        [_delegate tapSiteOutportOrderCell:self operateType:model.type];
    }
}

#pragma mark - setters and getters

-(NSMutableArray<OrderOperateButtonModel *> *)operateButtonModelArray{
    if (!_operateButtonModelArray) {
        _operateButtonModelArray = [NSMutableArray array];
    }
    return _operateButtonModelArray;
}

-(void)setSelectImageDataList:(NSArray<MediaSelectItemModel *> *)selectImageDataList{
    _selectImageDataList = selectImageDataList;
    self.mediaSelectBoxView.dataSource = [NSMutableArray arrayWithArray:selectImageDataList];
}
-(void)setShowImageDataList:(NSArray<MediaShowItemModel *> *)showImageDataList{
    _showImageDataList = showImageDataList;
    self.mediaShowBox.data = [NSMutableArray arrayWithArray:showImageDataList];
}

-(void)setCommitImageDataList:(NSArray<MediaShowItemModel *> *)commitImageDataList{
    _commitImageDataList = commitImageDataList;
    self.uploadMediaShowBox.data = [NSMutableArray arrayWithArray:commitImageDataList];
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
    self.orderAssignmentsView.assignmentsStr = orderEntity.assignmentedStaffString;
    // 上一步骤 图片列表
    OrderStatus * status = [orderEntity.orderStates firstObject];
    NSMutableArray * showMediaList = [NSMutableArray array];
    for (OrderMedia * media in status.orderMediaList) {
        MediaShowItemModel * model = [[MediaShowItemModel alloc]init];
        model.resourcePath = media.mediaAddress;
        [showMediaList addObject:model];
    }
    self.showImageDataList = showMediaList;
    // 待提交的图片
    self.commitImageDataList = orderEntity.waitCommitMediaList;
    // 待上传的图片
    self.selectImageDataList = orderEntity.waitUploadMediaList;
    [self initButtonArray];
}

#pragma mark - private method

-(BOOL)showUploadButton{
    return !kArrayIsEmpty(self.selectImageDataList);
}
-(BOOL)showInOrOutPortButton{
    return kArrayIsEmpty(self.selectImageDataList) && !kArrayIsEmpty(self.commitImageDataList);
}

-(NSString *)inOrOutPortButtonTitle{
    OrderStatus * status = [self.orderEntity.orderStates firstObject];
    SiteOrderState state = [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateByString:status.orderType];
    if (state == SiteOrderState_ToPack ) {
        return @"揽件";
    } else if (state == SiteOrderState_ToInport) {
        return @"入港";
    } else if (state == SiteOrderState_ToOutport) {
        return @"出港";
    } else {
        return @"未知";
    }
}

-(void)initButtonArray{
    [self.operateButtonModelArray removeAllObjects];
    [self insertButtonModelWithTitle:@"上传" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Upload show:[self showUploadButton]];
    [self insertButtonModelWithTitle:[self inOrOutPortButtonTitle] style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Package show:[self showInOrOutPortButton]];
    [self insertButtonModelWithTitle:@"备注" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Remark show:YES];
    [self insertButtonModelWithTitle:@"分配订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Assignment show:[[UserManager shareUserManager] isManager]];
    [self insertButtonModelWithTitle:@"补价" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_AddPrice show:YES];
    [self insertButtonModelWithTitle:@"退款" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Refund show:YES];
    [self insertButtonModelWithTitle:@"订单详情" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_DetailOrder show:YES];
    [self insertButtonModelWithTitle:@"打印标签" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Print show:YES];
    
    self.orderOperateBoxView.buttonModelArray = self.operateButtonModelArray;
}

-(void)insertButtonModelWithTitle:(NSString *)title style:(OrderOperateButtonStyle)style type:(OrderOperateButtonType)type show:(BOOL)show{
    OrderOperateButtonModel * model = [[OrderOperateButtonModel alloc]init];
    model.title = title;
    model.style = style;
    model.type = type;
    model.show = show;
    [self.operateButtonModelArray addObject:model];
}


@end
