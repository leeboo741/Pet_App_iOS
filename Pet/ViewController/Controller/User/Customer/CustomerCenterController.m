//
//  CustomerCenterController.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "CustomerCenterController.h"
#import "CenterHeaderCell.h"
#import "CenterActionCell.h"
#import "SegmentedSelectView.h"
#import "CustomerOrderCell.h"
#import "OrderEntity.h"
#import "ApplyCenterController.h"
#import "BalanceFlowController.h"
#import <MMScan/MMScanViewController.h>
#import "MessageCenterController.h"
#import "OrderDetailController.h"
#import "OrderEvaluateController.h"
#import "AboutUsViewController.h"

static NSString * CenterHeaderCellIdentifier = @"CenterHeaderCell";
static NSString * CenterActionCellIdentifier = @"CenterActionCell";
static NSString * OrderCellIdentifier = @"CustomerOrderCell";

typedef NS_ENUM(NSInteger, CustomerSelectOrderType) {
    CustomerSelectOrderType_unpay = 0,
    CustomerSelectOrderType_unsend = 1,
    CustomerSelectOrderType_unreceiver = 2,
    CustomerSelectOrderType_complete = 3,
};

@interface CustomerCenterController ()
<CenterheaderCellDelegate,
CenterActionCellDelegate,
SegmentedSelectViewDelegate,
CustomerOrderCellDelegate>
@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSArray<CenterActionItemModel *>* actionModelArray;

@property (nonatomic, strong) SegmentedSelectView * segmentedView;
@property (nonatomic, assign) CustomerSelectOrderType selectOrderType;

@property (nonatomic, strong) NSMutableArray<OrderEntity *> * unpayOrderList; // 待付款
@property (nonatomic, strong) NSMutableArray<OrderEntity *> * unsendOrderList; // 已付款
@property (nonatomic, strong) NSMutableArray<OrderEntity *> * unreceiverOrderList; // 代签收
@property (nonatomic, strong) NSMutableArray<OrderEntity *> * completeOrderList; // 已完成
@end

