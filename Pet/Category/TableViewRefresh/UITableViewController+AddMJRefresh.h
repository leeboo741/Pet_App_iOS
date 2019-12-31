//
//  UITableViewController+AddMJRefresh.h
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewController (AddMJRefresh)
// 
-(void)addRefreshViewWithRefreshAction:(SEL)refreshAction;
-(void)addLoadMoreViewWithLoadMoreAction:(SEL)loadmoreAction;
-(void)startRefresh;
-(void)endRefresh;
-(void)endLoadMore;
@end

NS_ASSUME_NONNULL_END
