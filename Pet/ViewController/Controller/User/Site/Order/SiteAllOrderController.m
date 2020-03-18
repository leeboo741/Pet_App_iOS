//
//  SiteAllOrderController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteAllOrderController.h"
#import "SegmentedSelectView.h"
#import "SiteAllOrderCell.h"
#import "OrderEntity.h"
#import "OrderDetailController.h"
#import "SiteOrderManager.h"
#import "UITableViewController+AddMJRefresh.h"
#import "InOrOutPortFilterController.h"

typedef NS_ENUM(NSInteger, SiteAllOrderType) {
    SiteAllOrderType_All = 0,
    SiteAllOrderType_Unpay,
    SiteAllOrderType_Unsend,
    SiteAllOrderType_Unreceive,
    SiteAllOrderType_Complete,
};

static NSString * SiteAllOrderCellIdentifier = @"SiteAllOrderCell";

static NSInteger Limit = 10;

typedef NS_ENUM(NSInteger, SiteIn_TextField_Tag) {
    SiteAll_TextField_Tag_Search = 999,
};

@interface SiteAllOrderController ()
<SiteAllOrderCellDelegate,
UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * actionSearchView;
@property (nonatomic, strong) UITextField * actionSearchTextfield;
@property (nonatomic, strong) InOrOutPortRequestParam * param;

@property (nonatomic, assign) NSInteger offset;

@end

@implementation SiteAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部订单";
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:@"更多筛选" forState:UIControlStateNormal];
    [button setTitleColor:Color_blue_1 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moreFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [self.tableView registerNib:[UINib nibWithNibName:SiteAllOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteAllOrderCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction)];
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
    
    SiteAllOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteAllOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteAllOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteAllOrderCellIdentifier configuration:^(id cell) {
        [self configSiteAllOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.actionSearchView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - config cell
-(void)configSiteAllOrderCell:(SiteAllOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.orderEntity = orderEntity;
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteAllOrderCell:(SiteAllOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    if (type == OrderOperateButtonType_DetailOrder) {
        MSLog(@"订单详情 : %ld", indexPath.row);
        OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
        orderDetailVC.orderNo = orderEntity.orderNo;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == SiteAll_TextField_Tag_Search) {
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
        _actionSearchTextfield.tag = SiteAll_TextField_Tag_Search;
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
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToInport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToOutport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToPack],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToArrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Arrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Delivering],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToSign],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Completed],
        ];
        [_param.orderTypeArray addObjectsFromArray:array];
        _param.offset = kIntegerNumber(0);
        _param.limit = kIntegerNumber(Limit);
    }
    return _param;
}

#pragma mark - private method

-(void)moreFilter{
    InOrOutPortFilterController * inOrOutPortFilterController = [[InOrOutPortFilterController alloc]init];
    inOrOutPortFilterController.param = self.param;
    inOrOutPortFilterController.filterType = InOrOutPortFilter_Type_All;
    __weak typeof(self) weakSelf = self;
    inOrOutPortFilterController.returnBlock = ^(InOrOutPortRequestParam * _Nonnull param) {
        weakSelf.param = param;
        [weakSelf startRefresh];
    };
    [self.navigationController pushViewController:inOrOutPortFilterController animated:YES];
}

-(void)refreshAction{
    self.param.offset = kIntegerNumber(0);
    __weak typeof(self) weakSelf = self;
    [self getOrderDataSuccess:^(id  _Nonnull data) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:(NSArray *)data];
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}
-(void)loadMoreAction{
    __weak typeof(self) weakSelf = self;
    [self getOrderDataSuccess:^(id  _Nonnull data) {
        NSArray * array = (NSArray *)data;
        if (array.count < Limit) {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf.dataSource addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        [weakSelf endLoadMore];
    } fail:^(NSInteger code) {
        [weakSelf endLoadMore];
    }];
}
-(void)getOrderDataSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    [[SiteOrderManager shareSiteOrderManager] getStationAllOrderByParam:self.param success:^(id  _Nonnull data) {
        NSInteger offset = [weakSelf.param.offset integerValue];
        offset = offset + 1;
        weakSelf.param.offset = kIntegerNumber(offset);
        if (success) {
            success(data);
        }
    } fail:^(NSInteger code) {
        if (fail) {
            fail(code);
        }
    }];
}

@end
