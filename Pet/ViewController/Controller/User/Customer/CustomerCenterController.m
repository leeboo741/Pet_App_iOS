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
        return [tableView fd_heightForCellWithIdentifier:OrderCellIdentifier configuration:^(id cell) {
            [self configCustomerOrderCell:cell atIndexPath:indexPath];
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
    cell.delegate = self;
}
-(void)configCustomerOrderCell:(CustomerOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.orderType = [self getCustomerOrderType];
    cell.delegate = self;
}

#pragma mark - center header cell delegate

-(void)tapMessageButtonAtHeaderCell:(CenterHeaderCell *)cell{
    self.haveNewMessage = NO;
}

#pragma mark - center action cell delegate

-(void)tapActionAtIndex:(NSInteger)index atActionCell:(CenterActionCell *)cell{
    switch (index) {
        case 0:
            MSLog(@"查单");
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
    MSLog(@"customer order cell button type : %ld and index : %ld", type, index);
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
        CenterActionItemModel * action3 = [self getActionModelWithActionName:@"申请" andIconName:IconFont_Apply];
        CenterActionItemModel * action4 = [self getActionModelWithActionName:@"切换角色" andIconName:IconFont_ChangeRole];
        _actionModelArray = @[action1,action2,action3,action4];
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


@end
