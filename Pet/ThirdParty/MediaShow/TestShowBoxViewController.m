//
//  TestShowBoxViewController.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "TestShowBoxViewController.h"
#import "TestShowBoxCell.h"
#import "MediaShowItemModel.h"

static NSString * cellIdentifier = @"TestShowBoxCell";

@interface TestShowBoxViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;
@end

@implementation TestShowBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestShowBoxCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(void)configCell:(TestShowBoxCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.dataSource = self.dataSource[indexPath.row];
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        MediaShowItemModel * model = [[MediaShowItemModel alloc]init];
        model.resourcePath = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578245807510&di=70db1216e8c5a7dc9c1ea808a28a249e&imgtype=0&src=http%3A%2F%2Fbig5.wallcoo.com%2Fphotograph%2Fsummer_feeling%2Fimages%2F%255Bwallcoo.com%255D_summer_feeling_234217.jpg";
        
        MediaShowItemModel * model1 = [[MediaShowItemModel alloc]init];
        model1.resourcePath = @"https://media.w3.org/2010/05/sintel/trailer.mp4";
        
        MediaShowItemModel * model2 = [[MediaShowItemModel alloc]init];
        model2.resourcePath = @"https://buzhidao.ss.com/sda";
        _dataSource = @[@[model,model,model1,model,model1],@[model,model1,model,model1],@[model,model,model,model2,model,model]];
    }
    return _dataSource;
}

@end
