//
//  UIViewController+AddMJRefresh.h
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AddMJRefresh)
-(void)addRefreshViewWithRefreshAction:(SEL)refreshAction tableView:(UITableView *)tableView;
-(void)addLoadMoreViewWithLoadMoreAction:(SEL)loadmoreAction tableView:(UITableView *)tableView;
-(void)startRefreshWithTableView:(UITableView*)tableView;
-(void)endRefreshWithTableView:(UITableView*)tableView;
-(void)endLoadMoreWithTableView:(UITableView*)tableView;
@end

NS_ASSUME_NONNULL_END
