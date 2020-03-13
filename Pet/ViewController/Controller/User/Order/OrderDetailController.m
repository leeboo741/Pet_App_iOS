//
//  OrderDetailController.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderDetailController.h"
#import "PaymentViewController.h"

#pragma mark - PremiumModel
#pragma mark -

@interface PremiumModel : NSObject
@property (nonatomic, copy) NSString * premiumAmount; // 补价金额
@property (nonatomic, copy) NSString * premiumReason; // 补价原因
@property (nonatomic, copy) NSString * premiumTime; // 申请时间
@property (nonatomic, copy) NSString * premiumState; // 补价状态
@property (nonatomic, copy) NSString * premiumNo; // 补价单编号
@property (nonatomic, copy) NSString * orderNo; // 关联单编号
@end

@implementation PremiumModel
@end

#pragma mark - OrderStepModel
#pragma mark -

@interface OrderStepModel : NSObject
@property (nonatomic, copy) NSString * stepTitle;
@property (nonatomic, copy) NSString * stepTime;
@property (nonatomic, strong, nullable) NSArray * stepMediaList;
@end
@implementation OrderStepModel
@end

#pragma mark - OrderDetailController
#pragma mark -

#import "OrderInfoCell.h"
#import "OrderPremiumCell.h"
#import "OrderRemarkInputCell.h"
#import "OrderStepCell.h"
#import "OrderTempDeliverCell.h"
#import "OrderRemarkCell.h"
#import "DateUtils.h"
#import "CommonOrderManager.h"

static NSString * OrderInfoCellIdentifier = @"OrderInfoCell";
static NSString * OrderPremiumCellIdentifier = @"OrderPremiumCell";
static NSString * OrderRemarkInputCellIdentifier = @"OrderRemarkInputCell";
static NSString * OrderRemarkCellIdentifier = @"OrderRemarkCell";
static NSString * OrderStepCellIdentifier = @"OrderStepCell";
static NSString * OrderTempDeliverCellIdentifier = @"OrderTempDeliverCell";

@interface OrderDetailController () <OrderPremiumCellDelegate,OrderRemarkInputCellDelegate>
@property (nonatomic, strong) NSArray<PremiumModel *> * premiumList;
@property (nonatomic, strong) NSArray * baseInfoList;
@property (nonatomic, strong) NSArray * addServiceList;
@property (nonatomic, strong) NSArray * senderAndReceiverList;
@property (nonatomic, strong) NSArray * remarkList;
@property (nonatomic, strong) NSArray * orderStepList;
@property (nonatomic, strong) OrderEntity * orderEntity;
@property (nonatomic, assign) BOOL ableConfirmOrder;
@property (nonatomic, strong) UIButton * confirmButton;
@end

@implementation OrderDetailController
-(instancetype)init{
    if (self = [super init]) {
        self.ableConfirmOrder = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    self.tableView.backgroundColor = Color_white_1;
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderInfoCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderInfoCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderPremiumCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderPremiumCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderRemarkInputCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderRemarkInputCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderRemarkCellIdentifier bundle:nil] forCellReuseIdentifier:OrderRemarkCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderStepCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderStepCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderTempDeliverCellIdentifier bundle:nil] forCellReuseIdentifier:OrderTempDeliverCellIdentifier];
    
    [self getOrderDetailWithOrderNo:self.orderNo];
    [self checkAbleConfirmOrder:self.orderNo];
}
#pragma mark - private method
-(void)confirmOrderAction{
    __weak typeof(self) weakSelf = self;
    NSString * orderNo = self.orderNo;
    [[CustomerOrderManager shareCustomerOrderManager] receiverCustomerOrderWithOrderNo:orderNo success:^(id  _Nonnull data) {
        [weakSelf checkAbleConfirmOrder:orderNo];
        [weakSelf getOrderDetailWithOrderNo:orderNo];
    } fail:^(NSInteger code) {
        
    }];
}

