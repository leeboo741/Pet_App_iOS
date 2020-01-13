//
//  TransportCitySelectedController.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "TransportCitySelectedController.h"

@interface TransportCitySelectedController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITextField * searchTextField;

@property (nonatomic, strong) NSArray * indexArray;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSMutableArray * cityArray;
@property (nonatomic, strong) NSMutableArray * searchArray;
@end

static NSString * cellIdentifier = @"cell";

@implementation TransportCitySelectedController

-(instancetype)initWithType:(CitySelectedType)type selectBlock:(SelectCityBlock)selectBlock{
    self = [super init];
    if (self) {
        self.type = type;
        self.selectCityBlock = selectBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.searchTextField];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(10);
        make.bottom.equalTo(self.headerView).offset(-10);
        make.width.equalTo(self.headerView).multipliedBy(0.9);
        make.center.equalTo(self.headerView);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - table view datasource and delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexArray[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectCityBlock) {
        self.selectCityBlock(self.dataSource[indexPath.section][indexPath.row]);
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

#pragma mark - config cell
-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
}

#pragma mark - private method


#pragma mark - setters and getters

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
    }
    return _headerView;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.delegate = self;
        _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
        _searchTextField.placeholder = @"中文/拼音/首字母";
    }
    return _searchTextField;
}

@end
