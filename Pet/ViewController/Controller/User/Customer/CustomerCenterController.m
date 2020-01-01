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

static NSString * CenterHeaderCellIdentifier = @"CenterHeaderCell";
static NSString * CenterActionCellIdentifier = @"CenterActionCell";
static NSString * OrderCellIdentifier = @"CustomerOrderCell";

typedef NS_ENUM(NSInteger, CustomerSelectOrderType) {
    CustomerSelectOrderType_unpay = 0,
    CustomerSelectOrderType_unsend = 1,
    CustomerSelectOrderType_unreceiver = 2,
    CustomerSelectOrderType_complete = 3,
};

@interface CustomerCenterController () <CenterheaderCellDelegate,SegmentedSelectViewDelegate>
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
}
-(void)configCustomerOrderCell:(CustomerOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark - segmented select view delegate

-(void)segmentedSelectView:(SegmentedSelectView *)view selectIndex:(NSInteger)index{
    self.selectOrderType = index;
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
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}

-(void)setSelectOrderType:(CustomerSelectOrderType)selectOrderType{
    if (_selectOrderType != selectOrderType) {
        _selectOrderType = selectOrderType;
        [self.tableView reloadData];
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


@end
