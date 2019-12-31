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

static NSString * CenterHeaderCellIdentifier = @"CenterHeaderCell";
static NSString * CenterActionCellIdentifier = @"CenterActionCell";
static NSString * OrderCellIdentifier = @"OrderCell";

@interface CustomerCenterController () <CenterheaderCellDelegate>
@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, strong) NSArray<CenterActionItemModel *>* actionModelArray;
@property (nonatomic, assign) NSInteger selectOrderType;

@property (nonatomic, strong) SegmentedSelectView * segmentedView;
@end

@implementation CustomerCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:CenterHeaderCellIdentifier bundle:nil] forCellReuseIdentifier:CenterHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:CenterActionCellIdentifier bundle:nil] forCellReuseIdentifier:CenterActionCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OrderCellIdentifier];
    self.haveNewMessage = YES;
    self.balance = 100.90;
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
    } else if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
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
        return [tableView fd_heightForCellWithIdentifier:OrderCellIdentifier configuration:^(id cell) {
            
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
}

#pragma mark - center header cell delegate
-(void)tapMessageButtonAtHeaderCell:(CenterHeaderCell *)cell{
    self.haveNewMessage = NO;
}

-(CenterActionItemModel *)getActionModelWithActionName:(NSString *)actionName andIconName:(NSString *)iconName{
    CenterActionItemModel * model = [[CenterActionItemModel alloc]init];
    model.actionName = actionName;
    model.actionIconName = iconName;
    return model;
}

#pragma mark - event action
-(void)tapSegmentedControl:(UISegmentedControl*)sender{
    self.selectOrderType = sender.selectedSegmentIndex;
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
        CenterActionItemModel * action1 = [self getActionModelWithActionName:@"功能1" andIconName:IconFont_Car];
        CenterActionItemModel * action2 = [self getActionModelWithActionName:@"功能2" andIconName:IconFont_Bill];
        CenterActionItemModel * action3 = [self getActionModelWithActionName:@"功能3" andIconName:IconFont_Home];
        CenterActionItemModel * action4 = [self getActionModelWithActionName:@"功能4" andIconName:IconFont_Scan];
        CenterActionItemModel * action5 = [self getActionModelWithActionName:@"功能5" andIconName:IconFont_Apply];
        CenterActionItemModel * action6 = [self getActionModelWithActionName:@"功能6" andIconName:IconFont_Train];
        _actionModelArray = @[action1,action2,action3,action4,action5,action6];
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
    }
    return _segmentedView;
}

-(SegmentedSelectItemModel *)getSegmentedItemModelWithName:(NSString *)name isSelected:(BOOL)isSelected{
    SegmentedSelectItemModel * model = [[SegmentedSelectItemModel alloc]init];
    model.title = name;
    model.itemIsSelected = isSelected;
    return model;
}


@end
