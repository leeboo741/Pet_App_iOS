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
#import "FakeStationListData.h"
#import "StationCell.h"

static NSString * StationListCellIdentifier = @"stationListCellIdentifier";

@interface StationListViewController ()
@property (nonatomic, strong) NSArray<Station*>* dataSource;
@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:@"StationCell" bundle:nil] forCellReuseIdentifier:StationListCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction)];
    [self startRefresh];
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
 下拉刷新触发
 */
-(void)refreshAction{
    self.dataSource = [Station mj_objectArrayWithKeyValuesArray:[FakeStationListData fakeDataJsonStr]];
    [self.tableView reloadData];
    [self endRefresh];
}

/**
 上拉加载触发
 */
-(void)loadMoreAction{
    
}

@end
