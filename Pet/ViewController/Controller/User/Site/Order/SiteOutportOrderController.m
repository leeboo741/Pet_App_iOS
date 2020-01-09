//
//  SiteOutportController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteOutportOrderController.h"
#import "OrderEntity.h"
#import "SiteOutportOrderCell.h"
#import "AssignmentsController.h"
#import "OrderDetailController.h"

static NSString * SiteOutportOrderCellIdentifier = @"SiteOutportOrderCell";

@interface SiteOutportOrderController () <SiteOutportOrderCellDelegate>
@property (nonatomic, strong)NSMutableArray<OrderEntity *> * dataSource;
@end

@implementation SiteOutportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待出港单";
    [self.tableView registerNib:[UINib nibWithNibName:SiteOutportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteOutportOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteOutportOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteOutportOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteOutportOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteOutportOrderCellIdentifier configuration:^(id cell) {
        [self configSiteOutportOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - config cell
-(void)configSiteOutportOrderCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.selectImageDataList = orderEntity.waitUploadMediaList;
    cell.orderEntity = orderEntity;
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteOutportOrderCell:(SiteOutportOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MSLog(@"点击 index : %ld || type : %ld", indexPath.row, type);
    switch (type) {
        case OrderOperateButtonType_Remark:
        {
            MSLog(@"备注");
            [self showRemarkInputViewWithCell:cell atIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_AddPrice:
        {
            MSLog(@"补价");
            [self showAddPriceInputViewWithCell:cell atIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_Refund:
        {
            MSLog(@"退款");
            [self showRefundInputViewWithCell:cell atIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_Print:
            MSLog(@"打印");
            break;
        case OrderOperateButtonType_DetailOrder:
        {
            MSLog(@"订单详情");
            OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
            [self presentViewController:orderDetailVC animated:YES completion:nil];
        }
            break;
        case OrderOperateButtonType_Assignment:
        {
            MSLog(@"分配订单");
            AssignmentsController * assignmentsController = [[AssignmentsController alloc]init];
            __weak typeof(self) weakSelf = self;
            assignmentsController.returnBlock = ^(NSArray<StaffEntity *> * _Nonnull assignmentedArray) {
                OrderEntity * orderEntity = weakSelf.dataSource[indexPath.row];
                orderEntity.assignmentedStaffArray = assignmentedArray;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:assignmentsController animated:YES];
        }
            break;
        case OrderOperateButtonType_Upload:
            MSLog(@"上传");
            break;
        case OrderOperateButtonType_Package:
            MSLog(@"揽件");
            break;
        case OrderOperateButtonType_OutInPort:
            MSLog(@"出入港");
            break;
        default:
        {
            [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"错误按钮类型:%ld",type]];
        }
            break;
    }
}

-(void)siteOutportOrderCell:(SiteOutportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    orderEntity.waitUploadMediaList = selectImageData;
    cell.orderEntity = orderEntity;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - setters and getters

-(NSMutableArray<OrderEntity *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        OrderEntity * orderEntity = [[OrderEntity alloc]init];
        orderEntity.orderNo = @"123123123";
        [_dataSource addObject:orderEntity];
        
        OrderEntity * orderEntity1 = [[OrderEntity alloc]init];
        orderEntity1.orderNo = @"234234234";
        [_dataSource addObject:orderEntity1];
        
        OrderEntity * orderEntity2 = [[OrderEntity alloc]init];
        orderEntity2.orderNo = @"345345345";
        [_dataSource addObject:orderEntity2];
        
        OrderEntity * orderEntity3 = [[OrderEntity alloc]init];
        orderEntity3.orderNo = @"456456456";
        [_dataSource addObject:orderEntity3];
        
        OrderEntity * orderEntity4 = [[OrderEntity alloc]init];
        orderEntity4.orderNo = @"567567567";
        [_dataSource addObject:orderEntity4];
    }
    return _dataSource;
}

#pragma mark - private method

// 备注弹窗
-(void)showRemarkInputViewWithCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderEntity * orderEntity  = self.dataSource[indexPath.row];
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
        
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 补价弹窗
-(void)showAddPriceInputViewWithCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderEntity * orderEntity  = self.dataSource[indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新增补价" message:orderEntity.orderNo preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入补价金额";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入补价原因";
    }];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * addPriceTextField = alertController.textFields.firstObject;
        UITextField * reasonTextField = alertController.textFields[1];
        if (kStringIsEmpty(addPriceTextField.text)) {
            [MBProgressHUD showTipMessageInWindow:@"补价金额不能为空"];
            return;
        }
        if (kStringIsEmpty(reasonTextField.text)) {
            [MBProgressHUD showTipMessageInWindow:@"补价原因不能为空"];
            return;
        }
        MSLog(@"第 %ld 行 添加补价信息\n 金额: %@ \n 原因: %@",indexPath.row, addPriceTextField.text, reasonTextField.text);
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 退款弹窗
-(void)showRefundInputViewWithCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderEntity * orderEntity  = self.dataSource[indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"申请退款" message:orderEntity.orderNo preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入扣减服务费用";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入退款原因";
    }];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * serviceAmountTextField = alertController.textFields.firstObject;
        UITextField * reasonTextField = alertController.textFields[1];
        if (kStringIsEmpty(serviceAmountTextField.text)) {
            serviceAmountTextField.text = @"0";
        }
        if (kStringIsEmpty(reasonTextField.text)) {
            [MBProgressHUD showTipMessageInWindow:@"退款原因不能为空"];
            return;
        }
        MSLog(@"第 %ld 行 添加退款信息\n 金额: %@ \n 原因: %@",indexPath.row, serviceAmountTextField.text, reasonTextField.text);
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
