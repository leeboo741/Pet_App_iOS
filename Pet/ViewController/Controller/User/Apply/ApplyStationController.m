//
//  ApplyStationController.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyStationController.h"
#import "ApplyInputCell.h"
#import "ApplyItemCellModel.h"
#import "ApplyTimeCountCell.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * ApplyTimeCountCellIdentifier = @"ApplyTimeCountCell";

@interface ApplyStationController ()<ApplyInputCellDelegate,ApplyTimeCountCellDelegate>
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> *itemsArray;
@end

@implementation ApplyStationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapCommit)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.title = @"商家入驻申请";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ApplyInputCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApplyTimeCountCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyTimeCountCellIdentifier];
}
#pragma mark - tableview datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    if (cellModel.type == ApplyItemCellType_Input) {
        ApplyInputCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyInputCellIdentifier forIndexPath:indexPath];
        [self configInputCell:cell atIndexPath:indexPath];
        return  cell;
    } else if (cellModel.type == ApplyItemCellType_TimeCount) {
        ApplyTimeCountCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyTimeCountCellIdentifier forIndexPath:indexPath];
        [self configTimeCountCell:cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    if (cellModel.type == ApplyItemCellType_Input) {
        return [tableView fd_heightForCellWithIdentifier:ApplyInputCellIdentifier configuration:^(id cell) {
            [self configInputCell:cell atIndexPath:indexPath];
        }];
    } else if (cellModel.type == ApplyItemCellType_TimeCount){
        return [tableView fd_heightForCellWithIdentifier:ApplyTimeCountCellIdentifier configuration:^(id cell) {
            [self configTimeCountCell:cell atIndexPath:indexPath];
        }];
    }
    return 0;
}

-(void)configInputCell:(ApplyInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    cell.showFlag = cellModel.showFlag;
    cell.cellTitle = cellModel.cellTitle;
    cell.cellValue = cellModel.cellValue;
    cell.cellPlaceholder = cellModel.cellPlaceholder;
    cell.delegate = self;
}

-(void)configTimeCountCell:(ApplyTimeCountCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    cell.showFlag = cellModel.showFlag;
    cell.cellPlaceholder = cellModel.cellPlaceholder;
    cell.cellValue = cellModel.cellValue;
    cell.delegate = self;
}
#pragma mark - timeout cell delegate
-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyTimeCountCell:(ApplyTimeCountCell *)cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 2:
        {
            ApplyItemCellModel * model = self.itemsArray[indexPath.row];
            model.cellValue = text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

-(void)tapTimeCountingAtApplyTimeCountCell:(ApplyTimeCountCell *)cell{
    MSLog(@"点击获取倒计时");
}

#pragma mark - input cell delegate
-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 6:
        case 7:
        {
            ApplyItemCellModel * model = self.itemsArray[indexPath.row];
            model.cellValue = text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

-(BOOL)shouldBeganEditing:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
        case 1:
            return YES;
        case 3:
        {
            MSLog(@"开始时间选择");
            return NO;
        }
        case 4:
        {
            MSLog(@"结束时间选择");
            return NO;
        }
        case 5:
        {
            MSLog(@"区域选择")
            return NO;
        }
        default:
            return YES;
    }
}

#pragma mark - setters and getters
-(NSArray<ApplyItemCellModel *> *)itemsArray{
    if (!_itemsArray){
        ApplyItemCellModel * model1 = [ApplyItemCellModel getCellModelWithTitle:@"商家名称" placeholder:@"请输入商家名称" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model2 = [ApplyItemCellModel getCellModelWithTitle:@"联系人手机" placeholder:@"请输入联系人手机" value:[[UserManager shareUserManager] getPhone]  type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model3 = [ApplyItemCellModel getCellModelWithTitle:@"" placeholder:@"验证码" value:@"" type:ApplyItemCellType_TimeCount showFlag:YES];
        ApplyItemCellModel * model4 = [ApplyItemCellModel getCellModelWithTitle:@"开始营业时间" placeholder:@"开始营业时间" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model5 = [ApplyItemCellModel getCellModelWithTitle:@"结束营业时间" placeholder:@"结束营业时间" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model6 = [ApplyItemCellModel getCellModelWithTitle:@"区域" placeholder:@"省/市/区" value:@"" type:ApplyItemCellType_Input  showFlag:YES];
        ApplyItemCellModel * model7 = [ApplyItemCellModel getCellModelWithTitle:@"详细地址" placeholder:@"详细地址" value:@"" type:ApplyItemCellType_Input  showFlag:YES];
        ApplyItemCellModel * model8 = [ApplyItemCellModel getCellModelWithTitle:@"描述" placeholder:@"描述内容" value:@"" type:ApplyItemCellType_Input showFlag:NO];
        _itemsArray = @[model1,model2,model3,model4,model5,model6,model7,model8];
    }
    return _itemsArray;
}

#pragma mark - event action
-(void)tapCommit{
    MSLog(@"点击提交员工申请:")
    for (ApplyItemCellModel * model in self.itemsArray) {
        MSLog(@"%@",model.cellValue);
    }
}


@end
