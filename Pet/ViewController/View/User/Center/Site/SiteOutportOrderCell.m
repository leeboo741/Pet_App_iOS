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

@interface SiteOutportOrderCell () <OrderOperateBoxViewDelegate,MediaSelectBoxViewDelegate,MediaSelectBoxViewConfig>
@property (weak, nonatomic) IBOutlet OrderBaseInfoView *orderBaseInfoView;
@property (weak, nonatomic) IBOutlet OrderAssignmentsView *orderAssignmentsView;
@property (weak, nonatomic) IBOutlet OrderRemarkView *orderRemarkView;
@property (weak, nonatomic) IBOutlet MediaSelectBoxView *mediaSelectBoxView;
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *orderOperateBoxView;
@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;

@end

@implementation SiteOutportOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.orderOperateBoxView.delegate = self;
    self.mediaSelectBoxView.delegate = self;
    self.mediaSelectBoxView.config = self;
    if ([[UserManager shareUserManager] getUserRole] != USER_ROLE_MANAGER) {
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

#pragma mark - media select box view delegate and config

-(void)mediaSelectBoxView:(MediaSelectBoxView *)view dataSourceDidChanged:(NSArray<MediaSelectItemModel *> *)dataSource{
    if (_delegate && [_delegate respondsToSelector:@selector(siteOutportOrderCell:selectImageDataChange:)]) {
        [_delegate siteOutportOrderCell:self selectImageDataChange:dataSource];
    }
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

-(void)setOrderEntity:(OrderEntity *)orderEntity{
    _orderEntity = orderEntity;
    self.orderBaseInfoView.orderNo = orderEntity.orderNo;
    self.orderAssignmentsView.assignmentsStr = orderEntity.assignmentedStaffString;
}

#pragma mark - private method

-(void)initButtonArray{
    [self.operateButtonModelArray removeAllObjects];
    [self insertButtonModelWithTitle:@"上传" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Upload show:!kArrayIsEmpty(self.selectImageDataList)];
    [self insertButtonModelWithTitle:@"揽件" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Package show:NO];
    [self insertButtonModelWithTitle:@"出港" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_OutInPort show:NO];
    [self insertButtonModelWithTitle:@"备注" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Remark show:YES];
    [self insertButtonModelWithTitle:@"分配订单" style:OrderOperateButtonStyle_Yellow type:OrderOperateButtonType_Assignment show:[[UserManager shareUserManager] getUserRole] == USER_ROLE_MANAGER];
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