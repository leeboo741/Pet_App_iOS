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
#import "PrinterConneterManager.h"
#import "SiteOrderManager.h"
#import "UITableViewController+AddMJRefresh.h"
#import "InOrOutPortFilterController.h"
#import "DateUtils.h"
#import "CGXPickerView.h"

static NSString * SiteOutportOrderCellIdentifier = @"SiteOutportOrderCell";

typedef NS_ENUM(NSInteger, SiteOut_TextField_Tag) {
    SiteOut_TextField_Tag_Search = 999,
    SiteOut_TextField_Tag_TransportNum = 1000,
    SiteOut_TextField_Tag_StartCity = 1001,
    SiteOut_TextField_Tag_EndCity = 1002,
    SiteOut_TextField_Tag_TransportTime = 1003,
    SiteOut_TextField_Tag_ExpressNum = 1004
};

@interface SiteOutportOrderController () <SiteOutportOrderCellDelegate,UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray<OrderEntity *> * dataSource;
@property (nonatomic, assign, readonly) BOOL hasPrinterConnected; // 是否链接设备

@property (nonatomic, strong) UIView * actionSearchView;
@property (nonatomic, strong) UITextField * actionSearchTextfield;
@property (nonatomic, strong) InOrOutPortRequestParam * param;
@end

@implementation SiteOutportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待出港单";
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:@"更多筛选" forState:UIControlStateNormal];
    [button setTitleColor:Color_blue_1 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self.tableView registerNib:[UINib nibWithNibName:SiteOutportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteOutportOrderCellIdentifier];
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
    return self.actionSearchView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - config cell
-(void)configSiteOutportOrderCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.orderEntity = orderEntity;
}

#pragma mark - site outport order cell delegate

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
        {
            MSLog(@"打印");
            OrderEntity * printerOrder = self.dataSource[indexPath.row];
            [[PrinterConneterManager sharePrinterConneterManager] startPrinter:printerOrder];
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
        case OrderOperateButtonType_Assignment:
        {
            MSLog(@"分配订单");
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            AssignmentsController * assignmentsController = [[AssignmentsController alloc]init];
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
        case OrderOperateButtonType_Package:
        {
            MSLog(@"入港");
            OrderEntity * orderEntity = self.dataSource[indexPath.row];
            NSArray * fileList = [[SiteOrderManager shareSiteOrderManager] getCommitFileListFromWaitCommitMediaList:orderEntity.waitCommitMediaList];
            OrderStatus * status = [orderEntity.orderStates firstObject];
            SiteOrderState state = [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateByString:status.orderType];
            __weak typeof(self) weakSelf = self;
            if (state == SiteOrderState_ToOutport) {
                [[SiteOrderManager shareSiteOrderManager] getUnpayPremiumCountWithOrderNo:orderEntity.orderNo success:^(id  _Nonnull data) {
                    if ([data intValue] > 0) {
                        [AlertControllerTools showAlertWithTitle:@"订单还有未支付补价单" msg:@"完成补价后再执行该操作" items:@[@"确定"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                            
                        }];
                    } else {
                        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"运输信息" message:@"请输入运输信息" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"请输入航班号|车次号";
                            textField.tag = SiteOut_TextField_Tag_TransportNum;
                            textField.delegate = self;
                        }];
                        if (orderEntity.transport.transportType == OrderTransport_TransportType_Code_Suiji
                            || orderEntity.transport.transportType == OrderTransport_TransportType_Code_Danfei) {
                            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                textField.placeholder = @"始发机场三字码";
                                textField.tag = SiteOut_TextField_Tag_StartCity;
                                textField.delegate = self;
                            }];
                            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                textField.placeholder = @"目的机场三字码";
                                textField.tag = SiteOut_TextField_Tag_EndCity;
                                textField.delegate = self;
                            }];
                            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                textField.placeholder = @"请选择航班时间";
                                textField.tag = SiteOut_TextField_Tag_TransportTime;
                                textField.delegate = self;
                            }];
                        }
                        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = @"请输入快递单号";
                            textField.tag = SiteOut_TextField_Tag_ExpressNum;
                            textField.delegate = self;
                        }];
                        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            OrderTransportInfo * transportInfo = [[OrderTransportInfo alloc] init];
                            UITextField * transportNumTF = alertController.textFields[0];
                            transportInfo.transportNum = transportNumTF.text;
                            if (orderEntity.transport.transportType == OrderTransport_TransportType_Code_Suiji
                            || orderEntity.transport.transportType == OrderTransport_TransportType_Code_Danfei) {
                                UITextField * startCityTF = alertController.textFields[1];
                                transportInfo.startCity = startCityTF.text;
                                if (kStringIsEmpty(transportInfo.startCity)) {
                                    [MBProgressHUD showErrorMessage:@"始发机场三字码不能为空"];
                                    return;
                                }
                                UITextField * endCityTF = alertController.textFields[2];
                                transportInfo.endCity = endCityTF.text;
                                if (kStringIsEmpty(transportInfo.endCity)) {
                                    [MBProgressHUD showErrorMessage:@"目的机场三字码不能为空"];
                                    return;
                                }
                                UITextField * transportTimeTF = alertController.textFields[3];
                                transportInfo.dateTime = transportTimeTF.text;
                                if (kStringIsEmpty(transportInfo.dateTime)) {
                                    [MBProgressHUD showErrorMessage:@"航班时间不能为空"];
                                    return;
                                }
                            }
                            UITextField * expressNumTF = alertController.textFields.lastObject;
                            transportInfo.expressNum = expressNumTF.text;
                            if (kStringIsEmpty(transportInfo.expressNum)) {
                                [MBProgressHUD showErrorMessage:@"快递单号不能为空"];
                                return;
                            }
                            transportInfo.order = orderEntity;
                            transportInfo.staff = [[UserManager shareUserManager] getStaff];
                            [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
                            [[SiteOrderManager shareSiteOrderManager] postTransportInfo:transportInfo success:^(id  _Nonnull data) {
                                [MBProgressHUD hideHUD];
                                if ([data intValue] > 0) {
                                    [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
                                    [[SiteOrderManager shareSiteOrderManager] inOrOutPortWithOrderNo:orderEntity.orderNo sn:status.sn orderType:status.orderType fileList:fileList success:^(id  _Nonnull data) {
                                        [MBProgressHUD hideHUD];
                                        if ([data intValue] > 0) {
                                            [weakSelf startRefresh];
                                        } else {
                                            [MBProgressHUD showTipMessageInWindow:@"操作失败"];
                                        }
                                    } fail:^(NSInteger code) {
                                        
                                    }];
                                } else {
                                    [MBProgressHUD showErrorMessage:@"添加运输信息失败"];
                                }
                            } fail:^(NSInteger code) {
                                
                            }];
                        }];
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:confirmAction];
                        [alertController addAction:cancelAction];
                        [weakSelf presentViewController:alertController animated:YES completion:nil];
                    }
                } fail:^(NSInteger code) {
                    
                }];
            } else {
                [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
                [[SiteOrderManager shareSiteOrderManager] inOrOutPortWithOrderNo:orderEntity.orderNo sn:status.sn orderType:status.orderType fileList:fileList success:^(id  _Nonnull data) {
                    [MBProgressHUD hideHUD];
                    if ([data intValue] > 0) {
                        [weakSelf startRefresh];
                    } else {
                        [MBProgressHUD showTipMessageInWindow:@"操作失败"];
                    }
                } fail:^(NSInteger code) {
                    
                }];
            }
        }
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

