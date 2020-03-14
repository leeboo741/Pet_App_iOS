//
//  SiteUnpayOrderController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteUnpayOrderController.h"
#import "SiteUnpayOrderCell.h"
#import "OrderEntity.h"
#import "OrderDetailController.h"
#import "SiteOrderManager.h"
#import "UITableViewController+AddMJRefresh.h"

static NSString * SiteUnpayOrderCellIdentifier = @"SiteUnpayOrderCell";

static NSInteger Limit = 10;

@interface SiteUnpayOrderController () <SiteUnpayOrderCellDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITextField * changePriceTextField; // 改价输入框

@property (nonatomic, assign) NSInteger offset;
@end

@implementation SiteUnpayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未支付订单";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:SiteUnpayOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteUnpayOrderCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction)];
    [self startRefresh];
}

#pragma mark - private method
-(void)refreshAction{
    self.offset = 0;
    __weak typeof(self) weakSelf = self;
    [self getOrderDataWithOffset:self.offset success:^(id  _Nonnull data) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:(NSArray *)data];
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}
-(void)loadMoreAction{
    __weak typeof(self) weakSelf = self;
    [self getOrderDataWithOffset:self.offset success:^(id  _Nonnull data) {
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
-(void)getOrderDataWithOffset:(NSInteger)offset success:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    [[SiteOrderManager shareSiteOrderManager] getSiteAllOrderByState:SiteOrderState_ToPay offset:offset limit:Limit success:^(id  _Nonnull data) {
        weakSelf.offset = weakSelf.offset + Limit;
        if (success) {
            success(data);
        }
    } fail:^(NSInteger code) {
        if (fail) {
            fail(code);
        }
    }];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteUnpayOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteUnpayOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteUnpayOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteUnpayOrderCellIdentifier configuration:^(id cell) {
        [self configSiteUnpayOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - config cell
-(void)configSiteUnpayOrderCell:(SiteUnpayOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.orderEntity = self.dataSource[indexPath.row];
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteUnpayOrderCell:(SiteUnpayOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if(type == OrderOperateButtonType_ChangePrice) {
        MSLog(@"改价 : %ld", indexPath.row);
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"改价" message:@"修改订单价格" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入新的订单价格";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.delegate = self;
        }];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * newPirceTextField = alertController.textFields.firstObject;
            if (kStringIsEmpty(newPirceTextField.text)) {
                [MBProgressHUD showTipMessageInWindow:@"改价金额不能为空"];
            } else {
                MSLog(@"修改价格为:%@",newPirceTextField.text);
                NSString * oldPrice = orderEntity.orderAmount;
                orderEntity.orderAmount = newPirceTextField.text;
                [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
                [[SiteOrderManager shareSiteOrderManager] updateOrderPrice:orderEntity success:^(id  _Nonnull data) {
                    [MBProgressHUD hideHUD];
                    if ([data intValue] == 1) {
                        [weakSelf.tableView reloadData];
                    } else {
                        orderEntity.orderAmount = oldPrice;
                    }
                } fail:^(NSInteger code) {
                    orderEntity.orderAmount = oldPrice;
                }];
            }
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (type == OrderOperateButtonType_DetailOrder) {
        MSLog(@"订单详情 : %ld", indexPath.row);
        OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
        orderDetailVC.orderNo = orderEntity.orderNo;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    } else if (type == OrderOperateButtonType_Remark) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加备注" message:orderEntity.orderNo preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入备注信息";
        }];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * remarkTextField = alertController.textFields.firstObject;
            if (kStringIsEmpty(remarkTextField.text)) {
                [MBProgressHUD showTipMessageInWindow:@"备注信息不能为空"];
                return;
            }
            MSLog(@"第 %ld 行数据 输入备注信息: %@",indexPath.row, remarkTextField.text);
            OrderRemarks * remarks = [[OrderRemarks alloc]init];
            OrderEntity * remarkOrder = [[OrderEntity alloc] init];
            remarkOrder.orderNo = orderEntity.orderNo;
            remarks.order = remarkOrder;
            remarks.remarks = remarkTextField.text;
            remarks.staff = [[UserManager shareUserManager] getStaff];
            remarks.station = [[UserManager shareUserManager] getStation];
            [[SiteOrderManager shareSiteOrderManager] addOrderRemark:remarks success:^(id  _Nonnull data) {
                if ([data intValue] == 1) {
                    NSMutableArray * array = [NSMutableArray arrayWithArray:orderEntity.orderRemarksList];
                    [array addObject:remarks];
                    orderEntity.orderRemarksList = array;
                    [weakSelf.tableView reloadData];
                } else {
                    [MBProgressHUD showErrorMessage:@"添加备注失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (!Util_IsNumberString(text)) {
        return NO;
    }
    return YES;
}

#pragma mark - setters and getters

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITextField *)changePriceTextField{
    if (!_changePriceTextField) {
        _changePriceTextField = [[UITextField alloc]init];
        _changePriceTextField.delegate = self;
        _changePriceTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _changePriceTextField;
}

@end
