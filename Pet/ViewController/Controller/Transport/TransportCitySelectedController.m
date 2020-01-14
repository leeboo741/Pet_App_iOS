//
//  TransportCitySelectedController.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "TransportCitySelectedController.h"
#import "OrderManager.h"

@interface TransportCitySelectedController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) UILabel * alertLabel;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * indexArray;
@property (nonatomic, copy) NSString * searchKeyword;
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
    self.view.backgroundColor = [UIColor colorWithRed:235 green:235 blue:235 alpha:1];
    NSString * viewTitle = @"选择城市";
    if (self.type == CitySelectedType_Start) {
        viewTitle = @"选择起始城市";
    } else if (self.type == CitySelectedType_End) {
        viewTitle = @"选择目的城市";
    }
    self.navigationItem.title = viewTitle;
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.searchTextField];
    [self.view addSubview:self.tableView];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat topHeight = kStatusHeight + self.navigationController.navigationBar.size.height;
    [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertLabel.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
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
    NSArray * subArray = self.dataSource[section];
    return subArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexArray[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectCityBlock) {
        CityModel * model = self.dataSource[indexPath.section][indexPath.row];
        self.selectCityBlock(model.cityName);
        [self.navigationController popViewControllerAnimated:YES];
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
    CityModel * model = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = model.cityName;
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchKeyword = textField.text;
    [self getData];
    return YES;
}

#pragma mark - private method

-(void)getData{
    [MBProgressHUD showActivityMessageInView:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    if (self.type == CitySelectedType_Start) {
        [[OrderManager shareOrderManager] getStartCityWithKeyword:self.searchKeyword success:^(NSArray * _Nullable dataList, NSArray * _Nullable indexList) {
            [MBProgressHUD hideHUD];
            weakSelf.dataSource = dataList;
            weakSelf.indexArray = indexList;
            [weakSelf.tableView reloadData];
        } fail:^(NSInteger code) {
            [MBProgressHUD hideHUD];
        }];
    } else if (self.type == CitySelectedType_End){
        NSAssert(self.startCity!=nil, @"开始城市不能为空");
        if (self.startCity) {
            [[OrderManager shareOrderManager] getEndCityWithStartCity:self.startCity keyword:self.searchKeyword success:^(NSArray * _Nullable dataList, NSArray * _Nullable indexList) {
                [MBProgressHUD hideHUD];
                weakSelf.dataSource = dataList;
                weakSelf.indexArray = indexList;
                [weakSelf.tableView reloadData];
            } fail:^(NSInteger code) {
                [MBProgressHUD hideHUD];
            }];
        }
    }
}

#pragma mark - event action

-(void)tapPhoneAction{
    Util_MakePhoneCall(Service_Phone);
}

#pragma mark - setters and getters

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

-(NSArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [NSArray array];
    }
    return _indexArray;
}

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
        _headerView.backgroundColor = [UIColor colorWithRed:235 green:235 blue:235 alpha:1];
    }
    return _headerView;
}

-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.backgroundColor =  Color_yellow_1;
        NSString * string = [NSString stringWithFormat:@"如无对应站点,请联系客服%@处理",Service_Phone];
        NSRange fullRange = [string rangeOfString:string];
        NSRange phoneRange = [string rangeOfString:Service_Phone];
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:Color_red_1 range:fullRange];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:Color_blue_1 range:phoneRange];
        [attributeStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:phoneRange];
        _alertLabel.attributedText = attributeStr;
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoneAction)];
        [_alertLabel addGestureRecognizer:tap];
        _alertLabel.userInteractionEnabled = YES;
    }
    return _alertLabel;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.delegate = self;
        _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
        _searchTextField.placeholder = @"中文/拼音/首字母";
        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}

@end
