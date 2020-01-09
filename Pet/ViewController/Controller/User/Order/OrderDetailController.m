//
//  OrderDetailController.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderDetailController.h"

#pragma mark - PremiumModel
#pragma mark -

@interface PremiumModel : NSObject
@property (nonatomic, copy) NSString * premiumAmount; // 补价金额
@property (nonatomic, copy) NSString * premiumReason; // 补价原因
@property (nonatomic, copy) NSString * premiumTime; // 申请时间
@property (nonatomic, copy) NSString * premiumState; // 补价状态
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

static NSString * OrderInfoCellIdentifier = @"OrderInfoCell";
static NSString * OrderPremiumCellIdentifier = @"OrderPremiumCell";
static NSString * OrderRemarkInputCellIdentifier = @"OrderRemarkInputCell";
static NSString * OrderStepCellIdentifier = @"OrderStepCell";

@interface OrderDetailController ()
@property (nonatomic, strong) NSArray<PremiumModel *> * premiumList;
@property (nonatomic, strong) NSArray * baseInfoList;
@property (nonatomic, strong) NSArray * addServiceList;
@property (nonatomic, strong) NSArray * senderAndReceiverList;
@property (nonatomic, strong) NSArray * remarkList;
@property (nonatomic, strong) NSArray * orderStepList;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self.tableView registerNib:[UINib nibWithNibName:OrderInfoCellIdentifier bundle:nil] forCellReuseIdentifier:OrderInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderPremiumCellIdentifier bundle:nil] forCellReuseIdentifier:OrderPremiumCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderRemarkInputCellIdentifier bundle:nil] forCellReuseIdentifier:OrderRemarkInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderStepCellIdentifier bundle:nil] forCellReuseIdentifier:OrderStepCellIdentifier];
}

#pragma mark - tableView datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    } else if (indexPath.section == 5) {
        // 订单进度
        OrderStepCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderStepCellIdentifier forIndexPath:indexPath];
        [self configStepCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        case 5:
        {
            return [tableView fd_heightForCellWithIdentifier:OrderStepCellIdentifier configuration:^(id cell) {
                [self configStepCell:cell atIndexPath:indexPath];
            }];
        }
        default:
            return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
            return self.remarkList.count + 1;
        case 5:
            return self.orderStepList.count;
        default:
            return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
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
            return @"备注";
        case 5:
            return @"订单进度";
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return kArrayIsEmpty(self.premiumList)? 0: 40;
        }
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            return 40;
        default:
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

#pragma mark - config cell

-(void)configCell:(OrderInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.infoTitle = self.baseInfoList[indexPath.row];
    cell.infoValue = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.infoDetail = @"普通";
}

-(void)configPremiumCell:(OrderPremiumCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
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
    if (!_premiumList) {
        _premiumList = @[];
    }
    return _premiumList;
}

-(NSArray *)baseInfoList{
    if (!_baseInfoList) {
        _baseInfoList = @[@"订单号",@"下单时间",@"出发时间",@"订单状态",@"订单金额",@"物流",@"物流区间",@"运输方式",@"宠物数量",@"宠物重量",@"宠物种类",@"宠物品种",@"客户备注"];
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
        _senderAndReceiverList = @[@"寄件人",@"收件人",@"临派"];
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
