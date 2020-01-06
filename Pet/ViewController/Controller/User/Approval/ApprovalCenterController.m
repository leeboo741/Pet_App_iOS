//
//  ApprovalCenterController.m
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApprovalCenterController.h"
#import "SegmentedSelectView.h"
#import "ApprovalStaffCell.h"
#import "ApprovalStationCell.h"


@interface ApplyForStation : NSObject
@property (nonatomic, copy) NSString * applyNo;
@property (nonatomic, copy) NSString * storeName;
@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * businessStartTime;
@property (nonatomic, copy) NSString * businessEndTime;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * detailAddress;
@property (nonatomic, copy) NSString * descriptionStr;
@end

@implementation ApplyForStation
@end

@interface ApplyForStaff : NSObject
@property (nonatomic, copy) NSString * applyNo;
@property (nonatomic, copy) NSString * staffName;
@property (nonatomic, copy) NSString * staffPhone;
@end

@implementation ApplyForStaff
@end

static NSString * ApprovalStaffCellIdentifier = @"ApprovalStaffCell";
static NSString * ApprovalStationCellIdentifier = @"ApprovalStationCell";

typedef NS_ENUM(NSInteger, ApprovalType) {
    ApprovalType_Station = 0,
    ApprovalType_Staff,
};

@interface ApprovalCenterController ()
<
SegmentedSelectViewDelegate
>
@property (nonatomic, assign) ApprovalType selectedApprovalType;
@property (nonatomic, strong) SegmentedSelectView * segmentedView;
@property (nonatomic, strong) NSArray * stationApplyList;
@property (nonatomic, strong) NSArray * staffApplyList;
@end

@implementation ApprovalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedApprovalType = ApprovalType_Station;
    self.navigationItem.title = @"审批";
    [self.tableView registerNib:[UINib nibWithNibName:ApprovalStationCellIdentifier bundle:nil] forCellReuseIdentifier:ApprovalStationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApprovalStaffCellIdentifier bundle:nil] forCellReuseIdentifier:ApprovalStaffCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.selectedApprovalType) {
        case ApprovalType_Station:
        {
            return self.stationApplyList.count;
        }
        case ApprovalType_Staff:
        {
            return self.staffApplyList.count;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedApprovalType) {
        case ApprovalType_Station:
        {
            ApprovalStationCell * cell = [tableView dequeueReusableCellWithIdentifier:ApprovalStationCellIdentifier forIndexPath:indexPath];
            [self configStationCell:cell atIndexPath:indexPath];
            return cell;
        }
        case ApprovalType_Staff:
        {
            ApprovalStaffCell * cell = [tableView dequeueReusableCellWithIdentifier:ApprovalStaffCellIdentifier forIndexPath:indexPath];
            [self configStaffCell:cell atIndexPath:indexPath];
            return cell;
        }
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.selectedApprovalType) {
        case ApprovalType_Station:
        {
            return [tableView fd_heightForCellWithIdentifier:ApprovalStationCellIdentifier configuration:^(id cell) {
                [self configStationCell:cell atIndexPath:indexPath];
            }];
        }
        case ApprovalType_Staff:
        {
            return [tableView fd_heightForCellWithIdentifier:ApprovalStaffCellIdentifier configuration:^(id cell) {
                [self configStaffCell:cell atIndexPath:indexPath];
            }];
        }
        default:
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentedView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

#pragma mark - config cell

-(void)configStationCell:(ApprovalStationCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)configStaffCell:(ApprovalStaffCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - segmented select view delegate

-(void)segmentedSelectView:(SegmentedSelectView *)view selectIndex:(NSInteger)index{
    self.selectedApprovalType = index;
}

-(SegmentedSelectView *)segmentedView{
    if (!_segmentedView) {
        SegmentedSelectItemModel * model1 = [self getSegmentedItemModelWithName:@"商家审批" isSelected:YES];
        SegmentedSelectItemModel * model2 = [self getSegmentedItemModelWithName:@"员工审批" isSelected:NO];
        _segmentedView = [[SegmentedSelectView alloc]init];
        _segmentedView.modelArray = @[model1,model2];
        _segmentedView.delegate = self;
    }
    return _segmentedView;
}

-(void)setSelectedApprovalType:(ApprovalType)selectedApprovalType{
    if (_selectedApprovalType != selectedApprovalType) {
        _selectedApprovalType = selectedApprovalType;
        [self.tableView reloadData];
    }
}

-(NSArray *)stationApplyList{
    if (!_stationApplyList) {
        ApplyForStation * station1 = [[ApplyForStation alloc]init];
        _stationApplyList = @[station1, station1, station1, station1];
    }
    return _stationApplyList;
}

-(NSArray *)staffApplyList{
    if (!_staffApplyList) {
        ApplyForStaff * staff1 = [[ApplyForStaff alloc]init];
        _staffApplyList = @[staff1, staff1, staff1, staff1];
    }
    return _staffApplyList;
}

#pragma mark - private method

-(SegmentedSelectItemModel *)getSegmentedItemModelWithName:(NSString *)name isSelected:(BOOL)isSelected{
    SegmentedSelectItemModel * model = [[SegmentedSelectItemModel alloc]init];
    model.title = name;
    model.itemIsSelected = isSelected;
    return model;
}

@end
