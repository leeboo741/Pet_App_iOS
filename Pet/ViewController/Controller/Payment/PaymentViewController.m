//
//  PaymentViewController.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentInfoCell.h"
#import "PaymentTypeCell.h"



@interface PaymentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * paymentButton;
@property (nonatomic, strong) NSArray * paymentTypeList;
@property (nonatomic, strong) PaymentTypeModel * selectPaymentType;
@end

static NSString * PaymentTypeCellIdentifier = @"PaymentTypeCell";
static NSString * PaymentInfoCellIdentifier = @"PaymentInfoCell";

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.paymentButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.paymentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - tableview datasource and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.paymentTypeList.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    if (indexPath.section == 0) {
        PaymentInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:PaymentInfoCellIdentifier forIndexPath:indexPath];
        [self configInfoCell:infoCell atIndexPath:indexPath];
        cell = infoCell;
    } else if (indexPath.section == 1) {
        PaymentTypeCell * typeCell = [tableView dequeueReusableCellWithIdentifier:PaymentTypeCellIdentifier forIndexPath:indexPath];
        [self configTypeCell:typeCell atIndexPath:indexPath];
        cell = typeCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:PaymentInfoCellIdentifier configuration:^(id cell) {
            [self configInfoCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:PaymentTypeCellIdentifier configuration:^(id cell) {
            [self configTypeCell:cell atIndexPath:indexPath];
        }];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"支付信息";
    } else if (section == 1) {
        return @"支付方式";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectPaymentType = self.paymentTypeList[indexPath.row];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark - config cell

-(void)configInfoCell:(PaymentInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.paymentPrice = self.paymentPrice;
}

-(void)configTypeCell:(PaymentTypeCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.model = self.paymentTypeList[indexPath.row];
}

#pragma mark - action event

-(void)paymentAction{
    MSLog(@"支付");
}

#pragma mark - setters and getters

-(NSArray *)paymentTypeList{
    if (!_paymentTypeList) {
        PaymentTypeModel * type1 = [[PaymentTypeModel alloc]init];
        type1.typeName = @"微信支付";
        type1.typeIconName = IconFont_WechatPay;
        type1.typeInfo = @"微信安全支付";
        type1.typeCode = Payment_Type_Code_Wechat;
        type1.isRecommend = YES;
        _paymentTypeList = @[type1];
    }
    
    for (PaymentTypeModel * model in _paymentTypeList) {
        if (model.typeCode == self.selectPaymentType.typeCode) {
            model.isSelected = YES;
        } else {
            model.isSelected = NO;
        }
    }
    return _paymentTypeList;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:PaymentInfoCellIdentifier bundle:nil] forCellReuseIdentifier:PaymentInfoCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:PaymentTypeCellIdentifier bundle:nil] forCellReuseIdentifier:PaymentTypeCellIdentifier];
    }
    return _tableView;
}

-(UIButton *)paymentButton{
    if (!_paymentButton) {
        _paymentButton = [[UIButton alloc]init];
        _paymentButton.backgroundColor = Color_yellow_1;
        [_paymentButton setTitleColor:Color_white_1 forState:UIControlStateNormal];
        [_paymentButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_paymentButton addTarget:self action:@selector(paymentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentButton;
}

-(PaymentTypeModel *)selectPaymentType{
    if (!_selectPaymentType) {
        _selectPaymentType = [[PaymentTypeModel alloc]init];
        _selectPaymentType.typeCode = Payment_Type_Code_Wechat;
    }
    return _selectPaymentType;
}

@end
