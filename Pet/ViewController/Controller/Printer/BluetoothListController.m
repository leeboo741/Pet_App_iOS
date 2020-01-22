//
//  BluetoothListController.m
//  Pet
//
//  Created by mac on 2020/1/22.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "BluetoothListController.h"

static NSString * DeviceCellIdentifier = @"DeviceCellIdentifier";

@interface BluetoothListController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary * deviceDict;
@end

@implementation BluetoothListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    [[PrinterConneterManager sharePrinterConneterManager] getPeripheralsWithServices:nil options:nil resultCallback:^(NSDictionary * _Nonnull resultDict) {
        weakSelf.deviceDict = resultDict;
        [weakSelf.tableView reloadData];
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[PrinterConneterManager sharePrinterConneterManager] stopScan];
}

#pragma mark - tableview delegate and datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DeviceCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:DeviceCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.deviceDict.allKeys count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = self.deviceDict.allKeys[indexPath.row];
    CBPeripheral * peripheral = [self.deviceDict objectForKey:key];
    [[PrinterConneterManager sharePrinterConneterManager] connectPeripheral:peripheral options:nil timeout:2 connectBlock:self.connectStateBlock];
}

#pragma mark - config cell

-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString * key = self.deviceDict.allKeys[indexPath.row];
    CBPeripheral * peripheral = [self.deviceDict objectForKey:key];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
}

#pragma mark - setters and getters
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DeviceCellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
