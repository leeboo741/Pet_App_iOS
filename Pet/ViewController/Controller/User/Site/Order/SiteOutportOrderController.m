//
//  SiteOutportController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteOutportOrderController.h"
#import "OrderEntity.h"
#import "SiteOutportOrderCell.h"

static NSString * SiteOutportOrderCellIdentifier = @"SiteOutportOrderCell";

@interface SiteOutportOrderController () <SiteOutportOrderCellDelegate>
@property (nonatomic, strong)NSMutableArray * dataSource;
@end

@implementation SiteOutportOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待出港单";
    [self.tableView registerNib:[UINib nibWithNibName:SiteOutportOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteOutportOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteOutportOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteOutportOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteOutportOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteOutportOrderCellIdentifier configuration:^(id cell) {
        [self configSiteOutportOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - config cell
-(void)configSiteOutportOrderCell:(SiteOutportOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    OrderEntity * orderEntity = self.dataSource[indexPath.row];
    cell.selectImageDataList = orderEntity.waitUploadMediaList;
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteOutportOrderCell:(SiteOutportOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"点击 index : %ld || type : %ld", indexPath.row, type);
}

-(void)siteOutportOrderCell:(SiteOutportOrderCell *)cell selectImageDataChange:(NSArray *)selectImageData{
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
