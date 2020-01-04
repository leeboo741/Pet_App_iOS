//
//  SiteInportController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteInportOrderController.h"
#import "OrderEntity.h"
#import "SiteInportOrderCell.h"

static NSString * SiteInportOrderCellIdentifier = @"SiteInportOrderCell";

@interface SiteInportOrderController ()<SiteInportOrderCellDelegate>
@property (nonatomic, strong)NSMutableArray * dataSource;
@end

@implementation SiteInportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待签收单";
    [self.tableView registerNib:[UINib nibWithNibName:SiteInportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteInportOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteInportOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteInportOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteInportOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteInportOrderCellIdentifier configuration:^(id cell) {
        [self configSiteInportOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - config cell
-(void)configSiteInportOrderCell:(SiteInportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.selectImageDataList = orderEntity.waitUploadMediaList;
}

#pragma mark - site inport order cell delegate

-(void)tapSiteInportOrderCell:(SiteInportOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    MSLog(@"点击 index : %ld || type : %ld", indexPath.row, type);
}

-(void)siteInportOrderCell:(SiteInportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    orderEntity.waitUploadMediaList = selectImageData;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - setters and getters

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        OrderEntity * orderEntity = [[OrderEntity alloc]init];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
        [_dataSource addObject:orderEntity];
    }
    return _dataSource;
}

@end
