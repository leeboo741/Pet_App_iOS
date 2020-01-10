//
//  SiteInportController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteInportOrderController.h"
#import "OrderEntity.h"
#import "SiteInportOrderCell.h"
#import "OrderDetailController.h"
#import "AssignmentsController.h"

static NSString * SiteInportOrderCellIdentifier = @"SiteInportOrderCell";

@interface SiteInportOrderController ()<SiteInportOrderCellDelegate>
@property (nonatomic, strong)NSMutableArray * dataSource;
@end

@implementation SiteInportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待签收单";
    [self.tableView registerNib:[UINib nibWithNibName:SiteInportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteInportOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteInportOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteInportOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteInportOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteInportOrderCellIdentifier configuration:^(id cell) {
        [self configSiteInportOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - config cell
-(void)configSiteInportOrderCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.selectImageDataList = orderEntity.waitUploadMediaList;
}

#pragma mark - site inport order cell delegate

-(void)tapSiteInportOrderCell:(SiteInportOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MSLog(@"点击 index : %ld || type : %ld", indexPath.row, type);
    switch (type) {
        case OrderOperateButtonType_Remark:
        {
            MSLog(@"备注");
            [self showRemarkInputViewWithCell:cell atIndexPath:indexPath];
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
        case OrderOperateButtonType_AddPrice:
        {
            MSLog(@"补价");
            [self showAddPriceInputViewWithCell:cell atIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_DetailOrder:
        {
            MSLog(@"订单详情");
            OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
            break;
        case OrderOperateButtonType_Print:
        {
            MSLog(@"打印");
        }
            break;
        case OrderOperateButtonType_Upload:
        {
            MSLog(@"上传");
        }
            break;
        case OrderOperateButtonType_Arrived:
        {
            MSLog(@"到达");
        }
            break;
        case OrderOperateButtonType_SignIn:
        {
            MSLog(@"签收");
        }
            break;
        case OrderOperateButtonType_TempDeliver:
        {
            MSLog(@"临派");
        }
            break;
            
        default:
            break;
    }
}

-(void)siteInportOrderCell:(SiteInportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    orderEntity.waitUploadMediaList = selectImageData;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - private method

// 备注弹窗
-(void)showRemarkInputViewWithCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
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
-(void)showAddPriceInputViewWithCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
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

@end
