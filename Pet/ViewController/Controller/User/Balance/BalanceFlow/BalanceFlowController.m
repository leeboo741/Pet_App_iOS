//
//  BalanceFlowController.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "BalanceFlowController.h"
#import "SiteBalanceManager.h"
#import "BusinessBalanceManager.h"
#import "UITableViewController+AddMJRefresh.h"

@interface BalanceFlowModel : NSObject
@property (nonatomic, copy) NSString * linkNo;
@property (nonatomic, copy) NSString * flowAmount;
@property (nonatomic, copy) NSString * afterBalanceAmount;
@property (nonatomic, copy) NSString * flowTypeCode;
@property (nonatomic, copy, readonly) NSString * flowType;
@property (nonatomic, copy) NSString * flowTime;
+(BalanceFlowModel *)getModelBySiteRebateFlow:(SiteRebateFlow *)siteRebateFlow;
+(NSArray<BalanceFlowModel *> *)getModelListBySiteRebateFlowList:(NSArray<SiteRebateFlow *> *)siteRebateFlowList;
+(BalanceFlowModel *)getModelByBusinessRebateFlow:(BusinessRebate *)businessRebate;
+(NSArray<BalanceFlowModel *> *)getModelListByBusinessRebateList:(NSArray<BusinessRebate *> *)BusinessRebateList;
@end

@implementation BalanceFlowModel
-(NSString *)flowType{
    if (self.flowTypeCode) {
        if ([self.flowTypeCode isEqualToString:@"orderStation"]) {
            return @"订单所得";
        } else if ([self.flowTypeCode isEqualToString:@"orderRebate"]) {
            return @"分享客户下单返利";
        } else if ([self.flowTypeCode isEqualToString:@"withdrawConfirm"]) {
            return @"提现发起";
        } else if ([self.flowTypeCode isEqualToString:@"withdrawReject"]) {
            return @"提现驳回";
        } else if ([self.flowTypeCode isEqualToString:@"orderRefund"]) {
            return @"订单退款";
        } else if ([self.flowTypeCode isEqualToString:@"recharge"]) {
            return @"余额充值";
        } else if ([self.flowTypeCode isEqualToString:@"orderPremium"]) {
            return @"订单补价";
        } else if ([self.flowTypeCode isEqualToString:@"orderInsure"]) {
            return @"保险花费";
        } else {
            return @"其他";
        }
    } else {
        return @"其他";
    }
}
+(BalanceFlowModel *)getModelByBusinessRebateFlow:(BusinessRebate *)businessRebate{
    BalanceFlowModel * model = [[BalanceFlowModel alloc]init];
    model.linkNo = businessRebate.linkNo;
    model.flowAmount = [NSString stringWithFormat:@"%.2f",businessRebate.flowAmount];
    model.afterBalanceAmount = [NSString stringWithFormat:@"%.2f",businessRebate.balance];
    model.flowTime = businessRebate.dateTime;
    model.flowTypeCode = businessRebate.flowType;
    return model;
}
+(NSArray<BalanceFlowModel *> *)getModelListByBusinessRebateList:(NSArray<BusinessRebate *> *)BusinessRebateList{
    NSMutableArray * array = [NSMutableArray array];
    for (BusinessRebate * rebateFlow in BusinessRebateList) {
        [array addObject:[BalanceFlowModel getModelByBusinessRebateFlow:rebateFlow]];
    }
    return array;
}
+(BalanceFlowModel *)getModelBySiteRebateFlow:(SiteRebateFlow *)siteRebateFlow{
    BalanceFlowModel * model = [[BalanceFlowModel alloc]init];
    model.linkNo = siteRebateFlow.linkNo;
    model.flowAmount = [NSString stringWithFormat:@"%.2f",siteRebateFlow.flowAmount];
    model.afterBalanceAmount = [NSString stringWithFormat:@"%.2f",siteRebateFlow.balance];
    model.flowTime = siteRebateFlow.dateTime;
    model.flowTypeCode = siteRebateFlow.flowType;
    return model;
}
+(NSArray<BalanceFlowModel *> *)getModelListBySiteRebateFlowList:(NSArray<SiteRebateFlow *> *)siteRebateFlowList{
    NSMutableArray * array = [NSMutableArray array];
    for (SiteRebateFlow * rebateFlow in siteRebateFlowList) {
        [array addObject:[BalanceFlowModel getModelBySiteRebateFlow:rebateFlow]];
    }
    return array;
}
@end

