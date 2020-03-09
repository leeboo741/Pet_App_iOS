//
//  ApplyStaffController.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyStaffController.h"
#import "ApplyInputCell.h"
#import "ApplyItemCellModel.h"
#import "ApplyTimeCountCell.h"
#import "CommonManager.h"
#import "CGXPickerView.h"
#import "StationManager.h"
#import "AlertControllerTools.h"
#import "ApplyManager.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * ApplyTimeCountCellIdentifier = @"ApplyTimeCountCell";

@interface ApplyStaffController ()<ApplyInputCellDelegate,ApplyTimeCountCellDelegate>
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> *itemsArray;
@property (nonatomic, strong) NSArray * selectAddressRow;
@property (nonatomic, strong) NSArray * selectAddressArray;
@property (nonatomic, strong) NSArray * stationList;
@property (nonatomic, strong) StationModel * selectStation;
@property (nonatomic, copy) NSString * jsessionId;
@end

@implementation ApplyStaffController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapCommit)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.title = @"员工入驻申请";
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

#pragma mark - config cell

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
    ApplyItemCellModel * model = self.itemsArray[1];
    __weak typeof(self) weakSelf = self;
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
        {
            ApplyItemCellModel * model = self.itemsArray[indexPath.row];
            model.cellValue = text;
        }
            break;
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

-(BOOL)shouldBeganEditing:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            return YES;
        case 1:
            return NO;
        case 3:
        {
            NSLog(@"区域选择");
            __weak typeof(self) weakSelf = self;
            [CGXPickerView showAddressPickerWithTitle:@"选择区域" DefaultSelected:self.selectAddressRow FileName:@"CGXAddressCity.plist" IsAutoSelect:NO Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
                ApplyItemCellModel * model = weakSelf.itemsArray[indexPath.row];
                model.cellValue = [NSString stringWithFormat:@"%@%@",selectAddressArr[0],selectAddressArr[1]];
                weakSelf.selectAddressRow = selectAddressRow;
                weakSelf.selectAddressArray = selectAddressArr;
                [weakSelf.tableView reloadData];
                [weakSelf getStationListWithProvince:selectAddressArr[0] city:selectAddressArr[1]];
            }];
            return NO;
        }
        case 4:
        {
            NSLog(@"站点选择");
            if (kArrayIsEmpty(self.selectAddressArray)) {
                [MBProgressHUD showTipMessageInWindow:@"请先选择区域"];
                return NO;
            }
            if (kArrayIsEmpty(self.stationList)) {
                [MBProgressHUD showTipMessageInWindow:@"当前区域未能找到站点"];
                return NO;
            }
            NSMutableArray * stationItemList = [NSMutableArray array];
            for (StationModel * model in self.stationList) {
                [stationItemList addObject:model.stationName];
            }
            __weak typeof(self) weakSelf = self;
            [AlertControllerTools showActionSheetWithTitle:@"选择站点" msg:nil items:stationItemList showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                weakSelf.selectStation = weakSelf.stationList[actionIndex];
            }];
            return NO;
        }
        default:
            return YES;
    }
}

#pragma mark - data request

-(void)getStationListWithProvince:(NSString *)province city:(NSString *)city {
    [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    [[StationManager shareStationManager] getStationListWithProvince:province city:city success:^(id  _Nonnull data) {
        [MBProgressHUD hideHUD];
        weakSelf.stationList = (NSArray *)data;
        if (!kArrayIsEmpty(weakSelf.stationList)) {
            weakSelf.selectStation = weakSelf.stationList[0];
        }
    } fail:^(NSInteger code) {
        [MBProgressHUD hideHUD];
    }];
}

-(void)requestApply{
    ApplyStaffModel * model = [[ApplyStaffModel alloc]init];
    model.customerNo = [[UserManager shareUserManager]getCustomerNo];
    ApplyItemCellModel * cellModel1 = self.itemsArray[0];
    model.staffName = cellModel1.cellValue;
    ApplyItemCellModel * cellModel2 = self.itemsArray[1];
    model.phone = cellModel2.cellValue;
    ApplyItemCellModel * cellModel3 = self.itemsArray[2];
    model.verificationCode = cellModel3.cellValue;
    model.station = self.selectStation;
    model.jsessionId = self.jsessionId;
    if ([self isSafeDataWithApplyModel:model]) {
        [MBProgressHUD showActivityMessageInWindow:@"提交中..."];
        __weak typeof(self) weakSelf = self;
        [[ApplyManager shareApplyManager] requestStaffApply:model success:^(id  _Nonnull data) {
            [MBProgressHUD hideHUD];
            [AlertControllerTools showAlertWithTitle:@"提价成功" msg:@"您已成功提交员工申请,请耐心等待审核" items:@[@"确定"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } fail:^(NSInteger code) {
            
        }];
    }
}

#pragma mark - setters and getters
-(NSArray<ApplyItemCellModel *> *)itemsArray{
    if (!_itemsArray){
        ApplyItemCellModel * model1 = [ApplyItemCellModel getCellModelWithTitle:@"员工名称" placeholder:@"请输入姓名" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model2 = [ApplyItemCellModel getCellModelWithTitle:@"员工手机" placeholder:@"请输入员工手机" value:[[UserManager shareUserManager] getPhone]  type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model3 = [ApplyItemCellModel getCellModelWithTitle:@"" placeholder:@"验证码" value:@"" type:ApplyItemCellType_TimeCount showFlag:YES];
        ApplyItemCellModel * model4 = [ApplyItemCellModel getCellModelWithTitle:@"区域" placeholder:@"省/市/区" value:@"" type:ApplyItemCellType_Input  showFlag:YES];
        ApplyItemCellModel * model5 = [ApplyItemCellModel getCellModelWithTitle:@"站点" placeholder:@"选择站点(请先选择区域)" value:@"" type:ApplyItemCellType_Input  showFlag:YES];
        _itemsArray = @[model1,model2,model3,model4,model5];
    }
    return _itemsArray;
}

-(NSArray *)selectAddressRow{
    if (!_selectAddressRow) {
        _selectAddressRow = @[@0,@0,@0];
    }
    return _selectAddressRow;
}

-(void)setSelectStation:(StationModel *)selectStation{
    _selectStation = selectStation;
    ApplyItemCellModel * model = self.itemsArray[4];
    model.cellValue = selectStation.stationName;
    [self.tableView reloadData];
}

#pragma mark - event action
-(void)tapCommit{
    MSLog(@"点击提交员工申请:");
    for (ApplyItemCellModel * model in self.itemsArray) {
        MSLog(@"%@",model.cellValue);
    }
    [self requestApply];
}

#pragma mark - private method

-(BOOL)isSafeDataWithApplyModel:(ApplyStaffModel *)model{
    if (kStringIsEmpty(model.customerNo)) {
        [MBProgressHUD showTipMessageInWindow:@"customerNo 为空"];
        return NO;
    }
    if (kStringIsEmpty(model.staffName)) {
        [MBProgressHUD showTipMessageInWindow:@"员工名称不能为空"];
        return NO;
    }
    if (kStringIsEmpty(model.phone) || !Util_IsPhoneString(model.phone)) {
        [MBProgressHUD showTipMessageInWindow:@"请填写正确手机号码"];
        return NO;
    }
    if (kStringIsEmpty(model.jsessionId)) {
        [MBProgressHUD showTipMessageInWindow:@"请点击获取短信验证码"];
        return NO;
    }
    if (!model.station) {
        [MBProgressHUD showTipMessageInWindow:@"站点不能为空"];
        return NO;
    }
    return YES;
}





@end
