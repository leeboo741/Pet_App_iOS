//
//  BalanceFlowController.m
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "BalanceFlowController.h"

@interface BalanceFlowModel : NSObject
@property (nonatomic, copy) NSString * linkNo;
@property (nonatomic, copy) NSString * flowAmount;
@property (nonatomic, copy) NSString * afterBalanceAmount;
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * flowTime;
@end

@implementation BalanceFlowModel
@end

#import "BalanceFlowCell.h"

static NSString * BalanceFlowCellIdentifier = @"BalanceFlowCell";

@interface BalanceFlowController ()
@property (nonatomic, strong) NSMutableArray <BalanceFlowModel *> * dataSource;
@end

@implementation BalanceFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"余额流水";
    [self.tableView registerNib:[UINib nibWithNibName:BalanceFlowCellIdentifier bundle:nil] forCellReuseIdentifier:BalanceFlowCellIdentifier];
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
        [_dataSource addObject:[self getModelWithLinkNo:@"e321c4dsas99832as2de12ddessa" type:@"订单补价" flowAmount:@"123" afterAmount:@"222" time:@"2019-11-12 12:21:22"]];
        [_dataSource addObject:[self getModelWithLinkNo:@"e321c4dsas99832as2de12ddessa" type:@"订单补价" flowAmount:@"-23" afterAmount:@"321" time:@"2019-11-12 12:21:22"]];
        [_dataSource addObject:[self getModelWithLinkNo:@"e321c4dsas99832as2de12ddessa" type:@"订单补价" flowAmount:@"1134" afterAmount:@"23121" time:@"2019-11-12 12:21:22"]];
    }
    return  _dataSource;
}

-(BalanceFlowModel *)getModelWithLinkNo:(NSString *)linkNo type:(NSString *)type flowAmount:(NSString *)flowAmount afterAmount:(NSString *)afterAmount time:(NSString *)time{
    
    BalanceFlowModel * model1 = [[BalanceFlowModel alloc]init];
    model1.linkNo = linkNo;
    model1.flowType = type;
    model1.flowAmount =flowAmount;
    model1.afterBalanceAmount = afterAmount;
    model1.flowTime = time;
    return model1;
}

@end