#import "BalanceFlowCell.h"

static NSString * BalanceFlowCellIdentifier = @"BalanceFlowCell";

static NSInteger Limit = 30;

@interface BalanceFlowController ()
@property (nonatomic, strong) NSMutableArray <BalanceFlowModel *> * dataSource;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation BalanceFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额流水";
    [self.tableView registerNib:[UINib nibWithNibName:BalanceFlowCellIdentifier bundle:nil] forCellReuseIdentifier:BalanceFlowCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction)];
    [self startRefresh];
}

#pragma mark - private method
-(void)refreshAction{
    self.offset = 0;
    __weak typeof(self) weakSelf = self;
    [self getDataWithOffset:self.offset success:^(id  _Nonnull data) {
        [weakSelf.dataSource removeAllObjects];
        NSArray * array = (NSArray *)data;
        [weakSelf.dataSource addObjectsFromArray:array];
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}

-(void)loadMoreAction{
    __weak typeof(self) weakSelf = self;
    [self getDataWithOffset:self.offset success:^(id  _Nonnull data) {
        NSArray * dataArray =  (NSArray *)data;
        if (dataArray.count < Limit) {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf.dataSource addObjectsFromArray:dataArray];
        [weakSelf.tableView reloadData];
        [weakSelf endLoadMore];
    } fail:^(NSInteger code) {
        [weakSelf endLoadMore];
    }];
}

-(void)getDataWithOffset:(NSInteger)offset success:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    if ([[UserManager  shareUserManager] getCurrentUserRole ] == CURRENT_USER_ROLE_STAFF) {
        [[SiteBalanceManager shareSiteBalanceManager] getRebateFlowWithStationNo:[[UserManager shareUserManager] getStationNo] offset:offset limit:Limit success:^(id  _Nonnull data) {
            weakSelf.offset = weakSelf.offset + Limit;
            NSArray * array = [BalanceFlowModel getModelListBySiteRebateFlowList:(NSArray *)data];
            if (success) {
                success(array);
            }
        } fail:^(NSInteger code) {
            if (fail) {
                fail(code);
            }
        }];
    } else if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_BUSINESS) {
        [[BusinessBalanceManager shareBusinessBalanceManager] getRebateFlowWithBusinessNo:[[UserManager shareUserManager] getBusinessNo] offset:offset limit:Limit success:^(id  _Nonnull data) {
            weakSelf.offset = weakSelf.offset + Limit;
            NSArray * array = [BalanceFlowModel getModelListByBusinessRebateList:(NSArray *)data];
            if (success) {
                success(array);
            }
        } fail:^(NSInteger code) {
            if (fail) {
                fail(code);
            }
        }];
    }
}

#pragma mark - taleview delegate and datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BalanceFlowCell * cell = [tableView dequeueReusableCellWithIdentifier:BalanceFlowCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:BalanceFlowCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BalanceFlowModel * model = self.dataSource[indexPath.row];
    MSLog(@"点击流水 %@ ", model.linkNo);
}

#pragma mark - config cell
-(void)configCell:(BalanceFlowCell * )cell atIndexPath:(NSIndexPath *)indexPath {
    BalanceFlowModel * model = self.dataSource[indexPath.row];
    cell.linkNo = model.linkNo;
    cell.flowTime = model.flowTime;
    cell.flowType = model.flowType;
    cell.flowAmount = model.flowAmount;
    cell.afterBalanceAmount = model.afterBalanceAmount;
}

#pragma mark - setters and getters
-(NSMutableArray<BalanceFlowModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return  _dataSource;
}

@end
