//
//  AboutUsViewController.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsHeaderView.h"
#import "AboutUsFooterView.h"

@interface AboutUsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) AboutUsHeaderView * headerView;
@property (nonatomic, strong) AboutUsFooterView * footerView;
@end

static NSString * cellIdentifier = @"CellIdentifier";
static CGFloat cellHeight = 60;

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(cellHeight * self.dataSource.count);
    }];
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            MSLog(@"特别声明");
        }
            break;
        case 1:
        {
            MSLog(@"使用帮助");
        }
            break;
        case 2:
        {
            MSLog(@"给我评分");
        }
            break;
        case 3:
        {
            MSLog(@"隐私政策");
        }
            break;
        default:
            break;
    }
}

#pragma mark - config cell
-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = self.dataSource[indexPath.row];
}

#pragma mark - setters and getters
-(NSArray *)dataSource{
    return @[@"特别声明",@"使用帮助",@"给我评分",@"隐私政策"];
}

-(AboutUsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[AboutUsHeaderView alloc]init];
    }
    return _headerView;
}

-(AboutUsFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[AboutUsFooterView alloc]init];
    }
    return _footerView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}
@end
