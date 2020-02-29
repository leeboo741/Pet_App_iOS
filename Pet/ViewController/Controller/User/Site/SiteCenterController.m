//
//  SiteCenterController.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SiteCenterController.h"
#import "CenterHeaderCell.h"
#import "CenterActionCell.h"
#import "SiteUnpayOrderController.h"
#import "SiteAllOrderController.h"
#import "SiteOutportOrderController.h"
#import "SiteInportOrderController.h"
#import "ApplyCenterController.h"
#import "ApprovalCenterController.h"
#import "WithdrawalController.h"
#import "BalanceFlowController.h"
#import <MMScan/MMScanViewController.h>
#import "MessageCenterController.h"
#import "AboutUsViewController.h"

static NSString * CenterHeaderCellIdentifier = @"CenterHeaderCell";
static NSString * CenterActionCellIdentifier = @"CenterActionCell";

@interface SiteCenterController () <CenterheaderCellDelegate,CenterActionCellDelegate>

@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSArray<CenterActionItemModel *>* actionModelArray;

@end

@implementation SiteCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工作站";
    [self.tableView registerNib:[UINib nibWithNibName:CenterHeaderCellIdentifier bundle:nil] forCellReuseIdentifier:CenterHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CenterActionCellIdentifier bundle:nil] forCellReuseIdentifier:CenterActionCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.haveNewMessage = YES;
    self.balance = 100.90;
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
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
            MSLog(@"待付款");
            SiteUnpayOrderController * unpayOrderController = [[SiteUnpayOrderController alloc]init];
            [self.navigationController pushViewController:unpayOrderController animated:YES];
        }
            break;
        case 1:
        {
            MSLog(@"出港单");
            SiteOutportOrderController * outportOrderController = [[SiteOutportOrderController alloc]init];
            [self.navigationController pushViewController:outportOrderController animated:YES];
        }
            break;
        case 2:
        {
            MSLog(@"入港单");
            SiteInportOrderController * inportOrderController = [[SiteInportOrderController alloc]init];
            [self.navigationController pushViewController:inportOrderController animated:YES];
        }
            break;
        case 3:
        {
            MSLog(@"全部单据");
            SiteAllOrderController * allOrderController = [[SiteAllOrderController alloc]init];
            [self.navigationController pushViewController:allOrderController animated:YES];
        }
            break;
        case 4:
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
        case 5:
        {
            MSLog(@"审批");
            ApprovalCenterController * approvalCenterVC = [[ApprovalCenterController alloc]init];
            [self.navigationController pushViewController:approvalCenterVC animated:YES];
        }
            break;
        case 6:
        {
            MSLog(@"提现");
            WithdrawalController * withdrawalController = [[WithdrawalController alloc]init];
            [self.navigationController pushViewController:withdrawalController animated:YES];
        }
            break;
        case 7:
        {
            MSLog(@"申请");
            ApplyCenterController * applyCenterController = [[ApplyCenterController alloc] init];
            [self.navigationController pushViewController:applyCenterController animated:YES];
        }
            break;
        case 8:
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"切换角色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"商家" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:USER_ROLE_BUSINESS];
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"个人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:USER_ROLE_CUSTOMER];
            }];
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 9:
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
        CenterActionItemModel * action1 = [self getActionModelWithActionName:@"未付款" andIconName:IconFont_Bill_5];
        CenterActionItemModel * action2 = [self getActionModelWithActionName:@"出港单" andIconName:IconFont_Bill_3];
        CenterActionItemModel * action3 = [self getActionModelWithActionName:@"入港单" andIconName:IconFont_Bill_4];
        CenterActionItemModel * action4 = [self getActionModelWithActionName:@"全部" andIconName:IconFont_Bill];
        CenterActionItemModel * action5 = [self getActionModelWithActionName:@"查单" andIconName:IconFont_Scan];
        CenterActionItemModel * action6 = [self getActionModelWithActionName:@"审批" andIconName:IconFont_Bill_2];
        CenterActionItemModel * action7 = [self getActionModelWithActionName:@"提现" andIconName:IconFont_Withdrawal];
        CenterActionItemModel * action8 = [self getActionModelWithActionName:@"申请" andIconName:IconFont_Apply];
        CenterActionItemModel * action9 = [self getActionModelWithActionName:@"切换身份" andIconName:IconFont_ChangeRole];
        CenterActionItemModel * action10 = [self getActionModelWithActionName:@"关于我们" andIconName:IconFont_AboutUs];
        switch ([[UserManager shareUserManager] getUserRole]) {
            case USER_ROLE_MANAGER:
                action6.hidden = NO;
                action7.hidden = NO;
                break;
            case USER_ROLE_SERVICE:
            case USER_ROLE_DRIVER:
                action6.hidden = YES;
                action7.hidden = YES;
                break;
                
            default:
                break;
        }
        _actionModelArray = @[action1,action2,action3,action4,action5,action6,action7,action8,action9,action10];
    }
    return _actionModelArray;
}

#pragma mark - private method

-(CenterActionItemModel *)getActionModelWithActionName:(NSString *)actionName andIconName:(NSString *)iconName{
    CenterActionItemModel * model = [[CenterActionItemModel alloc]init];
    model.actionName = actionName;
    model.actionIconName = iconName;
    return model;
}


@end