-(void)checkAbleConfirmOrder:(NSString * )orderNo{
    __weak typeof(self) weakSelf = self;
    [[CustomerOrderManager shareCustomerOrderManager] ableConfirmOrderWithOrderNo:orderNo customrNo:[[UserManager shareUserManager] getCustomerNo] success:^(id  _Nonnull data) {
        if ([data intValue] == 1) {
            if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_CUSTOMER) {
                weakSelf.ableConfirmOrder = true;
                [weakSelf.tableView reloadData];
            }
        }
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getOrderDetailWithOrderNo:(NSString *)orderNo{
    __weak typeof(self) weakSelf = self;
    [[CommonOrderManager shareCommonOrderManager] getOrderDetailWithOrderNo:orderNo success:^(id  _Nonnull data) {
        weakSelf.orderEntity = (OrderEntity*)data;
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        
    }];
}

-(NSString *)getCellValueWithValue:(NSString *)value{
    if (kStringIsEmpty(value)) {
        return @"暂无";
    }
    return value;
}

-(NSString *)getSecretValue:(NSString *)value secret:(BOOL)secret{
    if (secret) {
        return @"保密信息";
    }
    return value;
}

-(NSString *)getAddedValueHaveAdded:(BOOL)haveAdded{
    if (haveAdded) {
        return @"是";
    }
    return @"否";
}

-(BOOL)ableShowRemark{
    return [[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_STAFF;
}

-(BOOL)ableShowTempDeliver{
    return !kArrayIsEmpty(self.orderEntity.orderTempDelivers);
}

-(BOOL)ableShowPremium{
    return !kArrayIsEmpty(self.premiumList);
}

#pragma mark - tableView datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        // 补价
        OrderPremiumCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderPremiumCellIdentifier forIndexPath:indexPath];
        [self configPremiumCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1 // 基础信息
               || indexPath.section == 2 // 增值服务
               || indexPath.section == 3) { // 收寄人信息
        OrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellIdentifier forIndexPath:indexPath];
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 4) {
        // 临派信息
        OrderTempDeliverCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderTempDeliverCellIdentifier forIndexPath:indexPath];
        [self configTempDeliverCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 5) {
        // 备注
        if (indexPath.row == self.remarkList.count) {
            OrderRemarkInputCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderRemarkInputCellIdentifier forIndexPath:indexPath];
            [self configRemarkInputCell:cell atIndexPath:indexPath];
            return cell;
        } else {
            OrderRemarkCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderRemarkCellIdentifier forIndexPath:indexPath];
            [self configRemarkCell:cell atIndexPath:indexPath];
            return cell;
        }
    } else if (indexPath.section == 6) {
        // 订单进度
        OrderStepCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderStepCellIdentifier forIndexPath:indexPath];
        [self configStepCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return [tableView fd_heightForCellWithIdentifier:OrderPremiumCellIdentifier configuration:^(id cell) {
                [self configPremiumCell:cell atIndexPath:indexPath];
            }];
        }
        case 1:
        case 2:
        case 3:
        {
            return [tableView fd_heightForCellWithIdentifier:OrderInfoCellIdentifier configuration:^(id cell) {
                [self configCell:cell atIndexPath:indexPath];
            }];
        }
        case 4:
        {
            return [tableView fd_heightForCellWithIdentifier:OrderTempDeliverCellIdentifier configuration:^(id cell) {
                [self configTempDeliverCell:cell atIndexPath:indexPath];
            }];
        }
        case 5:
        {
            if (indexPath.row == self.remarkList.count) {
                return [tableView fd_heightForCellWithIdentifier:OrderRemarkInputCellIdentifier configuration:^(id cell) {
                    [self configRemarkInputCell:cell atIndexPath:indexPath];
                }];
            } else {
                return [tableView fd_heightForCellWithIdentifier:OrderRemarkCellIdentifier configuration:^(id cell) {
                    [self configRemarkCell:cell atIndexPath:indexPath];
                }];
            }
        }
        case 6:
        {
            return [tableView fd_heightForCellWithIdentifier:OrderStepCellIdentifier configuration:^(id cell) {
                [self configStepCell:cell atIndexPath:indexPath];
            }];
        }
        default:
            return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self ableShowPremium]?self.premiumList.count:0;
        case 1:
            return self.baseInfoList.count;
        case 2:
            return self.addServiceList.count;
        case 3:
            return self.senderAndReceiverList.count;
        case 4:
            return [self ableShowTempDeliver]?self.orderEntity.orderTempDelivers.count:0;
        case 5:
            return [self ableShowRemark]?self.remarkList.count + 1:0;
        case 6:
            return self.orderStepList.count;
        default:
            return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"补价信息";
        case 1:
            return @"基本信息";
        case 2:
            return @"增值服务";
        case 3:
            return @"收寄人信息";
        case 4:
            return @"临时派送";
        case 5:
            return @"员工备注";
        case 6:
            return @"订单进度";
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self ableShowPremium]?40:0;
        case 1:
            return 40;
        case 2:
            return 40;
        case 3:
            return 40;
        case 4:
            return [self ableShowTempDeliver]?40:0;
        case 5:
            return [self ableShowRemark]?40:0;
            return 40;
        case 6:
            return 40;
        default:
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 6) {
        return self.ableConfirmOrder?self.confirmButton:nil;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 6) {
        return self.ableConfirmOrder?60:0;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

#pragma mark - cell delegate

-(void)remarkInputShouldReturnAtCell:(OrderRemarkInputCell *)cell text:(NSString *)text{
    OrderRemarks * orderRemark = [[OrderRemarks alloc] init];
    orderRemark.staff = [[UserManager shareUserManager] getStaff];
    orderRemark.order = self.orderEntity;
    orderRemark.remarks = text;
    orderRemark.dateTime = [[DateUtils shareDateUtils] getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMDHMS];
    [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    [[SiteOrderManager shareSiteOrderManager] addOrderRemark:orderRemark success:^(id  _Nonnull data) {
        [MBProgressHUD  hideHUD];
        if ([data intValue] < 1) {
            [MBProgressHUD showErrorMessage:@"新增备注失败"];
        } else {
            NSMutableArray * array = [NSMutableArray arrayWithArray:weakSelf.orderEntity.orderRemarksList];
            [array insertObject:orderRemark atIndex:0];
            weakSelf.orderEntity.orderRemarksList = [NSArray arrayWithArray:array];
            [weakSelf.tableView reloadData];
            [cell clearInput];
        }
    } fail:^(NSInteger code) {
        
    }];
}

-(void)tapPremiumCancelButtonAtOrderPremiumCell:(OrderPremiumCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderPremium * premium = self.orderEntity.orderPremiumList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [[SiteOrderManager shareSiteOrderManager] cancelOrderPremiumWithBillNo:premium.billNo success:^(id  _Nonnull data) {
        if ([data intValue] < 1) {
            [MBProgressHUD showErrorMessage:@"取消失败"];
        } else {
            premium.state = @"已取消";
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } fail:^(NSInteger code) {
        
    }];
}

-(void)tapPremiumButtonWithState:(NSString *)premiumState atOrderPremiumCell:(OrderPremiumCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderPremium * premium = self.orderEntity.orderPremiumList[indexPath.row];
    PaymentViewController * paymentViewController = [[PaymentViewController alloc]init];
    paymentViewController.payAmount = premium.amount;
    paymentViewController.orderNo = premium.billNo;
    paymentViewController.paymentType = Payment_Order_Type_Premium;
    __weak typeof(self) weakSelf = self;
    paymentViewController.completeBlock = ^(BOOL paySuccess) {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:paymentViewController animated:YES];
}

#pragma mark - config cell

-(void)configCell:(OrderInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.infoDetail = @"";
    if (indexPath.section == 1) {
        cell.infoTitle = self.baseInfoList[indexPath.row];
        if (indexPath.row == 0) {
            cell.infoValue = self.orderEntity.orderNo;
        } else if (indexPath.row == 1) {
            cell.infoValue = [NSString stringWithFormat:@"%@ %@",self.orderEntity.orderDate, self.orderEntity.orderTime];
        } else if (indexPath.row == 2) {
            cell.infoValue = self.orderEntity.outportTime;
        } else if (indexPath.row == 3) {
            cell.infoValue = self.orderEntity.orderState;
        } else if (indexPath.row == 4) {
            cell.infoValue = [NSString stringWithFormat:@"￥%@",self.orderEntity.orderAmount];
        } else if (indexPath.row == 5) {
            cell.infoValue = self.orderEntity.transport.station.stationName;
        } else if (indexPath.row == 6) {
            cell.infoValue = [NSString stringWithFormat:@"%@ - %@",self.orderEntity.transport.startCity, self.orderEntity.transport.endCity];
        } else if (indexPath.row == 7) {
            cell.infoValue = self.orderEntity.transport.transportTypeName;
        } else if (indexPath.row == 8) {
            cell.infoValue = [self getCellValueWithValue:self.orderEntity.orderTransport.transportNum];
        } else if (indexPath.row == 9) {
            cell.infoValue = [self getCellValueWithValue:self.orderEntity.orderTransport.expressNum];
        } else if (indexPath.row == 10) {
            cell.infoValue = [NSString stringWithFormat:@"%ld",self.orderEntity.num];
        } else if (indexPath.row == 11) {
            cell.infoValue = [NSString stringWithFormat:@"%.2f",self.orderEntity.weight];
        } else if (indexPath.row == 12) {
            cell.infoValue = self.orderEntity.petType.petTypeName;
        } else if (indexPath.row == 13) {
            cell.infoValue = self.orderEntity.petBreed.petBreedName;
        } else if (indexPath.row == 14) {
            cell.infoValue = [self getCellValueWithValue:self.orderEntity.orderRemark];
        }
    } else if (indexPath.section == 2) {
        cell.infoTitle = self.addServiceList[indexPath.row];
        if (indexPath.row == 0) {
            cell.infoValue = [self getAddedValueHaveAdded:(self.orderEntity.addedWeightCage != nil)];
            if (self.orderEntity.addedWeightCage != nil) {
                cell.infoDetail = self.orderEntity.addedWeightCage.cageName;
            }
        } else if (indexPath.row == 1) {
            cell.infoValue = [self getAddedValueHaveAdded:(!kStringIsEmpty(self.orderEntity.receiptAddress))];
            if (!kStringIsEmpty(self.orderEntity.receiptAddress)) {
                cell.infoDetail = self.orderEntity.receiptAddress;
            }
        } else if (indexPath.row == 2) {
            cell.infoValue = [self getAddedValueHaveAdded:(!kStringIsEmpty(self.orderEntity.sendAddress))];
            if (!kStringIsEmpty(self.orderEntity.sendAddress)) {
                cell.infoDetail = self.orderEntity.sendAddress;
            }
        } else if (indexPath.row == 3) {
            cell.infoValue = [self getAddedValueHaveAdded:(self.orderEntity.addedInsure!=nil)];
            if (self.orderEntity.addedInsure) {
                cell.infoDetail = [NSString stringWithFormat:@"￥%.2f",self.orderEntity.addedInsure.insureAmount];
            }
        } else if (indexPath.row == 4) {
            cell.infoValue = [self getAddedValueHaveAdded:!kStringIsEmpty(self.orderEntity.guarantee)];
        } else if (indexPath.row == 5) {
            cell.infoValue = [self getAddedValueHaveAdded:NO];
        } else if (indexPath.row == 6) {
            cell.infoValue = [self getAddedValueHaveAdded:NO];
        } else if (indexPath.row == 7) {
            cell.infoValue = [self getAddedValueHaveAdded:NO];
        }
    } else if (indexPath.section == 3) {
        cell.infoTitle = self.senderAndReceiverList[indexPath.row];
        if (indexPath.row == 0) {
            cell.infoValue = self.orderEntity.senderPhone;
            cell.infoDetail = self.orderEntity.senderName;
        } else if (indexPath.row == 1) {
            cell.infoValue = self.orderEntity.receiverPhone;
            cell.infoDetail = self.orderEntity.receiverName;
        }
    }
}

-(void)configTempDeliverCell:(OrderTempDeliverCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderTempDeliver * tempDeliver = self.orderEntity.orderTempDelivers[indexPath.row];
    cell.tempDeliverName = tempDeliver.recipientName;
    cell.tempDeliverPhone = tempDeliver.recipientPhone;
    cell.tempDeliverAddress = tempDeliver.address;
    cell.tempDeliverTime = tempDeliver.deliverTime;
}

-(void)configPremiumCell:(OrderPremiumCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    PremiumModel * model = self.premiumList[indexPath.row];
    cell.delegate = self;
    cell.premiumAmount = model.premiumAmount;
    cell.premiumState = model.premiumState;
    cell.premiumTime = model.premiumTime;
    cell.premiumReason = model.premiumReason;
}

-(void)configRemarkInputCell:(OrderRemarkInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}

-(void)configRemarkCell:(OrderRemarkCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderRemarks * remarks = self.orderEntity.orderRemarksList[indexPath.row];
    cell.remarkContent = remarks.remarks;
    cell.remarkTime = remarks.dateTime;
}

-(void)configStepCell:(OrderStepCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderStepModel * model = self.orderStepList[indexPath.row];
    cell.stepTime = model.stepTime;
    cell.stepTitle = model.stepTitle;
    cell.mediaList = model.stepMediaList;
    cell.stepIndex = indexPath.row + 1;
    if (indexPath.row == 0) {
        cell.type = StepItemType_Top;
    } else if (indexPath.row == self.orderStepList.count - 1) {
        cell.type = StepItemType_Bottom;
    } else {
        cell.type = StepItemType_Middle;
    }
}

#pragma mark - setters and getters
-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setBackgroundColor:Color_yellow_1];
        [_confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:Color_white_1 forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmOrderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
-(NSArray<PremiumModel *> *)premiumList{
    if (kArrayIsEmpty(self.orderEntity.orderPremiumList)) {
        _premiumList = @[];
    } else {
        NSMutableArray * array = [NSMutableArray array];
        for (OrderPremium * orderPremium in self.orderEntity.orderPremiumList) {
            PremiumModel * premiumModel = [[PremiumModel alloc]init];
            premiumModel.premiumAmount = [NSString stringWithFormat:@"%.2f",orderPremium.amount];
            premiumModel.premiumReason = orderPremium.reason;
            premiumModel.premiumState = orderPremium.state;
            premiumModel.premiumTime = [NSString stringWithFormat:@"%@ %@",orderPremium.orderDate,orderPremium.orderTime];
            premiumModel.premiumNo = orderPremium.billNo;
            premiumModel.orderNo = orderPremium.orderNo;
            [array addObject:premiumModel];
        }
        _premiumList = array;
    }
    return _premiumList;
}

-(NSArray *)baseInfoList{
    if (!_baseInfoList) {
        _baseInfoList = @[@"订单号",@"下单时间",@"出发时间",@"订单状态",@"订单金额",@"物流",@"物流区间",@"运输方式",@"航班号|车次号",@"快递单号",@"宠物数量",@"宠物重量",@"宠物种类",@"宠物品种",@"客户备注"];
    }
    return _baseInfoList;
}

-(NSArray *)addServiceList{
    if (!_addServiceList) {
        _addServiceList = @[@"购买宠物箱",@"上门接宠",@"送宠到家",@"声明价值",@"中介担保",@"饮水器",@"暖窝",@"保暖外套"];
    }
    return _addServiceList;
}

-(NSArray *)senderAndReceiverList{
    if (!_senderAndReceiverList) {
        _senderAndReceiverList = @[@"寄件人",@"收件人"];
    }
    return _senderAndReceiverList;
}

-(NSArray *)remarkList{
    if (self.orderEntity.orderRemarksList) {
        _remarkList = self.orderEntity.orderRemarksList;
    } else {
        _remarkList = @[];
    }
    return _remarkList;
}

-(NSArray *)orderStepList{
    if (self.orderEntity.orderStates) {
        NSMutableArray * array = [NSMutableArray array];
        for (OrderStatus * orderStatus in self.orderEntity.orderStates) {
            OrderStepModel * model = [[OrderStepModel alloc]init];
            model.stepTitle = orderStatus.currentPosition;
            model.stepTime = [NSString stringWithFormat:@"%@ %@",orderStatus.date,orderStatus.time];
            NSMutableArray * mediaArray = [NSMutableArray array];
            for (OrderMedia * media in orderStatus.orderMediaList) {
                [mediaArray addObject:media.mediaAddress];
            }
            model.stepMediaList = [NSArray arrayWithArray:mediaArray];
            [array addObject:model];
        }
        _orderStepList = [NSArray arrayWithArray:array];
    } else {
        _orderStepList = @[];
    }
    return _orderStepList;
}
@end
