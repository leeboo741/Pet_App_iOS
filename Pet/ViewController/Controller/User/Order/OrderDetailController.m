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
@property (nonatomic, copy) NSString * orderStepName;
@property (nonatomic, copy) NSString * orderStepTime;
@property (nonatomic, strong) NSArray * orderStepMediaList;
@end

@implementation OrderStepModel
@end

#pragma mark - OrderDetailController
#pragma mark -

#import "OrderPremiumCell.h"
#import "OrderRemarkInputCell.h"

static NSString * TableViewCellIdentifier = @"UITableViewCell";
static NSString * OrderPremiumCellIdentifier = @"OrderPremiumCell";
static NSString * OrderRemarkInputCellIdentifier = @"OrderRemarkInputCell";

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderPremiumCellIdentifier bundle:nil] forCellReuseIdentifier:OrderPremiumCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderRemarkInputCellIdentifier bundle:nil] forCellReuseIdentifier:OrderRemarkInputCellIdentifier];
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
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 4) {
        // 备注
        if (indexPath.row == self.remarkList.count) {
            OrderRemarkInputCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderRemarkInputCellIdentifier forIndexPath:indexPath];
            [self configRemarkInputCell:cell atIndexPath:indexPath];
            return cell;
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
            [self configRemarkCell:cell atIndexPath:indexPath];
            return cell;
        }
    } else if (indexPath.section == 5) {
        // 订单进度
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
            return [tableView fd_heightForCellWithIdentifier:TableViewCellIdentifier configuration:^(id cell) {
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
                return [tableView fd_heightForCellWithIdentifier:TableViewCellIdentifier configuration:^(id cell) {
                    [self configRemarkCell:cell atIndexPath:indexPath];
                }];
            }
        }
        case 5:
            return 0;
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
            return 1;
        default:
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
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

-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)configPremiumCell:(OrderPremiumCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)configRemarkInputCell:(OrderRemarkInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)configRemarkCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
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
        _orderStepList = @[];
    }
    return _orderStepList;
}
@end
