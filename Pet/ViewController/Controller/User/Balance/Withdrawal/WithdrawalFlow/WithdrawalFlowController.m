//
//  WithdrawalFlowController.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "WithdrawalFlowController.h"
#import "WithdrawalFlowCell.h"
#import "SiteBalanceManager.h"
#import "BusinessBalanceManager.h"
#import "UITableViewController+AddMJRefresh.h"

@interface WithdrawalFlowModel : NSObject
@property (nonatomic, copy) NSString * flowNo;
@property (nonatomic, copy) NSString * flowAmount;
@property (nonatomic, copy) NSString * flowTime;
@property (nonatomic, copy) NSString * flowState;
+(WithdrawalFlowModel *)getModelBySiteWithdrawModel:(SiteWithdrawFlow *)flow;
+(NSArray<WithdrawalFlowModel *> *)getModelListBySiteWithdrawModelList:(NSArray<SiteWithdrawFlow *>*)flowList;
+(WithdrawalFlowModel *)getModelByBusinessWithdrawModel:(BusinessWithdrawFlow *)flow;
+(NSArray<WithdrawalFlowModel *> *)getModelListByBusinessWithdrawModelList:(NSArray<BusinessWithdrawFlow *>*)flowList;
@end

@implementation WithdrawalFlowModel
+(WithdrawalFlowModel *)getModelBySiteWithdrawModel:(SiteWithdrawFlow *)flow{
    WithdrawalFlowModel * model = [[WithdrawalFlowModel alloc]init];
    model.flowAmount = [NSString stringWithFormat:@"%.2f",flow.amount];
    model.flowNo = flow.withdrawNo;
    model.flowState = flow.state;
    model.flowTime = flow.withdrawTime;
    return model;
}
+(NSArray<WithdrawalFlowModel *> *)getModelListBySiteWithdrawModelList:(NSArray<SiteWithdrawFlow *>*)flowList{
    NSMutableArray * array = [NSMutableArray array];
    for (SiteWithdrawFlow * flow in flowList) {
        [array addObject:[WithdrawalFlowModel getModelBySiteWithdrawModel:flow]];
    }
    return array;
}
+(WithdrawalFlowModel *)getModelByBusinessWithdrawModel:(BusinessWithdrawFlow *)flow{
    WithdrawalFlowModel * model = [[WithdrawalFlowModel alloc]init];
    model.flowAmount = [NSString stringWithFormat:@"%.2f",flow.amount];
    model.flowNo = flow.withdrawNo;
    model.flowState = flow.state;
    model.flowTime = flow.withdrawTime;
    return model;
}
+(NSArray<WithdrawalFlowModel *> *)getModelListByBusinessWithdrawModelList:(NSArray<BusinessWithdrawFlow *>*)flowList{
    NSMutableArray * array = [NSMutableArray array];
    for (BusinessWithdrawFlow * flow in flowList) {
        [array addObject:[WithdrawalFlowModel getModelByBusinessWithdrawModel:flow]];
    }
    return array;
}
@end

static NSString * WithdrawalFlowCellIdentifier = @"WithdrawalFlowCell";

static NSInteger Limit = 30;

@interface WithdrawalFlowController ()
@property (nonatomic, strong) NSMutableArray<WithdrawalFlowModel *> *dataSource;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation WithdrawalFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现流水";
    [self.tableView registerNib:[UINib nibWithNibName:WithdrawalFlowCellIdentifier bundle:nil] forCellReuseIdentifier:WithdrawalFlowCellIdentifier];
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
    } fail:^(NSInteger code) {
        [weakSelf endLoadMore];
    }];
}

-(void)getDataWithOffset:(NSInteger)offset success:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_STAFF) {
        [[SiteBalanceManager shareSiteBalanceManager] getWithdrawFlowWithStationNo:[[UserManager shareUserManager] getStationNo] offset:offset limit:Limit success:^(id  _Nonnull data) {
            weakSelf.offset = weakSelf.offset + Limit;
            NSArray * array = [WithdrawalFlowModel getModelListBySiteWithdrawModelList:(NSArray *)data];
            if (success) {
                success(array);
            }
        } fail:^(NSInteger code) {
            if (fail) {
                fail(code);
            }
        }];
    } else if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_BUSINESS) {
        [[BusinessBalanceManager shareBusinessBalanceManager] getWithdrawFlowWithBusinessNo:[[UserManager shareUserManager] getBusinessNo] offset:offset limit:Limit success:^(id  _Nonnull data) {
            weakSelf.offset = weakSelf.offset + Limit;
            NSArray * array = [WithdrawalFlowModel getModelListByBusinessWithdrawModelList:(NSArray *)data];
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
    WithdrawalFlowCell * cell = [tableView dequeueReusableCellWithIdentifier:WithdrawalFlowCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:WithdrawalFlowCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WithdrawalFlowModel * model = self.dataSource[indexPath.row];
    MSLog(@"点击流水 %@ ", model.flowNo);
}

#pragma mark - config cell
-(void)configCell:(WithdrawalFlowCell * )cell atIndexPath:(NSIndexPath *)indexPath {
    WithdrawalFlowModel * model = self.dataSource[indexPath.row];
    cell.amount = model.flowAmount;
    cell.time = model.flowTime;
    cell.state = model.flowState;
}


#pragma mark - setters and getters
-(NSMutableArray<WithdrawalFlowModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        WithdrawalFlowModel * model = [self getFlowModelWitmAmount:@"123" state:@"待审核" time:@"2019-11-11 10:12:11"];
        WithdrawalFlowModel * model1 = [self getFlowModelWitmAmount:@"231" state:@"已审核" time:@"2019-11-10 12:21:11"];
        WithdrawalFlowModel * model2 = [self getFlowModelWitmAmount:@"432" state:@"已驳回" time:@"2020-01-02 13:12:11"];
        [_dataSource addObject:model];
        [_dataSource addObject:model1];
        [_dataSource addObject:model2];
    }
    return  _dataSource;
}

#pragma mark - private method
-(WithdrawalFlowModel *)getFlowModelWitmAmount:(NSString *)amount state:(NSString *)state time:(NSString*)time{
    WithdrawalFlowModel * model = [[WithdrawalFlowModel alloc]init];
    model.flowNo = amount;
    model.flowAmount = amount;
    model.flowTime = time;
    model.flowState = state;
    return model;
}
@end
