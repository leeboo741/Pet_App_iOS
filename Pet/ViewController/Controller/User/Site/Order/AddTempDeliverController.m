//
//  AddTempDeliverController.m
//  Pet
//
//  Created by mac on 2020/3/18.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AddTempDeliverController.h"
#import "ApplyInputCell.h"
#import "ApplyButtonCell.h"
#import "ApplyItemCellModel.h"
#import "DateUtils.h"
#import "CGXPickerView.h"
#import "SelectLocationMapController.h"
#import "SiteOrderManager.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * ApplyButtonCellIdentifier = @"ApplyButtonCell";

@interface AddTempDeliverController () <ApplyInputCellDelegate,ApplyButtonCellDelegate>
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> * itemsArray;
@end

@implementation AddTempDeliverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加临派信息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ApplyInputCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApplyButtonCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyButtonCellIdentifier];

}

#pragma mark - tableview datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.itemsArray.count) {
        ApplyButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyButtonCellIdentifier forIndexPath:indexPath];
        [self configButtonCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        ApplyInputCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyInputCellIdentifier forIndexPath:indexPath];
        [self configInputCell:cell atIndexPath:indexPath];
        return  cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.itemsArray.count) {
        return [tableView fd_heightForCellWithIdentifier:ApplyButtonCellIdentifier configuration:^(id cell) {
            [self configButtonCell:cell atIndexPath:indexPath];
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:ApplyInputCellIdentifier configuration:^(id cell) {
            [self configInputCell:cell atIndexPath:indexPath];
        }];
    }
}
#pragma mark - config cell

-(void)configButtonCell:(ApplyButtonCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
}

-(void)configInputCell:(ApplyInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    cell.showFlag = cellModel.showFlag;
    cell.cellTitle = cellModel.cellTitle;
    cell.cellValue = cellModel.cellValue;
    cell.cellPlaceholder = cellModel.cellPlaceholder;
    cell.delegate = self;
}
#pragma mark - button cell delegate

-(void)tapApplyButton:(ApplyButtonCell *)cell{
    if (kStringIsEmpty(self.order.waitAddTempDelivers.recipientName)) {
        [MBProgressHUD showTipMessageInWindow:@"收件人名称不能为空"];
        return;
    }
    if (kStringIsEmpty(self.order.waitAddTempDelivers.recipientPhone)) {
        [MBProgressHUD showTipMessageInWindow:@"收件人电话不能为空"];
        return;
    }
    if (!Util_IsPhoneString(self.order.waitAddTempDelivers.recipientPhone)) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确电话"];
        return;
    }
    if (kStringIsEmpty(self.order.waitAddTempDelivers.deliverTime)) {
        [MBProgressHUD showTipMessageInWindow:@"派送时间不能为空"];
        return;
    }
    if (kStringIsEmpty(self.order.waitAddTempDelivers.address)) {
        [MBProgressHUD  showTipMessageInWindow:@"派送地址不能为空"];
        return;
    }
    OrderEntity * tempOrder = [[OrderEntity alloc]init];
    tempOrder.orderNo = self.order.orderNo;
    self.order.waitAddTempDelivers.order = tempOrder;
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:@"生成临派单..."];
    [[SiteOrderManager shareSiteOrderManager] addNewTempDeliver:self.order.waitAddTempDelivers success:^(id  _Nonnull data) {
        [MBProgressHUD hideHUD];
        if ([data intValue] > 0) {
            if (weakSelf.successBlock) {
                weakSelf.successBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showErrorMessage:@"新增临派单失败"];
        }
    } fail:^(NSInteger code) {
        
    }];
}
#pragma mark - input cell delegate

-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
        {
            self.order.waitAddTempDelivers.recipientName = text;
        }
            break;
        case 1:
        {
            self.order.waitAddTempDelivers.recipientPhone = text;
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
        case 2:
        {
            NSString * todayStr = [[DateUtils shareDateUtils] getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
            NSDate * maxDate = [[DateUtils shareDateUtils] getDateWithTargetDate:[NSDate date] durationYear:0 durationMonth:1 durationDay:0];
            NSString * maxDateStr = [[DateUtils shareDateUtils]getDateStringWithDate:maxDate withFormatterStr:Formatter_YMD];
            __weak typeof(self) weakSelf = self;
            [CGXPickerView showDatePickerWithTitle:@"派送时间" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:todayStr MaxDateStr:maxDateStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                textField.text = selectValue;
                weakSelf.order.waitAddTempDelivers.deliverTime = selectValue;
            }];
            return NO;
        }
        case 3:
        {
            SelectLocationMapController * mapVC = [[SelectLocationMapController alloc]init];
            mapVC.city = self.order.transport.endCity;
            mapVC.detailAddress = textField.text;
            __weak typeof(self) weakSelf = self;
            mapVC.selectReturnBlock = ^(NSString * _Nonnull city, NSString * _Nonnull detailAddress, CLLocationCoordinate2D coordinate) {
                weakSelf.order.waitAddTempDelivers.address = [NSString stringWithFormat:@"%@%@",city,detailAddress];
                textField.text = detailAddress;
                weakSelf.order.waitAddTempDelivers.latitude = coordinate.latitude;
                weakSelf.order.waitAddTempDelivers.longitude = coordinate.longitude;
            };
            [self.navigationController pushViewController:mapVC animated:YES];
            return NO;
        }
        default:
            return YES;
    }
}

#pragma mark - setters and getters
-(NSArray<ApplyItemCellModel *> *)itemsArray{
    if (!_itemsArray){
        ApplyItemCellModel * model1 = [ApplyItemCellModel getCellModelWithTitle:@"收件人名称" placeholder:@"请输入名称" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model2 = [ApplyItemCellModel getCellModelWithTitle:@"收件人电话" placeholder:@"请输入手机号码" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model3 = [ApplyItemCellModel getCellModelWithTitle:@"派送时间" placeholder:@"请选择派送时间" value:@"" type:ApplyItemCellType_Input showFlag:YES];
        ApplyItemCellModel * model4 = [ApplyItemCellModel getCellModelWithTitle:@"派送地址" placeholder:@"请选择派送地址" value:@"" type:ApplyItemCellType_Input  showFlag:YES];
        _itemsArray = @[model1,model2,model3,model4];
    }
    return _itemsArray;
}

@end
