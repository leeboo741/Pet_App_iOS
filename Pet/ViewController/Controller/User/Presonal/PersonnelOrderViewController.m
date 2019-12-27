//
//  PersonnelOrderViewController.m
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "PersonnelOrderViewController.h"
#import "UIViewController+AddMJRefresh.h"
#import "ImageBoxTestCell.h"

static NSString * imageBoxTestCellName = @"ImageBoxTestCell";
static NSString * imageBoxTestCellIdentifier = @"ImageBoxTestCellIdentifier";

@interface PersonnelOrderViewController ()
<UITableViewDelegate,
UITableViewDataSource,
ImageBoxTestCellDelegate>
@property (nonatomic, strong) UITableView * orderListView;
@end

@implementation PersonnelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.orderListView];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.orderListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate and datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageBoxTestCell * cell = [tableView dequeueReusableCellWithIdentifier:imageBoxTestCellIdentifier forIndexPath:indexPath];
    [self configImageBoxTestCell:cell atIndexPath:indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ImageBoxTestCell * cell = [tableView dequeueReusableCellWithIdentifier:imageBoxTestCellIdentifier forIndexPath:indexPath];
//    return cell.cellHeight;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:imageBoxTestCellIdentifier configuration:^(id cell) {
        [self configImageBoxTestCell:cell atIndexPath:indexPath];
    }];
    return height;
}

-(void)configImageBoxTestCell:(ImageBoxTestCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}
#pragma mark - image box test cell delegate
-(void)imageBoxTestCellTapAdd:(ImageBoxTestCell *)cell{
    
}

-(void)imageBoxTestCell:(ImageBoxTestCell *)cell tapImageAtIndex:(NSInteger)index data:(id<MediaSelectItemProtocol>)data {
    
}

-(void)imageBoxTestCell:(ImageBoxTestCell *)cell deleteAtIndex:(NSInteger)index data:(id<MediaSelectItemProtocol>)data {
    
}

-(void)imageBoxTestCell:(ImageBoxTestCell *)cell reloadData:(NSArray *)dataSource{
    [self.orderListView reloadData];
}

-(void)imageBoxTestCell:(ImageBoxTestCell *)cell chengeHeight:(CGFloat)height{
    [self.orderListView reloadData];
}



#pragma mark - refresh and loadmore

-(void)refreshAction{
    
}

-(void)loadMoreAction{
    
}

#pragma mark - private method

#pragma mark - setters and getters
-(UITableView *)orderListView{
    if (!_orderListView) {
        _orderListView = [[UITableView alloc]init];
        _orderListView.delegate = self;
        _orderListView.dataSource = self;
        [self addRefreshViewWithRefreshAction:@selector(refreshAction) tableView:_orderListView];
        [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction) tableView:_orderListView];
        [_orderListView registerNib:[UINib nibWithNibName:imageBoxTestCellName bundle:nil] forCellReuseIdentifier:imageBoxTestCellIdentifier];
        _orderListView.estimatedRowHeight = 180;
    }
    return _orderListView;
}


@end
