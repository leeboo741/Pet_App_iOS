//
//  StationCenterController.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StationCenterController.h"
#import "CenterHeaderCell.h"
#import "CenterActionCell.h"
#import "BalanceFlowController.h"
#import "WithdrawalController.h"
#import "ApplyCenterController.h"
#import "MessageCenterController.h"
#import "AboutUsViewController.h"
#import "MessageManager.h"

static NSString * CenterHeaderCellIdentifier = @"CenterHeaderCell";
static NSString * CenterActionCellIdentifier = @"CenterActionCell";

@interface StationCenterController () <CenterheaderCellDelegate,CenterActionCellDelegate>

@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSArray<CenterActionItemModel *>* actionModelArray;

@end

@implementation StationCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的店铺";
    [self.tableView registerNib:[UINib nibWithNibName:CenterHeaderCellIdentifier bundle:nil] forCellReuseIdentifier:CenterHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CenterActionCellIdentifier bundle:nil] forCellReuseIdentifier:CenterActionCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.haveNewMessage = [[MessageManager shareMessageManager] getHaveNewMessage];
    self.balance = [[UserManager shareUserManager] getBalance];
    [[UserManager shareUserManager] registerUserManagerNotificationWithObserver:self notificationName:USER_BALANCE_CHANGE_NOTIFICATION_NAME action:@selector(changeBalance:)];
    [[MessageManager shareMessageManager] registerNotificationForNewMessageWithObserver:self selector:@selector(changeHaveNewMessage:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UserManager shareUserManager] refreshBalance];
    MSLog(@"Site Center Appear");
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
            MSLog(@"提现");
            WithdrawalController * withdrawalController = [[WithdrawalController alloc]init];
            [self.navigationController pushViewController:withdrawalController animated:YES];
        }
            break;
        case 1:
        {
            MSLog(@"申请");
            ApplyCenterController * applyCenterController = [[ApplyCenterController alloc] init];
            [self.navigationController pushViewController:applyCenterController animated:YES];
        }
            break;
        case 2:
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"切换角色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"个人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:CURRENT_USER_ROLE_CUSTOMER];
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"站点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserManager shareUserManager]changeUserRole:CURRENT_USER_ROLE_STAFF];
            }];
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action1];
            if ([[UserManager shareUserManager] isStaff]) {
                [alertController addAction:action2];
            }
            [alertController addAction:action3];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 3:
        {
            MSLog(@"关于我们");
            AboutUsViewController * aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        case 4:
        {
            MSLog(@"退出");
            [[UserManager shareUserManager] logout];
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
        CenterActionItemModel * action7 = [self getActionModelWithActionName:@"提现" andIconName:IconFont_Withdrawal];
        CenterActionItemModel * action8 = [self getActionModelWithActionName:@"申请" andIconName:IconFont_Apply];
        CenterActionItemModel * action9 = [self getActionModelWithActionName:@"切换身份" andIconName:IconFont_ChangeRole];
        CenterActionItemModel * action10 = [self getActionModelWithActionName:@"关于我们" andIconName:IconFont_AboutUs];
        CenterActionItemModel * action11 = [self getActionModelWithActionName:@"退出" andIconName:IconFont_Logout];
        _actionModelArray = @[action7,action8,action9,action10,action11];
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

-(void)changeBalance:(NSNotification  *)notification{
    NSDictionary * dict = (NSDictionary *)notification.userInfo;
    self.balance = [[dict objectForKey:@"data"] floatValue];
}

-(void)changeHaveNewMessage:(NSNotification *)notification{
    NSDictionary * dict = (NSDictionary *)notification.userInfo;
    self.haveNewMessage = [[dict objectForKey:NOTIFICATION_DATA_HAVE_NEW_MESSAGE_KEY] boolValue];
}

@end
