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

static NSInteger mediaColumn = 3;
static NSInteger mediaHeight = 150;

@interface PersonnelOrderViewController ()
<UITableViewDelegate,
UITableViewDataSource,
ImageBoxTestCellDelegate,
ImageBoxTestCellConfig>
@property (nonatomic, strong) UITableView * orderListView;
@property (nonatomic, strong) NSArray * datasource;
@property (nonatomic, assign) CGFloat boxHeight;
@end

@implementation PersonnelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.datasource = [NSArray array];
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
//    return self.boxHeight;
    NSInteger rowCount = (self.datasource.count+1)/ mediaColumn;
    NSInteger lastColumn = (self.datasource.count+1) % mediaColumn;
    if (lastColumn != 0) {
        rowCount = rowCount + 1;
    }
    return rowCount * mediaHeight;
}

-(void)configImageBoxTestCell:(ImageBoxTestCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.config = self;
}
#pragma mark - image box test cell delegate and datasource
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell changeData:(NSArray *)dataSource{
    self.datasource = dataSource;
    [self.orderListView reloadData];
}
//
//-(void)imageBoxTestCell:(ImageBoxTestCell *)cell changeHeight:(CGFloat)height{
//    self.boxHeight = height;
//    [self.orderListView reloadData];
//}

-(NSInteger)numberOfMediaColumn{
    return mediaColumn;
}

-(CGFloat)heightOfMediaItem{
    return mediaHeight;
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
//        [self addRefreshViewWithRefreshAction:@selector(refreshAction) tableView:_orderListView];
//        [self addLoadMoreViewWithLoadMoreAction:@selector(loadMoreAction) tableView:_orderListView];
        [_orderListView registerNib:[UINib nibWithNibName:imageBoxTestCellName bundle:nil] forCellReuseIdentifier:imageBoxTestCellIdentifier];
//        _orderListView.estimatedRowHeight = 180;
//        _orderListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _orderListView;
}

@end
