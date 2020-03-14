//
//  StationListViewController.m
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StationListViewController.h"
#import "Station.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableViewController+AddMJRefresh.h"
#import "StationCell.h"
#import "StationManager.h"
#import "LocationManager.h"

static NSString * StationListCellIdentifier = @"stationListCellIdentifier";

static NSInteger PageSize = 20;

@interface StationListViewController ()
@property (nonatomic, strong) NSMutableArray<Station*>* dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, assign) BOOL waitRefresh;
@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"驿站中心";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:@"StationCell" bundle:nil] forCellReuseIdentifier:StationListCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction)];
    
    self.location = [[LocationManager shareLocationManager] getLocation];
    if (self.location) {
        self.waitRefresh = NO;
        [self startRefresh];
    } else {
        [MBProgressHUD showActivityMessageInWindow:@"定位中"];
        self.waitRefresh = YES;
        [[LocationManager shareLocationManager] requestLocationWithLocationChangeObserver:self selector:@selector(loactionChange:)];
    }
}

#pragma mark - tableview dataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:StationListCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:StationListCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - private method

/**
 配置cell

 @param cell 要配置的Cell
 @param indexPath cell 所在位置
 */
-(void)configCell:(StationCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    Station * station = self.dataSource[indexPath.row];
    cell.logoPath = station.logoImagePath;
    cell.stationName = station.stationName;
    cell.businessTime = [NSString stringWithFormat:@"%@ - %@",station.businessStartTime,station.businessEndTime];
    cell.phoneNumber = station.phoneNumber;
    cell.address = [NSString stringWithFormat:@"%@%@%@",station.province,station.city,station.detailAddress];
}

/**
 监听 位置变化
 
 @param notification 通知
 */
-(void)loactionChange:(NSNotification *)notification{
    [MBProgressHUD hideHUD];
    self.location = [notification.userInfo objectForKey:NOTIFICATION_CURRENT_LOCATION_KEY];
    if (self.waitRefresh) {
        self.waitRefresh = NO;
        [self startRefresh];
    }
}

/**
 下拉刷新触发
 */
-(void)refreshAction{
    self.pageIndex = 0;
    __weak typeof(self) weakSelf = self;
    [[StationManager shareStationManager] getStationWithPageIndex:self.pageIndex pageSize:PageSize latitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude success:^(id  _Nonnull data) {
        weakSelf.pageIndex = weakSelf.pageIndex + PageSize;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:data];
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        [weakSelf endRefresh];
    }];
}

/**
 上拉加载
 */
-(void)loadMoreAction{
    [self.tableView.mj_footer setState:MJRefreshStateRefreshing];
    __weak typeof(self) weakSelf = self;
    [[StationManager shareStationManager] getStationWithPageIndex:self.pageIndex pageSize:PageSize latitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude success:^(id  _Nonnull data) {
        weakSelf.pageIndex = weakSelf.pageIndex + PageSize;
        NSArray * dataArray = (NSArray *)data;
        if (dataArray.count < PageSize) {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        [weakSelf.dataSource addObjectsFromArray:dataArray];
        [weakSelf.tableView reloadData];
        [weakSelf endLoadMore];
    } fail:^(NSInteger code) {
        [weakSelf endLoadMore];
    }];
}

#pragma mark - setters and getters
-(NSMutableArray<Station *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
