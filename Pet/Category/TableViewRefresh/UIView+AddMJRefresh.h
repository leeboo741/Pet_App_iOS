//
//  UIView+AddMJRefresh.h
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//


#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AddMJRefresh)
// 添加refresh
-(void)addRefreshViewWithRefreshAction:(SEL)refreshAction tableView:(UITableView *)tableView;
// 添加loadMore
-(void)addLoadMoreViewWithLoadMoreAction:(SEL)loadmoreAction tableView:(UITableView *)tableView;
// 开始refresh
-(void)startRefreshWithTableView:(UITableView*)tableView;
// 停止refresh
-(void)endRefreshWithTableView:(UITableView*)tableView;
// 停止loadmore
-(void)endLoadMoreWithTableView:(UITableView*)tableView;
@end

NS_ASSUME_NONNULL_END
