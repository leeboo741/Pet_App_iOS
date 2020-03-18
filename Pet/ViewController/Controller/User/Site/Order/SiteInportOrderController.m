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
#import "SiteOrderManager.h"
#import "UITableViewController+AddMJRefresh.h"
#import "InOrOutPortFilterController.h"
#import "DateUtils.h"
#import "CGXPickerView.h"
#import "SelectLocationMapController.h"
#import "AddTempDeliverController.h"

static NSString * SiteInportOrderCellIdentifier = @"SiteInportOrderCell";

typedef NS_ENUM(NSInteger, SiteIn_TextField_Tag) {
    SiteIn_TextField_Tag_Search = 999,
};

@interface SiteInportOrderController ()<SiteInportOrderCellDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * actionSearchView;
@property (nonatomic, strong) UITextField * actionSearchTextfield;
@property (nonatomic, strong) InOrOutPortRequestParam * param;

@end

@implementation SiteInportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待签收单";
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:@"更多筛选" forState:UIControlStateNormal];
    [button setTitleColor:Color_blue_1 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self.tableView registerNib:[UINib nibWithNibName:SiteInportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteInportOrderCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self startRefresh];
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
    return self.actionSearchView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - config cell
-(void)configSiteInportOrderCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.orderEntity = orderEntity;
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
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            assignmentsController.orderNo = orderEntity.orderNo;
            assignmentsController.selectStaffArray = orderEntity.assignmentedStaffArray;
            __weak typeof(self) weakSelf = self;
            assignmentsController.returnBlock = ^(NSArray<StaffEntity *> * _Nonnull assignmentedArray) {
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
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            orderDetailVC.orderNo = orderEntity.orderNo;
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
            __weak typeof(self) weakSelf = self;
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            [MBProgressHUD showActivityMessageInWindow:@"上传文件中,请稍等..."];
            [[SiteOrderManager shareSiteOrderManager] uploadMediaFilesWithOrderNo:orderEntity.orderNo mediaUrlPathList:orderEntity.waitUploadMediaList success:^(id  _Nonnull data) {
                [MBProgressHUD hideHUD];
                orderEntity.waitCommitMediaList = (NSArray *)data;
                orderEntity.waitUploadMediaList = @[];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSInteger code) {
                
            }];
        }
            break;
        case OrderOperateButtonType_Arrived:
        {
            MSLog(@"到达");
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            NSArray * fileList = [[SiteOrderManager shareSiteOrderManager] getCommitFileListFromWaitCommitMediaList:orderEntity.waitCommitMediaList];
            OrderStatus * status = [orderEntity.orderStates firstObject];
            __weak typeof(self) weakSelf = self;
            [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
            [[SiteOrderManager shareSiteOrderManager] inOrOutPortWithOrderNo:orderEntity.orderNo sn:status.sn orderType:status.orderType fileList:fileList success:^(id  _Nonnull data) {
                [MBProgressHUD hideHUD];
                if ([data intValue] > 0) {
                    [weakSelf startRefresh];
                } else {
                    [MBProgressHUD showTipMessageInWindow:@"入港失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }
            break;
        case OrderOperateButtonType_SignIn:
        {
            MSLog(@"签收");
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [[SiteOrderManager  shareSiteOrderManager] getUnpayPremiumCountWithOrderNo:orderEntity.orderNo success:^(id  _Nonnull data) {
                if ([data intValue] > 0) {
                    [AlertControllerTools showAlertWithTitle:@"订单还有未支付补价单" msg:@"完成补价后再执行该操作" items:@[@"确定"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                        
                    }];
                } else {
                    [AlertControllerTools showAlertWithTitle:@"确认签收订单" msg:orderEntity.orderNo items:@[@"确定"] showCancel:YES actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                        NSArray * fileList = [[SiteOrderManager shareSiteOrderManager] getCommitFileListFromWaitCommitMediaList:orderEntity.waitCommitMediaList];
                        [[SiteOrderManager shareSiteOrderManager] confirmOrderByOrderNo:orderEntity.orderNo fileList:fileList success:^(id  _Nonnull data) {
                            if ([data intValue] > 0) {
                                [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                                [weakSelf.tableView reloadData];
                            } else {
                                [MBProgressHUD showErrorMessage:@"签收失败"];
                            }
                        } fail:^(NSInteger code) {
                            
                        }];
                    }];
                }
            } fail:^(NSInteger code) {
                
            }];
        }
            break;
        case OrderOperateButtonType_TempDeliver:
        {
            MSLog(@"临派");
            [self showTempDeliverInputViewWithCell:cell atIndexPath:indexPath];
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
    cell.orderEntity = orderEntity;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == SiteIn_TextField_Tag_Search) {
        MSLog(@"点击确定搜索");
        self.param.orderNo = textField.text;
        [self startRefresh];
        return  YES;
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
-(UIView *)actionSearchView{
    if (!_actionSearchView) {
        _actionSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        _actionSearchView.backgroundColor = Color_white_1;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, _actionSearchView.frame.size.height * 0.1, _actionSearchView.frame.size.width - 30, _actionSearchView.frame.size.height * 0.8)];
        view.backgroundColor = kRGBColor(250, 250, 250);
        view.layer.cornerRadius = view.frame.size.height / 2;
        view.layer.masksToBounds = YES;
        [_actionSearchView addSubview:view];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, (view.frame.size.height - 28)/2, 28, 28)];
        imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Search, 28, Color_gray_2)];
        [view addSubview:imageView];
        
        _actionSearchTextfield = [[UITextField alloc]initWithFrame:CGRectMake(50, view.frame.size.height * 0.1, view.frame.size.width - 55, view.frame.size.height * 0.8)];
        _actionSearchTextfield.tag = SiteIn_TextField_Tag_Search;
        _actionSearchTextfield.delegate = self;
        _actionSearchTextfield.textColor = Color_gray_2;
        _actionSearchTextfield.returnKeyType = UIReturnKeySearch;
        _actionSearchTextfield.placeholder = @"查找订单";
        [view addSubview:_actionSearchTextfield];
        
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _actionSearchView.frame.size.height - 1, _actionSearchView.frame.size.width, 1)];
        view2.backgroundColor = kRGBColor(250, 250, 250);
        [_actionSearchView addSubview:view2];
    }
    return _actionSearchView;
}
-(InOrOutPortRequestParam *)param{
    if (!_param) {
        _param = [[InOrOutPortRequestParam alloc]init];
        NSArray * array = @[
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToArrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Arrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Delivering],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToSign],
        ];
        [_param.orderTypeArray addObjectsFromArray:array];
    }
    return _param;
}
#pragma mark - private method