#pragma mark - textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == SiteOut_TextField_Tag_TransportTime) {
        NSString * todayStr = [[DateUtils shareDateUtils] getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
        NSDate * maxDate = [[DateUtils shareDateUtils] getDateWithTargetDate:[NSDate date] durationYear:0 durationMonth:1 durationDay:0];
        NSString * maxDateStr = [[DateUtils shareDateUtils]getDateStringWithDate:maxDate withFormatterStr:Formatter_YMD];
        [CGXPickerView showDatePickerWithTitle:@"出发时间" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:todayStr MaxDateStr:maxDateStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
            textField.text = selectValue;
        }];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == SiteOut_TextField_Tag_Search) {
        MSLog(@"点击确定搜索");
        self.param.orderNo = textField.text;
        [self startRefresh];
        return  YES;
    }
    return YES;
}

#pragma mark - setters and getters

-(NSMutableArray<OrderEntity *> *)dataSource{
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
        _actionSearchTextfield.delegate = self;
        _actionSearchTextfield.tag = SiteOut_TextField_Tag_Search;
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

-(BOOL)hasPrinterConnected{
    return [[PrinterConneterManager sharePrinterConneterManager] hasConnectPrinter];
}
-(InOrOutPortRequestParam *)param{
    if (!_param) {
        _param = [[InOrOutPortRequestParam alloc]init];
        NSArray * array = @[
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToInport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToOutport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToPack]
        ];
        [_param.orderTypeArray addObjectsFromArray:array];
    }
    return _param;
}

#pragma mark - private method

-(void)moreFilter{
    InOrOutPortFilterController * inOrOutPortFilterController = [[InOrOutPortFilterController alloc]init];
    inOrOutPortFilterController.param = self.param;
    inOrOutPortFilterController.filterType = InOrOutPortFilter_Type_Out;
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
        if (kStringIsEmpty(addPriceTextField.text) || !Util_IsNumberString(addPriceTextField.text)) {
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
        if (kStringIsEmpty(serviceAmountTextField.text) || !Util_IsNumberString(serviceAmountTextField.text)) {
            serviceAmountTextField.text = @"0";
        }
        if (kStringIsEmpty(reasonTextField.text)) {
            [MBProgressHUD showTipMessageInWindow:@"退款原因不能为空"];
            return;
        }
        MSLog(@"第 %ld 行 添加退款信息\n 金额: %@ \n 原因: %@",indexPath.row, serviceAmountTextField.text, reasonTextField.text);
        [MBProgressHUD showActivityMessageInWindow:@"提交中..."];
        [[SiteOrderManager shareSiteOrderManager] addOrderRefund:orderEntity serviceFeeAmount:[serviceAmountTextField.text floatValue] refundReason:reasonTextField.text success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            if ([data intValue] > 0) {
                [MBProgressHUD showTipMessageInWindow:@"退款申请提交成功"];
            } else {
                [MBProgressHUD showTipMessageInWindow:@"退款申请提交失败"];
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
