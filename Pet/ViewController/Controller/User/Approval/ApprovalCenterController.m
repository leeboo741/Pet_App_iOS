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
#import "ApplyManager.h"
#import "UITableViewController+AddMJRefresh.h"

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
+(ApplyForStation *)getModelByApplyStationModel:(ApplyStationModel *)model;
+(NSArray<ApplyForStation *> *)getModelListByApplyStationModelList:(NSArray <ApplyStationModel *>*)modelList;
@end

@implementation ApplyForStation
+(ApplyForStation *)getModelByApplyStationModel:(ApplyStationModel *)model{
    ApplyForStation * station = [[ApplyForStation alloc]init];
    station.storeName = model.businessName;
    station.contactName = model.phoneNumber;
    station.businessStartTime = model.startBusinessHours;
    station.businessEndTime = model.endBusinessHours;
    station.province = model.province;
    station.city = model.city;
    station.detailAddress = model.detailAddress;
    station.descriptionStr = model.describes;
    return station;
}
+(NSArray<ApplyForStation *> *)getModelListByApplyStationModelList:(NSArray <ApplyStationModel *>*)modelList{
    NSMutableArray * array = [NSMutableArray array];
    for (ApplyStationModel * model in modelList) {
        ApplyForStation * station = [ApplyForStation getModelByApplyStationModel:model];
        [array addObject:station];
    }
    return array;
}
@end

@interface ApplyForStaff : NSObject
@property (nonatomic, copy) NSString * applyNo;
@property (nonatomic, copy) NSString * staffName;
@property (nonatomic, copy) NSString * staffPhone;
+(ApplyForStaff *)getModelByApplyStaffModel:(ApplyStaffModel *)model;
+(NSArray<ApplyForStaff *>*)getModelListByApplyStaffModelList:(NSArray<ApplyStaffModel *>*)modelList;
@end

@implementation ApplyForStaff
+(ApplyForStaff *)getModelByApplyStaffModel:(ApplyStaffModel *)model{
    ApplyForStaff * staff = [[ApplyForStaff alloc]init];
    staff.staffName = model.staffName;
    staff.staffPhone = model.phone;
    return staff;
}
+(NSArray<ApplyForStaff *>*)getModelListByApplyStaffModelList:(NSArray<ApplyStaffModel *>*)modelList{
    NSMutableArray * array = [NSMutableArray array];
    for (ApplyStaffModel * model in modelList) {
        ApplyForStaff * staff = [ApplyForStaff getModelByApplyStaffModel:model];
        [array addObject:staff];
    }
    return array;
}
@end

static NSString * ApprovalStaffCellIdentifier = @"ApprovalStaffCell";
static NSString * ApprovalStationCellIdentifier = @"ApprovalStationCell";

typedef NS_ENUM(NSInteger, ApprovalType) {
    ApprovalType_Station = 0,
    ApprovalType_Staff,
};

@interface ApprovalCenterController ()
<
SegmentedSelectViewDelegate,
ApprovalStaffCellDelegate,
ApprovalStationCellDelegate
>
@property (nonatomic, assign) ApprovalType selectedApprovalType;
@property (nonatomic, strong) SegmentedSelectView * segmentedView;
@property (nonatomic, strong) NSMutableArray * stationApplyList;
@property (nonatomic, strong) NSMutableArray * staffApplyList;

@property (nonatomic, strong) NSMutableArray * stationList;
@property (nonatomic, strong) NSMutableArray * staffList;
@end

@implementation ApprovalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"审批";
    [self.tableView registerNib:[UINib nibWithNibName:ApprovalStationCellIdentifier bundle:nil] forCellReuseIdentifier:ApprovalStationCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApprovalStaffCellIdentifier bundle:nil] forCellReuseIdentifier:ApprovalStaffCellIdentifier];
    [self addRefreshViewWithRefreshAction:@selector(refreshAction)];
    self.selectedApprovalType = ApprovalType_Station;
    [self startRefresh];
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
    ApplyForStation * station = self.stationApplyList[indexPath.row];
    cell.delegate = self;
    cell.stationName = station.storeName;
    cell.phone = station.contactName;
    cell.businessTime = [NSString stringWithFormat:@"%@ - %@",station.businessStartTime, station.businessEndTime];
    cell.describes = station.descriptionStr;
}

-(void)configStaffCell:(ApprovalStaffCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyForStaff * staff = self.staffApplyList[indexPath.row];
    cell.delegate = self;
    cell.name = staff.staffName;
    cell.phone = staff.staffPhone;
}

