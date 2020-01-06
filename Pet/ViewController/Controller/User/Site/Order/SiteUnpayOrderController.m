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

static NSString * SiteUnpayOrderCellIdentifier = @"SiteUnpayOrderCell";

@interface SiteUnpayOrderController () <SiteUnpayOrderCellDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITextField * changePriceTextField; // 改价输入框
@end

@implementation SiteUnpayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未支付订单";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:SiteUnpayOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteUnpayOrderCellIdentifier];
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
    if(type == OrderOperateButtonType_ChangePrice) {
        MSLog(@"改价 : %ld", indexPath.row);
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"改价" message:@"修改订单价格" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入新的订单价格";
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * newPirceTextField = alertController.textFields.firstObject;
            if (kStringIsEmpty(newPirceTextField.text)) {
                [MBProgressHUD showTipMessageInWindow:@"改价金额不能为空"];
            } else {
                MSLog(@"修改价格为:%@",newPirceTextField.text);
            }
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (type == OrderOperateButtonType_DetailOrder) {
        MSLog(@"详情 : %ld", indexPath.row);
    }
}

#pragma mark - setters and getters

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        OrderEntity * orderEntity = [[OrderEntity alloc]init];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
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
