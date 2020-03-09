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
#import "CGXPickerView.h"
#import "CommonManager.h"
#import "ApplyManager.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * ApplyTimeCountCellIdentifier = @"ApplyTimeCountCell";

@interface ApplyStationController ()<ApplyInputCellDelegate,ApplyTimeCountCellDelegate>
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> *itemsArray;
@property (nonatomic, strong) NSArray * selectAddressRow;
@property (nonatomic, strong) NSArray * selectAddressArray;
@property (nonatomic, copy) NSString * jsessionId;
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
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    __weak typeof(self) weakSelf = self;
    ApplyItemCellModel * model = self.itemsArray[1];
    [[CommonManager shareCommonManager] getPhoneCodeByPhoneNumber:model.cellValue success:^(id  _Nonnull data) {
        [MBProgressHUD showTipMessageInWindow:@"短信发送成功"];
    } fail:^(NSInteger code) {
        [MBProgressHUD showTipMessageInWindow:@"短信发送失败"];
    } jsessionidReturnBlock:^(NSString * _Nonnull jsessionid) {
        weakSelf.jsessionId = jsessionid;
    }];
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
            __weak typeof(self) weakSelf = self;
            [CGXPickerView showDatePickerWithTitle:@"开始时间" DateType:UIDatePickerModeTime DefaultSelValue:nil MinDateStr:@"00:00" MaxDateStr:@"23:59" IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.itemsArray[indexPath.row];
                model.cellValue = selectValue;
                [weakSelf.tableView reloadData];
            }];
            return NO;
        }
        case 4:
        {
            MSLog(@"结束时间选择");
            __weak typeof(self) weakSelf = self;
            [CGXPickerView showDatePickerWithTitle:@"结束时间" DateType:UIDatePickerModeTime DefaultSelValue:nil MinDateStr:@"00:00" MaxDateStr:@"23:59" IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.itemsArray[indexPath.row];
                model.cellValue = selectValue;
                [weakSelf.tableView reloadData];
            }];
            return NO;
        }
        case 5:
        {
            MSLog(@"区域选择")
            __weak typeof(self) weakSelf = self;
            [CGXPickerView showAddressPickerWithTitle:@"选择区域" DefaultSelected:self.selectAddressRow FileName:@"CGXAddressCity.plist" IsAutoSelect:NO Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
                ApplyItemCellModel * model = weakSelf.itemsArray[indexPath.row];
                model.cellValue = [NSString stringWithFormat:@"%@%@",selectAddressArr[0],selectAddressArr[1]];
                weakSelf.selectAddressRow = selectAddressRow;
                weakSelf.selectAddressArray = selectAddressArr;
                [weakSelf.tableView reloadData];
            }];
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

-(NSArray *)selectAddressRow{
    if (!_selectAddressRow) {
        _selectAddressRow = @[@0,@0,@0];
    }
    return _selectAddressRow;
}

#pragma mark - data request

-(void)requestApply{
    ApplyStationModel * applyModel = [[ApplyStationModel alloc]init];
    ApplyItemCellModel * cellModel1 = self.itemsArray[0];
    applyModel.businessName = cellModel1.cellValue;
    ApplyItemCellModel * cellModel2 = self.itemsArray[1];
    applyModel.phoneNumber = cellModel2.cellValue;
    ApplyItemCellModel * cellModel3 = self.itemsArray[2];
    applyModel.verificationCode = cellModel3.cellValue;
    ApplyItemCellModel * cellModel4 = self.itemsArray[3];
    applyModel.startBusinessHours = cellModel4.cellValue;
    ApplyItemCellModel * cellModel5 = self.itemsArray[4];
    applyModel.endBusinessHours = cellModel5.cellValue;
    applyModel.province = self.selectAddressArray[0];
    applyModel.city = self.selectAddressArray[1];
    ApplyItemCellModel * cellModel6 = self.itemsArray[6];
    applyModel.detailAddress = cellModel6.cellValue;
    ApplyItemCellModel * cellModel7 = self.itemsArray[7];
    applyModel.describes = cellModel7.cellValue;
    applyModel.jsessionId = self.jsessionId;
    if ([self isSafeApplyModel:applyModel]) {
        [MBProgressHUD showActivityMessageInWindow:@"提交中..."];
        __weak typeof(self) weakSelf = self;
        [[ApplyManager shareApplyManager] requestStationApply:applyModel success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            [AlertControllerTools showAlertWithTitle:@"提交成功" msg:@"商家申请已经成功提交,请等待审核" items:@[@"确定"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } fail:^(NSInteger code) {
            
        }];
    }
}

#pragma mark - private method

-(BOOL)isSafeApplyModel:(ApplyStationModel *)model{
    if (kStringIsEmpty(model.businessName)) {
        [MBProgressHUD showErrorMessage:@"商家名称不能为空"];
        return NO;
    }
    if (kStringIsEmpty(model.phoneNumber) || !Util_IsPhoneString(model.phoneNumber)) {
        [MBProgressHUD showErrorMessage:@"请填写正确手机号码"];
        return NO;
    }
    if (kStringIsEmpty(model.jsessionId)) {
        [MBProgressHUD showErrorMessage:@"请点击获取短信验证码"];
        return NO;
    }
    if (kStringIsEmpty(model.startBusinessHours)) {
        [MBProgressHUD showErrorMessage:@"请选择开始营业时间"];
        return NO;
    }
    if (kStringIsEmpty(model.endBusinessHours)) {
        [MBProgressHUD showErrorMessage:@"请选择结束营业时间"];
        return NO;
    }
    if (kStringIsEmpty(model.province) || kStringIsEmpty(model.city)) {
        [MBProgressHUD showErrorMessage:@"请选择区域"];
        return NO;
    }
    if (kStringIsEmpty(model.detailAddress)) {
        [MBProgressHUD showErrorMessage:@"请输入详细地址"];
        return NO;
    }
    if (kStringIsEmpty(model.verificationCode)) {
        [MBProgressHUD showErrorMessage:@"请填写验证码"];
        return NO;
    }
    return YES;
}

#pragma mark - event action
-(void)tapCommit{
    MSLog(@"点击提交员工申请:")
    for (ApplyItemCellModel * model in self.itemsArray) {
        MSLog(@"%@",model.cellValue);
    }
    [self requestApply];
}


@end
