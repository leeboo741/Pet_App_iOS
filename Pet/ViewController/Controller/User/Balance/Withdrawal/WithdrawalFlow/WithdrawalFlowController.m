//
//  WithdrawalFlowController.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "WithdrawalFlowController.h"
#import "WithdrawalFlowCell.h"

@interface WithdrawalFlowModel : NSObject
@property (nonatomic, copy) NSString * flowNo;
@property (nonatomic, copy) NSString * flowAmount;
@property (nonatomic, copy) NSString * flowTime;
@property (nonatomic, copy) NSString * flowState;
@end

@implementation WithdrawalFlowModel
@end

static NSString * WithdrawalFlowCellIdentifier = @"WithdrawalFlowCell";

@interface WithdrawalFlowController ()
@property (nonatomic, strong) NSMutableArray<WithdrawalFlowModel *> *dataSource;
@end

@implementation WithdrawalFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现流水";
    [self.tableView registerNib:[UINib nibWithNibName:WithdrawalFlowCellIdentifier bundle:nil] forCellReuseIdentifier:WithdrawalFlowCellIdentifier];
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
