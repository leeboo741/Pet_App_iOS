//
//  AssignmentsController.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "AssignmentsController.h"
#import "AssignmentsItemCell.h"
#import "SiteOrderManager.h"

static NSString * AssignmentsItemCellIdentifier = @"AssignmentsItemCell";

@interface AssignmentsController ()
@property (nonatomic, strong) NSArray<StaffEntity *> * staffDataSource;
@end

@implementation AssignmentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分配订单";
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapAssignment)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:AssignmentsItemCellIdentifier bundle:nil] forCellReuseIdentifier:AssignmentsItemCellIdentifier];
    [self addObserver:self forKeyPath:@"staffDataSource" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"selectStaffArray" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
    [[SiteOrderManager shareSiteOrderManager] getSiteAllSubStaffSuccess:^(id  _Nonnull data) {
        [MBProgressHUD hideHUD];
        weakSelf.staffDataSource = (NSArray *)data;
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        
    }];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"staffDataSource"];
    [self removeObserver:self forKeyPath:@"selectStaffArray"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"staffDataSource"] || [keyPath isEqualToString:@"selectStaffArray"]) {
        [self compareDataArray];
    }
}
#pragma mark - tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staffDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AssignmentsItemCell * cell = [tableView dequeueReusableCellWithIdentifier:AssignmentsItemCellIdentifier forIndexPath:indexPath];
    [self configCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:AssignmentsItemCellIdentifier configuration:^(id cell) {
        [self configCell:cell atIndexPath:indexPath];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffEntity * staffEntity = self.staffDataSource[indexPath.row];
    staffEntity.assignmented = !staffEntity.assignmented;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - config cell
-(void)configCell:(AssignmentsItemCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    StaffEntity * staff = self.staffDataSource[indexPath.row];
    cell.name = staff.name;
    cell.assignmented = staff.assignmented;
}

#pragma mark - event action
-(void)tapAssignment{
    NSMutableArray * assignmentArray = [NSMutableArray array];
    NSMutableArray * assignmentStaffNoArray = [NSMutableArray array];
    for (StaffEntity * staff in self.staffDataSource) {
        if (staff.assignmented) {
            [assignmentArray addObject:staff];
            [assignmentStaffNoArray addObject:kIntegerNumber([staff.staffNo integerValue])];
        }
    }
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:@"分配中..."];
    [[SiteOrderManager shareSiteOrderManager] assignmentOrder:self.orderNo toStaffs:assignmentStaffNoArray success:^(id  _Nonnull data) {
        [MBProgressHUD hideHUD];
        if (weakSelf.returnBlock) {
            weakSelf.returnBlock(assignmentArray);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSInteger code) {
        
    }];
}

#pragma mark - private method
-(void)compareDataArray{
    for (StaffEntity * staff in self.staffDataSource) {
        staff.assignmented = NO;
        for (StaffEntity * tempStaff in self.selectStaffArray) {
            if ([staff.name isEqualToString:tempStaff.name]) {
                staff.assignmented = YES;
                continue;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - setters and getters
-(NSArray<StaffEntity *> *)staffDataSource{
    if (!_staffDataSource) {
        _staffDataSource = @[];
    }
    return _staffDataSource;
}

-(NSArray<StaffEntity *> *)selectStaffArray{
    if (!_selectStaffArray) {
        _selectStaffArray = @[];
    }
    return _selectStaffArray;
}

@end