#pragma mark - station cell delegate
-(void)tapOperateButtonWithType:(OrderOperateButtonType)type atApprovalStationCell:(ApprovalStationCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    ApplyForStation * apply = self.stationApplyList[indexPath.row];
    ApplyStationModel * station = self.stationList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (type == OrderOperateButtonType_Reject) {
        NSLog(@"商家 拒绝 %ld", indexPath.row);
        [self showAlertControllerWithTitle:@"驳回商家申请" msg:[NSString stringWithFormat:@"驳回 %@ 申请",apply.storeName] confirmBlock:^{
            [[ApplyManager shareApplyManager] rejectBusiness:station success:^(id  _Nonnull data) {
                if ([data intValue] == 1) {
                    [MBProgressHUD showTipMessageInWindow:@"驳回成功"];
                    [weakSelf.stationApplyList removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [MBProgressHUD showTipMessageInWindow:@"驳回失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }];
    } else if (type == OrderOperateButtonType_Approval) {
        NSLog(@"商家 批准 %ld", indexPath.row);
        [self showAlertControllerWithTitle:@"批准商家申请" msg:[NSString stringWithFormat:@"批准 %@ 申请",apply.storeName] confirmBlock:^{
            [[ApplyManager shareApplyManager] approveBusiness:station success:^(id  _Nonnull data) {
                if ([data intValue] == 1) {
                    [MBProgressHUD showTipMessageInWindow:@"批准成功"];
                    [weakSelf.stationApplyList removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [MBProgressHUD showTipMessageInWindow:@"批准失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }];
    }
}

#pragma mark - staff cell delegate

-(void)tapOperateButtonWithType:(OrderOperateButtonType)type atApprovalStaffCell:(ApprovalStaffCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    ApplyForStaff * apply = self.staffApplyList[indexPath.row];
    ApplyStaffModel * staff = self.staffList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (type == OrderOperateButtonType_Reject) {
        NSLog(@"员工 拒绝 %ld", indexPath.row);
        [self showAlertControllerWithTitle:@"驳回员工申请" msg:[NSString stringWithFormat:@"驳回 %@ 申请",apply.staffName] confirmBlock:^{
            [[ApplyManager shareApplyManager] rejectStaff:staff success:^(id  _Nonnull data) {
                if ([data intValue] == 1) {
                    [MBProgressHUD showTipMessageInWindow:@"驳回成功"];
                    [weakSelf.staffApplyList removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [MBProgressHUD showTipMessageInWindow:@"驳回失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }];
    } else if (type == OrderOperateButtonType_Approval) {
        NSLog(@"员工 批准 %ld", indexPath.row);
        [self showAlertControllerWithTitle:@"批准员工申请" msg:[NSString stringWithFormat:@"批准 %@ 申请",apply.staffName] confirmBlock:^{
            [[ApplyManager shareApplyManager]approveStaff:staff success:^(id  _Nonnull data) {
                if ([data intValue] == 1) {
                    [MBProgressHUD showTipMessageInWindow:@"批准成功"];
                    [weakSelf.staffApplyList removeObjectAtIndex:indexPath.row];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                } else {
                    [MBProgressHUD showTipMessageInWindow:@"批准失败"];
                }
            } fail:^(NSInteger code) {
                
            }];
        }];
    }
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
        if ((selectedApprovalType == ApprovalType_Station
             && kArrayIsEmpty(self.stationApplyList))
            || (selectedApprovalType == ApprovalType_Staff
                && kArrayIsEmpty(self.staffApplyList))) {
            [self startRefresh];
        } else {
            [self.tableView reloadData];
        }
    }
}

-(NSMutableArray *)stationApplyList{
    if (!_stationApplyList) {
        _stationApplyList = [NSMutableArray array];
    }
    return _stationApplyList;
}

-(NSMutableArray *)stationList{
    if (!_stationList) {
        _stationList = [NSMutableArray array];
    }
    return _stationList;
}

-(NSMutableArray *)staffApplyList{
    if (!_staffApplyList) {
        _staffApplyList = [NSMutableArray array];
    }
    return _staffApplyList;
}

-(NSMutableArray *)staffList{
    if (!_staffList) {
        _staffList = [NSMutableArray array];
    }
    return _staffList;
}

#pragma mark - private method

-(void)refreshAction{
    [self getDataWithType:self.selectedApprovalType];
}

-(void)getDataWithType:(ApprovalType)type{
    __weak typeof(self) weakSelf = self;
    if (type == ApprovalType_Station) {
        [[ApplyManager shareApplyManager] getUnauditedBusinessListByCustomerNo:[[UserManager shareUserManager] getCustomerNo] success:^(id  _Nonnull data) {
            [weakSelf endRefresh];
            NSArray * array = [ApplyForStation getModelListByApplyStationModelList: (NSArray *)data];
            [weakSelf.stationApplyList removeAllObjects];
            [weakSelf.stationApplyList addObjectsFromArray:array];
            [weakSelf.stationList removeAllObjects];
            [weakSelf.stationList addObjectsFromArray:(NSArray *)data];
            [weakSelf.tableView reloadData];
        } fail:^(NSInteger code) {
            [weakSelf endRefresh];
        }];
    } else {
        [[ApplyManager shareApplyManager] getUnauditedStaffListByCustomerNo:[[UserManager shareUserManager] getCustomerNo] success:^(id  _Nonnull data) {
            [weakSelf endRefresh];
            NSArray * array = [ApplyForStaff getModelListByApplyStaffModelList:(NSArray *)data];
            [weakSelf.staffApplyList removeAllObjects];
            [weakSelf.staffApplyList addObjectsFromArray:array];
            [weakSelf.staffList removeAllObjects];
            [weakSelf.staffList addObjectsFromArray:(NSArray *)data];
            [weakSelf.tableView reloadData];
        } fail:^(NSInteger code) {
            [weakSelf endRefresh];
        }];
    }
}

-(SegmentedSelectItemModel *)getSegmentedItemModelWithName:(NSString *)name isSelected:(BOOL)isSelected{
    SegmentedSelectItemModel * model = [[SegmentedSelectItemModel alloc]init];
    model.title = name;
    model.itemIsSelected = isSelected;
    return model;
}

-(void)showAlertControllerWithTitle:(NSString *)title msg:(NSString *)msg confirmBlock:(void(^)(void))confirmBlock {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionConfirm];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
