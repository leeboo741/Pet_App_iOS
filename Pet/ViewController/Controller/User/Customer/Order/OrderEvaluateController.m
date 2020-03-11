//
//  OrderEvaluateController.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderEvaluateController.h"
#import "OrderEvaluateStarCell.h"
#import "OrderEvaluateInputCell.h"
#import "BottomButtonCell.h"
#import "CustomerOrderManager.h"

static NSString * OrderEvaluateStarCellIdentifier = @"OrderEvaluateStarCell";
static NSString * OrderEvaluateInputCellIdentifier = @"OrderEvaluateInputCell";
static NSString * BottomButtonCellIdentifier = @"BottomButtonCell";

@interface OrderEvaluateController ()<OrderEvaluateStarCellDelegate,OrderEvaluateInputCellDelegte>
@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, copy) NSString * evaluateContent;
@end

@implementation OrderEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评价订单";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:OrderEvaluateStarCellIdentifier bundle:nil] forCellReuseIdentifier:OrderEvaluateStarCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderEvaluateInputCellIdentifier bundle:nil] forCellReuseIdentifier:OrderEvaluateInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:BottomButtonCellIdentifier bundle:nil] forCellReuseIdentifier:BottomButtonCellIdentifier];
    self.starLevel = 5;
}

#pragma mark - tableview datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OrderEvaluateInputCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderEvaluateInputCellIdentifier forIndexPath:indexPath];
        [self configInputCell:cell atIndexPath:indexPath];
        return cell;
    } else if(indexPath.section == 1) {
        OrderEvaluateStarCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderEvaluateStarCellIdentifier forIndexPath:indexPath];
        [self configStarCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        BottomButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:BottomButtonCellIdentifier forIndexPath:indexPath];
        [cell addTarget:self action:@selector(tapBottomButton) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:OrderEvaluateInputCellIdentifier configuration:^(id cell) {
            [self configInputCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:OrderEvaluateStarCellIdentifier configuration:^(id cell) {
            [self configStarCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:BottomButtonCellIdentifier configuration:^(id cell) {
            
        }];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"评价内容";
    } else if (section == 1) {
        return @"星级评价";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 5;
    }
    return 40;
}

#pragma mark - star cell delegate

-(void)tapStarAtOrderEvaluateStarCell:(OrderEvaluateStarCell *)cell withLevel:(NSInteger)level{
    self.starLevel = level;
}

#pragma mark - input cell delegate

-(void)inputText:(NSString *)text atOrderEvaluateInputCell:(OrderEvaluateInputCell *)cell{
    self.evaluateContent = text;
}

#pragma mark - bottom button

-(void)tapBottomButton{
    MSLog(@"%@, %ld", self.evaluateContent, self.starLevel);
    OrderEvaluate * evaluate = [[OrderEvaluate alloc]init];
    evaluate.content = self.evaluateContent;
    evaluate.star = self.starLevel;
    evaluate.evaluator = [[UserManager shareUserManager] getPhone];
    evaluate.order = self.orderEntity;
    __weak typeof(self) weakSelf = self;
    [[CustomerOrderManager shareCustomerOrderManager] evaluateOrder:evaluate success:^(id  _Nonnull data) {
        if ([data intValue]) {
            [AlertControllerTools showAlertWithTitle:@"评价成功" msg:nil items:@[@"确定"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [MBProgressHUD showErrorMessage:@"评价失败"];
        }
    } fail:^(NSInteger code) {
        
    }];
}

#pragma mark - config cell

-(void)configStarCell:(OrderEvaluateStarCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.starLevel = self.starLevel;
}

-(void)configInputCell:(OrderEvaluateInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}

@end