@implementation CustomerCenterController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectOrderType = CustomerSelectOrderType_unpay;
    self.navigationItem.title = @"个人中心";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:CenterHeaderCellIdentifier bundle:nil] forCellReuseIdentifier:CenterHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CenterActionCellIdentifier bundle:nil] forCellReuseIdentifier:CenterActionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:OrderCellIdentifier bundle:nil] forCellReuseIdentifier:OrderCellIdentifier];
    self.tableView.estimatedRowHeight = 300;
    self.haveNewMessage = YES;
    self.balance = 100.90;
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 2) {
        switch (self.selectOrderType) {
            case CustomerSelectOrderType_unpay:
                return self.unpayOrderList.count;
            case CustomerSelectOrderType_unsend:
                return self.unsendOrderList.count;
            case CustomerSelectOrderType_unreceiver:
                return self.unreceiverOrderList.count;
            case CustomerSelectOrderType_complete:
                return self.completeOrderList.count;
            default:
                return 0;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CenterHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:CenterHeaderCellIdentifier forIndexPath:indexPath];
        [self configHeaderCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        CenterActionCell * cell = [tableView dequeueReusableCellWithIdentifier:CenterActionCellIdentifier forIndexPath:indexPath];
        [self configActionCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        CustomerOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
        [self configCustomerOrderCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  [tableView fd_heightForCellWithIdentifier:CenterHeaderCellIdentifier configuration:^(id cell) {
            [self configHeaderCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:CenterActionCellIdentifier configuration:^(id cell) {
            [self configActionCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 2) {
        CGFloat height =[tableView fd_heightForCellWithIdentifier:OrderCellIdentifier configuration:^(id cell) {
            [self configCustomerOrderCell:cell atIndexPath:indexPath];
        }];
        return height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel * label = [[UILabel alloc]init];
        label.backgroundColor = Color_gray_1;
        label.text = @" 常用功能";
        label.textColor = Color_blue_2;
        return label;
    } else if (section == 2) {
        return self.segmentedView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    } else if (section == 2) {
        return 80;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = Color_gray_1;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - config cell

-(void)configHeaderCell:(CenterHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.user = [[UserManager shareUserManager]getUser];
    cell.balance = self.balance;
    cell.haveNewMessage = self.haveNewMessage;
    cell.delegate = self;
}
-(void)configActionCell:(CenterActionCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.modelArray = self.actionModelArray;
    cell.delegate = self;
}
-(void)configCustomerOrderCell:(CustomerOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.orderType = [self getCustomerOrderType];
    cell.delegate = self;
}

#pragma mark - center header cell delegate

-(void)tapMessageButtonAtHeaderCell:(CenterHeaderCell *)cell{
    self.haveNewMessage = NO;
    MessageCenterController * messageCenterController = [[MessageCenterController alloc]init];
    [self.navigationController pushViewController:messageCenterController animated:YES];
}
-(void)tapBalanceAtHeaderCell:(CenterHeaderCell *)cell{
    BalanceFlowController * balanceFlowController = [[BalanceFlowController alloc]init];
    [self.navigationController pushViewController:balanceFlowController animated:YES];
}

#pragma mark - center action cell delegate

-(void)tapActionAtIndex:(NSInteger)index atActionCell:(CenterActionCell *)cell{
    switch (index) {
        case 0:
        {
            MSLog(@"查单");
            __weak typeof(self) weakSelf = self;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"查单" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"输入要查询的单据编号";
            }];
            UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * textField = alertController.textFields.firstObject;
                NSString * searchOrderNo = textField.text;
                MSLog(@"查询订单: %@", searchOrderNo);
            }];
            UIAlertAction * scanAction = [UIAlertAction actionWithTitle:@"扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MSLog(@"点击扫描");
                MMScanViewController * scanVC = [[MMScanViewController alloc]initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
                    if (error) {
                        MSLog(@"scan error : %@",error);
                    } else {
                        MSLog(@"scan result : %@",result);
                    }
                }];
                [weakSelf.navigationController pushViewController:scanVC animated:YES];
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:confirmAction];
            [alertController addAction:scanAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 1:
            MSLog(@"领券");
            break;
        case 2:
        {
            MSLog(@"申请");
            ApplyCenterController * applyCenterController = [[ApplyCenterController alloc] init];
            [self.navigationController pushViewController:applyCenterController animated:YES];
        }
            break;
        case 3:
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"切换角色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"站点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:USER_ROLE_SERVICE];
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"商家" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:USER_ROLE_BUSINESS];
            }];
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 4:
        {
            MSLog(@"关于我们");
            AboutUsViewController * aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - segmented select view delegate

-(void)segmentedSelectView:(SegmentedSelectView *)view selectIndex:(NSInteger)index{
    self.selectOrderType = index;
}

#pragma mark - customer order cell delegate

-(void)tapCustomerOrderCell:(CustomerOrderCell *)cell operateType:(OrderOperateButtonType)type atIndex:(NSInteger)index{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MSLog(@"customer order cell button type : %ld and index : %ld", type, indexPath.row);
    switch (type) {
        case OrderOperateButtonType_Pay:
        {
            MSLog(@"订单支付");
        }
            break;
        case OrderOperateButtonType_DetailOrder:
        {
            MSLog(@"订单详情");
            OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
            break;
        case OrderOperateButtonType_ConfirmReceive:
        {
            MSLog(@"确认收货");
            [self showConfirmReceiverAtIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_CancelOrder:
        {
            MSLog(@"取消订单");
            [self showCancelOrderAtIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_EditOrder:
        {
            MSLog(@"修改订单");
            [self showOrderEditViewAtIndexPath:indexPath];
        }
            break;
        case OrderOperateButtonType_Evaluate:
        {
            MSLog(@"评价订单");
            OrderEvaluateController * orderEvaluateController = [[OrderEvaluateController alloc]init];
            [self.navigationController pushViewController:orderEvaluateController animated:YES];
        }
            break;
        case OrderOperateButtonType_Call:
        {
            MSLog(@"拨打电话");
            [self showOrderPhoneCallAtIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - setters and getters

-(void)setBalance:(CGFloat)balance{
    _balance = balance;
    [self.tableView reloadData];
}

-(void)setHaveNewMessage:(BOOL)haveNewMessage{
    _haveNewMessage = haveNewMessage;
    [self.tableView reloadData];
}

-(NSArray<CenterActionItemModel *> *)actionModelArray{
    if (!_actionModelArray) {
        CenterActionItemModel * action1 = [self getActionModelWithActionName:@"查单" andIconName:IconFont_Scan];
        CenterActionItemModel * action2 = [self getActionModelWithActionName:@"领券" andIconName:IconFont_Coupon];
        action2.hidden = YES;
        CenterActionItemModel * action3 = [self getActionModelWithActionName:@"申请" andIconName:IconFont_Apply];
        CenterActionItemModel * action4 = [self getActionModelWithActionName:@"切换角色" andIconName:IconFont_ChangeRole];
        CenterActionItemModel * action5 = [self getActionModelWithActionName:@"关于我们" andIconName:IconFont_AboutUs];
        _actionModelArray = @[action1,action2,action3,action4,action5];
    }
    return _actionModelArray;
}

-(SegmentedSelectView *)segmentedView{
    if (!_segmentedView) {
        SegmentedSelectItemModel * model1 = [self getSegmentedItemModelWithName:@"待付款" isSelected:YES];
        SegmentedSelectItemModel * model2 = [self getSegmentedItemModelWithName:@"已付款" isSelected:NO];
        SegmentedSelectItemModel * model3 = [self getSegmentedItemModelWithName:@"待收货" isSelected:NO];
        SegmentedSelectItemModel * model4 = [self getSegmentedItemModelWithName:@"已完成" isSelected:NO];
        _segmentedView = [[SegmentedSelectView alloc]init];
        _segmentedView.modelArray = @[model1,model2,model3,model4];
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}

-(void)setSelectOrderType:(CustomerSelectOrderType)selectOrderType{
    if (_selectOrderType != selectOrderType) {
        _selectOrderType = selectOrderType;
        NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:2];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(NSMutableArray<OrderEntity *> *)unpayOrderList{
    if (!_unpayOrderList) {
        _unpayOrderList = [NSMutableArray array];
        OrderEntity * order = [[OrderEntity alloc]init];
        [_unpayOrderList addObject:order];
    }
    return _unpayOrderList;
}

-(NSMutableArray<OrderEntity *> *)unsendOrderList{
    if (!_unsendOrderList) {
        _unsendOrderList = [NSMutableArray array];
        OrderEntity * order = [[OrderEntity alloc]init];
        [_unsendOrderList addObject:order];
        [_unsendOrderList addObject:order];
    }
    return _unsendOrderList;
}

-(NSMutableArray<OrderEntity *> *)unreceiverOrderList{
    if (!_unreceiverOrderList) {
        _unreceiverOrderList = [NSMutableArray array];
        OrderEntity * order = [[OrderEntity alloc]init];
        [_unreceiverOrderList addObject:order];
        [_unreceiverOrderList addObject:order];
        [_unreceiverOrderList addObject:order];
    }
    return _unreceiverOrderList;
}

-(NSMutableArray<OrderEntity *> *)completeOrderList{
    if (!_completeOrderList) {
        _completeOrderList = [NSMutableArray array];
        OrderEntity * order = [[OrderEntity alloc]init];
        [_completeOrderList addObject:order];
        [_completeOrderList addObject:order];
        [_completeOrderList addObject:order];
        [_completeOrderList addObject:order];
    }
    return _completeOrderList;
}

#pragma mark - private method

-(SegmentedSelectItemModel *)getSegmentedItemModelWithName:(NSString *)name isSelected:(BOOL)isSelected{
    SegmentedSelectItemModel * model = [[SegmentedSelectItemModel alloc]init];
    model.title = name;
    model.itemIsSelected = isSelected;
    return model;
}

-(CenterActionItemModel *)getActionModelWithActionName:(NSString *)actionName andIconName:(NSString *)iconName{
    CenterActionItemModel * model = [[CenterActionItemModel alloc]init];
    model.actionName = actionName;
    model.actionIconName = iconName;
    return model;
}

-(CustomerOrderType)getCustomerOrderType{
    switch (self.selectOrderType) {
        case CustomerSelectOrderType_unpay:
            return CustomerOrderType_Unpay;
        case CustomerSelectOrderType_unsend:
            return CustomerOrderType_Unsend;
        case CustomerSelectOrderType_unreceiver:
            return CustomerOrderType_Unreceive;
        case CustomerSelectOrderType_complete:
            return CustomerOrderType_Complete;
        default:
            return CustomerOrderType_Unpay;
    }
}

/**
 *  修改订单弹窗
 *  @param indexPath 订单所在行
 */
-(void)showOrderEditViewAtIndexPath:(NSIndexPath *)indexPath{
    OrderEntity * editOrderEntity = nil;
    switch (self.selectOrderType) {
        case CustomerSelectOrderType_unpay:
            editOrderEntity = self.unpayOrderList[indexPath.row];
            break;
        case CustomerSelectOrderType_unsend:
            editOrderEntity = self.unsendOrderList[indexPath.row];
            break;
        case CustomerSelectOrderType_unreceiver:
            editOrderEntity = self.unreceiverOrderList[indexPath.row];
            break;
        case CustomerSelectOrderType_complete:
        {
            [MBProgressHUD showErrorMessage:@"已完成订单不能修改"];
        }
            return;
        default:
        {
            [MBProgressHUD showErrorMessage:@"未知订单类型"];
        }
            return;
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"修改订单" message:@"修改订单信息" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入寄宠人姓名";
        textField.text = editOrderEntity.senderName;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入寄宠人手机";
        textField.text = editOrderEntity.senderPhone;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入收宠人姓名";
        textField.text = editOrderEntity.receiverName;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入收宠人手机";
        textField.text = editOrderEntity.receiverPhone;
    }];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * senderNameTF = alertController.textFields[0];
        UITextField * senderPhoneTF = alertController.textFields[1];
        UITextField * receiverNameTF = alertController.textFields[2];
        UITextField * receiverPhoneTF = alertController.textFields[3];
        if (kStringIsEmpty(senderNameTF.text)
            || kStringIsEmpty(senderPhoneTF.text)
            || kStringIsEmpty(receiverNameTF.text)
            || kStringIsEmpty(receiverPhoneTF.text)) {
            [MBProgressHUD showErrorMessage:@"收寄人信息不能为空"];
            return;
        }
        MSLog(@"%@ , %@ || %@ , %@",senderNameTF.text, senderPhoneTF.text, receiverNameTF.text, receiverPhoneTF.text);
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  确认订单收货
 *  @param indexPath 订单所在行
 */
-(void)showConfirmReceiverAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectOrderType != CustomerSelectOrderType_unreceiver) {
        [MBProgressHUD showErrorMessage:@"不能签收该订单"];
        return;
    }
    OrderEntity * tempOrderEntity = self.unreceiverOrderList[indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确认收货" message:[NSString stringWithFormat:@"是否确认签收订单:%@",tempOrderEntity.orderNo] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MSLog(@"确认签收");
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  取消订单
 *  @param indexPath 订单所在行
 */
-(void)showCancelOrderAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectOrderType != CustomerSelectOrderType_unpay) {
        [MBProgressHUD showErrorMessage:@"不能取消该订单"];
        return;
    }
    OrderEntity * tempOrderEntity = self.unpayOrderList[indexPath.row];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确认取消" message:[NSString stringWithFormat:@"是否确认取消订单:%@",tempOrderEntity.orderNo] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MSLog(@"确认取消");
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  拨打订单电话
 *  @param indexPath 订单所在行
 */
-(void)showOrderPhoneCallAtIndexPath:(NSIndexPath * )indexPath{
    OrderEntity * orderEntity = nil;
    switch (self.selectOrderType) {
        case CustomerSelectOrderType_unpay:
            orderEntity = self.unpayOrderList[indexPath.row];
            break;
        case CustomerSelectOrderType_unsend:
            orderEntity = self.unsendOrderList[indexPath.row];
            break;
        case CustomerSelectOrderType_unreceiver:
            orderEntity = self.unreceiverOrderList[indexPath.row];
        case CustomerSelectOrderType_complete:
            orderEntity = self.completeOrderList[indexPath.row];
            break;
        default:
        {
            [MBProgressHUD showErrorMessage:@"未知订单类型"];
        }
            return;
    }
    Util_MakePhoneCall(@"10086");
}

@end
