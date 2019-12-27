//
//  UITableViewController+AddMJRefresh.m
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UITableViewController+AddMJRefresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation UITableViewController (AddMJRefresh)

-(void)addRefreshViewWithRefreshAction:(SEL)refreshAction{
    //添加下拉的动画图片
    //设置下拉刷新回调
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:refreshAction];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle]; // 箭头向下时文字
    [header setTitle:@"放开开始刷新" forState:MJRefreshStatePulling]; // 箭头向上时文字
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing]; // 松手刷新
    [header setState:MJRefreshStateIdle];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置字体颜色
    // 状态文字
    header.stateLabel.textColor = [UIColor grayColor];
    // 时间字体的颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = NO;
    // 马上进入刷新状态
    // 设置刷新控件
    self.tableView.mj_header = header;
}

-(void)addLoadMoreViewWithLoadMoreAction:(SEL)loadmoreAction{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:loadmoreAction];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已全部加载" forState:MJRefreshStateNoMoreData];
    [footer setState:MJRefreshStateIdle];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    // 设置footer
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setHidden:NO];
}

-(void)startRefresh{
    NSAssert(self.tableView.mj_header!=nil, @"mj_header 没有添加, 不能调用 startRefresh");
    [self.tableView.mj_header beginRefreshing];
}

-(void)endRefresh{
    NSAssert(self.tableView.mj_header!=nil, @"mj_header 没有添加, 不能调用 endRefresh");
    [self.tableView.mj_header endRefreshing];
}

-(void)endLoadMore{
    NSAssert(self.tableView.mj_footer!=nil, @"mj_footer 没有添加, 不能调用 endLoadMore");
    [self.tableView.mj_footer endRefreshing];
}
@end