-(void)moreFilter{
    InOrOutPortFilterController * inOrOutPortFilterController = [[InOrOutPortFilterController alloc]init];
    inOrOutPortFilterController.param = self.param;
    inOrOutPortFilterController.filterType = InOrOutPortFilter_Type_In;
    __weak typeof(self) weakSelf = self;
    inOrOutPortFilterController.returnBlock = ^(InOrOutPortRequestParam * _Nonnull param) {
        weakSelf.param = param;
        [weakSelf startRefresh];
    };
    [self.navigationController pushViewController:inOrOutPortFilterController animated:YES];
}

-(void)refreshAction{
    __weak typeof(self) weakSelf = self;
    [[SiteOrderManager shareSiteOrderManager] getInOrOutPortOrderWithParam:self.param success:^(id  _Nonnull data) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:(NSArray *)data];
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}

/**
 临派弹窗
 */
-(void)showTempDeliverInputViewWithCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    AddTempDeliverController * addTempDeliverController = [[AddTempDeliverController alloc]init];
    addTempDeliverController.order = orderEntity;
    __weak typeof(self) weakSelf = self;
    addTempDeliverController.successBlock = ^{
        OrderStatus * status = [orderEntity.orderStates firstObject];
        status.orderType = [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Delivering];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:addTempDeliverController animated:YES];
}

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
        OrderRemarks * orderRemark = [[OrderRemarks alloc]init];
        orderRemark.order = orderEntity;
        orderRemark.remarks = remarkTextField.text;
        orderRemark.staff = [[UserManager shareUserManager] getStaff];
        orderRemark.station = [[UserManager shareUserManager] getStation];
        
        MSLog(@"第 %ld 行数据 输入备注信息: %@",indexPath.row, remarkTextField.text);
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showActivityMessageInWindow:@"备注中..."];
        [[SiteOrderManager shareSiteOrderManager] addOrderRemark:orderRemark success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            if ([data intValue] == 1) {
                NSMutableArray * array = [NSMutableArray arrayWithArray:orderEntity.orderRemarksList];
                [array insertObject:orderRemark atIndex:0];
                orderEntity.orderRemarksList = [NSArray arrayWithArray:array];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [MBProgressHUD showTipMessageInWindow:@"备注失败"];
            }
        } fail:^(NSInteger code) {
            
        }];
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
        OrderPremium * orderPremium = [[OrderPremium alloc] init];
        orderPremium.amount = [addPriceTextField.text floatValue];
        orderPremium.orderNo = orderEntity.orderNo;
        orderPremium.reason = reasonTextField.text;
        orderPremium.staff = [[UserManager shareUserManager] getStaff];
        [MBProgressHUD showActivityMessageInWindow:@"新增补价单..."];
        [[SiteOrderManager shareSiteOrderManager] addOrderPremium:orderPremium success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            if ([data intValue] == 1) {
                [MBProgressHUD showTipMessageInWindow:@"新增补价单成功"];
            } else {
                [MBProgressHUD showTipMessageInWindow:@"新增补价单失败"];
            }
        } fail:^(NSInteger code) {
            
        }];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
