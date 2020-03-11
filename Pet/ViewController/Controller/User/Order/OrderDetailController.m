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

static NSString * OrderInfoCellIdentifier = @"OrderInfoCell";
static NSString * OrderPremiumCellIdentifier = @"OrderPremiumCell";
static NSString * OrderRemarkInputCellIdentifier = @"OrderRemarkInputCell";
static NSString * OrderStepCellIdentifier = @"OrderStepCell";
static NSString * OrderTempDeliverCellIdentifier = @"OrderTempDeliverCell";

@interface OrderDetailController () <OrderPremiumCellDelegate>
@property (nonatomic, strong) NSArray<PremiumModel *> * premiumList;
@property (nonatomic, strong) NSArray * baseInfoList;
@property (nonatomic, strong) NSArray * addServiceList;
@property (nonatomic, strong) NSArray * senderAndReceiverList;
@property (nonatomic, strong) NSArray * remarkList;
@property (nonatomic, strong) NSArray * orderStepList;
@property (nonatomic, strong) OrderEntity * orderEntity;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderInfoCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderInfoCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderPremiumCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderPremiumCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderRemarkInputCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderRemarkInputCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderStepCellIdentifier bundle:nil]
         forCellReuseIdentifier:OrderStepCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:OrderTempDeliverCellIdentifier bundle:nil] forCellReuseIdentifier:OrderTempDeliverCellIdentifier];
    
    [self getOrderDetailWithOrderNo:self.orderNo];
}
#pragma mark - private method

-(void)getOrderDetailWithOrderNo:(NSString *)orderNo{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"customerNo": [[UserManager shareUserManager] getCustomerNo]
    };
    __weak typeof(self) weakSelf = self;
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Order_Detail paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        weakSelf.orderEntity = [OrderEntity mj_objectWithKeyValues:data];
        [weakSelf.tableView reloadData];
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
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
            OrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellIdentifier forIndexPath:indexPath];
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
                return [tableView fd_heightForCellWithIdentifier:OrderInfoCellIdentifier configuration:^(id cell) {
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
            return self.premiumList.count;
        case 1:
            return self.baseInfoList.count;
        case 2:
            return self.addServiceList.count;
        case 3:
            return self.senderAndReceiverList.count;
        case 4:
            return Util_IsEmptyArray(self.orderEntity.orderTempDelivers)?0:self.orderEntity.orderTempDelivers.count;
        case 5:
            return self.remarkList.count + 1;
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
            return @"备注";
        case 6:
            return @"订单进度";
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return kArrayIsEmpty(self.premiumList)? 0: 40;
        case 1:
            return 40;
        case 2:
            return 40;
        case 3:
            return 40;
        case 4:
            return kArrayIsEmpty(self.orderEntity.orderTempDelivers)?0:40;
        case 5:
            return 40;
        case 6:
            return 40;
        default:
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

#pragma mark - cell delegate

-(void)tapPremiumCancelButtonAtOrderPremiumCell:(OrderPremiumCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderPremium * premium = self.orderEntity.orderPremiumList[indexPath.row];
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
//        if (paySuccess) {
            [weakSelf.tableView reloadData];
//        }
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
    
}

-(void)configRemarkCell:(OrderInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
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
    if (!_remarkList) {
        _remarkList = @[];
    }
    return _remarkList;
}

-(NSArray *)orderStepList{
    if (!_orderStepList) {
        OrderStepModel * model = [[OrderStepModel alloc]init];
        model.stepTitle = @"步骤1";
        model.stepTime = @"2020-01-10 01:06:22";
        model.stepMediaList = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg",@"https://media.w3.org/2010/05/sintel/trailer.mp4",@"https://buzhidao.ss.com/sda"];
        OrderStepModel * model1 = [[OrderStepModel alloc]init];
        model1.stepTitle = @"步骤2";
        model1.stepTime = @"2020-01-10 01:06:22";
        model1.stepMediaList = nil;
        OrderStepModel * model2 = [[OrderStepModel alloc]init];
        model2.stepTitle = @"步骤3";
        model2.stepTime = @"2020-01-10 01:06:22";
        model2.stepMediaList = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg",@"https://media.w3.org/2010/05/sintel/trailer.mp4",@"https://buzhidao.ss.com/sda",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg",@"https://media.w3.org/2010/05/sintel/trailer.mp4",@"https://buzhidao.ss.com/sda",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg",@"https://media.w3.org/2010/05/sintel/trailer.mp4",@"https://buzhidao.ss.com/sda"];
        OrderStepModel * model3 = [[OrderStepModel alloc]init];
        model3.stepTitle = @"步骤4";
        model3.stepTime = @"2020-01-10 01:06:22";
        model3.stepMediaList = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg",@"https://media.w3.org/2010/05/sintel/trailer.mp4",@"https://buzhidao.ss.com/sda"];
        
        _orderStepList = @[model,model1,model2,model3];
    }
    return _orderStepList;
}
@end
