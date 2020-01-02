//
//  SiteAllOrderController.m
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SiteAllOrderController.h"
#import "SegmentedSelectView.h"
#import "SiteAllOrderCell.h"
#import "OrderEntity.h"

typedef NS_ENUM(NSInteger, SiteAllOrderType) {
    SiteAllOrderType_All = 0,
    SiteAllOrderType_Unpay,
    SiteAllOrderType_Unsend,
    SiteAllOrderType_Unreceive,
    SiteAllOrderType_Complete,
};

static NSString * SiteAllOrderCellIdentifier = @"SiteAllOrderCell";

@interface SiteAllOrderController ()
<SiteAllOrderCellDelegate,
SegmentedSelectViewDelegate>
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) SegmentedSelectView * segmentedView;
@property (nonatomic, assign) SiteAllOrderType selectOrderType;

@end

@implementation SiteAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部订单";
    self.selectOrderType = SiteAllOrderType_All;
    [self.tableView registerNib:[UINib nibWithNibName:SiteAllOrderCellIdentifier bundle:nil] forCellReuseIdentifier:SiteAllOrderCellIdentifier];
}

#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiteAllOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:SiteAllOrderCellIdentifier forIndexPath:indexPath];
    [self configSiteAllOrderCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:SiteAllOrderCellIdentifier configuration:^(id cell) {
        [self configSiteAllOrderCell:cell atIndexPath:indexPath];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.segmentedView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
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
-(void)configSiteAllOrderCell:(SiteAllOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}

#pragma mark - site unpay order cell delegate

-(void)tapSiteAllOrderCell:(SiteAllOrderCell *)cell operateType:(OrderOperateButtonType)type{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (type == OrderOperateButtonType_DetailOrder) {
        NSLog(@"详情 : %ld", indexPath.row);
    }
}

#pragma mark - segmented select view delegate

-(void)segmentedSelectView:(SegmentedSelectView *)view selectIndex:(NSInteger)index{
    NSLog(@"选择类型: %ld",index);
    self.selectOrderType = index;
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

-(SegmentedSelectView *)segmentedView{
    if (!_segmentedView) {
        
        SegmentedSelectItemModel * model = [self getSegmentedItemModelWithName:@"全部" isSelected:YES];
        SegmentedSelectItemModel * model1 = [self getSegmentedItemModelWithName:@"待付款" isSelected:NO];
        SegmentedSelectItemModel * model2 = [self getSegmentedItemModelWithName:@"已付款" isSelected:NO];
        SegmentedSelectItemModel * model3 = [self getSegmentedItemModelWithName:@"待收货" isSelected:NO];
        SegmentedSelectItemModel * model4 = [self getSegmentedItemModelWithName:@"已完成" isSelected:NO];
        _segmentedView = [[SegmentedSelectView alloc]init];
        _segmentedView.modelArray = @[model,model1,model2,model3,model4];
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}

-(void)setSelectOrderType:(SiteAllOrderType)selectOrderType{
    if (_selectOrderType != selectOrderType) {
        _selectOrderType = selectOrderType;
        [self.tableView reloadData];
    }
}

#pragma mark - private method

-(SegmentedSelectItemModel *)getSegmentedItemModelWithName:(NSString *)name isSelected:(BOOL)isSelected{
    SegmentedSelectItemModel * model = [[SegmentedSelectItemModel alloc]init];
    model.title = name;
    model.itemIsSelected = isSelected;
    return model;
}



@end
