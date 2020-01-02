//
//  SiteUnpayOrderController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteUnpayOrderController.h"
#import "SiteUnpayOrderCell.h"
#import "OrderEntity.h"

static NSString * SiteUnpayOrderCellIdentifier = @"SiteUnpayOrderCell";

@interface SiteUnpayOrderController () <SiteUnpayOrderCellDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation SiteUnpayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未支付订单";
    [self.tableView registerNib:[UINib nibWithNibName:SiteUnpayOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteUnpayOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteUnpayOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteUnpayOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteUnpayOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteUnpayOrderCellIdentifier configuration:^(id cell) {
        [self configSiteUnpayOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view = [[UIView alloc] init];
//    view.backgroundColor = Color_gray_1;
//    return view;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

#pragma mark - config cell
-(void)configSiteUnpayOrderCell:(SiteUnpayOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteUnpayOrderCell:(SiteUnpayOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if(type == OrderOperateButtonType_ChangePrice) {
        NSLog(@"改价 : %ld", indexPath.row);
    } else if (type == OrderOperateButtonType_DetailOrder) {
        NSLog(@"详情 : %ld", indexPath.row);
    }
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
