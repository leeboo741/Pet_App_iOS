//
//  AssignmentsController.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "AssignmentsController.h"
#import "AssignmentsItemCell.h"

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
    for (StaffEntity * staff in self.staffDataSource) {
        if (staff.assignmented) {
            [assignmentArray addObject:staff];
        }
    }
    if (self.returnBlock) {
        self.returnBlock(assignmentArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        StaffEntity * staff1 = [[StaffEntity alloc]init];
        staff1.name = @"测试1";
        StaffEntity * staff2 = [[StaffEntity alloc]init];
        staff2.name = @"测试2";
        StaffEntity * staff3 = [[StaffEntity alloc]init];
        staff3.name = @"测试3";
        StaffEntity * staff4 = [[StaffEntity alloc]init];
        staff4.name = @"测试4";
        
        _staffDataSource = @[staff1,staff2,staff3,staff4];
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
