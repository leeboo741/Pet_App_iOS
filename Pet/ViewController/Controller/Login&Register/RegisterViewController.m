//
//  RegisterViewController.m
//  Pet
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "ApplyTimeCountCell.h"
#import "ApplyInputCell.h"
#import "ApplyItemCellModel.h"
#import "ApplyButtonCell.h"
#import "CommonManager.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * ApplyTimeCountCellIdentifier = @"ApplyTimeCountCell";
static NSString * ApplyButtonCellIdentifier = @"ApplyButtonCell";

@interface RegisterViewController ()<ApplyInputCellDelegate,ApplyTimeCountCellDelegate,ApplyButtonCellDelegate>
@property (nonatomic, copy) NSString * jsessionid;
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> *itemsArray;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapCommit)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.title = @"注册";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ApplyInputCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApplyTimeCountCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyTimeCountCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ApplyButtonCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyButtonCellIdentifier];
}

#pragma mark - tableview datasource and delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.itemsArray.count) {
        ApplyButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyButtonCellIdentifier forIndexPath:indexPath];
        [self configButtonCell:cell atIndexPath:indexPath];
        return cell;
    }
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
    return self.itemsArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.itemsArray.count) {
        return [tableView fd_heightForCellWithIdentifier:ApplyButtonCellIdentifier configuration:^(id cell) {
            [self configButtonCell:cell atIndexPath:indexPath];
        }];
    }
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

-(void)configTimeCountCell:(ApplyTimeCountCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * cellModel = self.itemsArray[indexPath.row];
    cell.showFlag = cellModel.showFlag;
    cell.cellPlaceholder = cellModel.cellPlaceholder;
    cell.cellValue = cellModel.cellValue;
    cell.delegate = self;
}

#pragma mark - button cell delegate

-(void)tapApplyButton:(ApplyButtonCell *)cell{
    [self tapCommit];
}

#pragma mark - timeout cell delegate

-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyTimeCountCell:(ApplyTimeCountCell *)cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 2:
        {
            self.registerUserInfo.verificationCode = text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

-(void)tapTimeCountingAtApplyTimeCountCell:(ApplyTimeCountCell *)cell{
    MSLog(@"点击获取倒计时");
    __weak typeof(self) weakSelf = self;
    ApplyItemCellModel * model = self.itemsArray[1];
    [[CommonManager shareCommonManager] getPhoneCodeByPhoneNumber:self.registerUserInfo.phone success:^(id  _Nonnull data) {
        [MBProgressHUD showTipMessageInWindow:@"短信发送成功"];
    } fail:^(NSInteger code) {
        
    } jsessionidReturnBlock:^(NSString * _Nonnull jsessionid) {
        weakSelf.jsessionid = jsessionid;
    }];
}

#pragma mark - input cell delegate

-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
        {
            self.registerUserInfo.nickName = text;
        }
            break;
        case 1:
        {
            self.registerUserInfo.phone = text;
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
        {
            return YES;
        }
            break;
        case 1:
        {
            return YES;
        }
            break;
        case 3:
        {
            __weak typeof(self) weakSelf = self;
            ApplyItemCellModel * model = self.itemsArray[indexPath.row];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakSelf.registerUserInfo.sex = SEX_MALE;
                model.cellValue = weakSelf.registerUserInfo.sexStr;
                [weakSelf.tableView reloadData];
            }];
            UIAlertAction * femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakSelf.registerUserInfo.sex = SEX_FEMALE;
                model.cellValue = weakSelf.registerUserInfo.sexStr;
                [weakSelf.tableView reloadData];
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
            break;
        default:
            return YES;
    }
}


#pragma mark - setters and getters

-(RegisterUserInfo *)registerUserInfo{
    if (_registerUserInfo == nil) {
        _registerUserInfo = [[RegisterUserInfo alloc]init];
    }
    return _registerUserInfo;
}

-(NSArray<ApplyItemCellModel *> *)itemsArray{
    if (!_itemsArray){
        NSString * nickName = @"";
        if (!kStringIsEmpty(self.registerUserInfo.nickName)) {
            nickName = self.registerUserInfo.nickName;
        }
        ApplyItemCellModel * model1 = [ApplyItemCellModel getCellModelWithTitle:@"昵称" placeholder:@"请输入昵称" value:nickName type:ApplyItemCellType_Input showFlag:YES];
        
        NSString * phone = @"";
        if (!kStringIsEmpty(self.registerUserInfo.phone)) {
            phone = self.registerUserInfo.phone;
        }
        ApplyItemCellModel * model2 = [ApplyItemCellModel getCellModelWithTitle:@"手机" placeholder:@"请输入手机号码" value:phone type:ApplyItemCellType_Input showFlag:YES];
        
        
        ApplyItemCellModel * model3 = [ApplyItemCellModel getCellModelWithTitle:@"" placeholder:@"验证码" value:@"" type:ApplyItemCellType_TimeCount showFlag:YES];
        
        ApplyItemCellModel * model4 = [ApplyItemCellModel getCellModelWithTitle:@"性别" placeholder:@"请输入性别" value:self.registerUserInfo.sexStr type:ApplyItemCellType_Input  showFlag:YES];
        _itemsArray = @[model1,model2,model3,model4];
    }
    return _itemsArray;
}

-(NSString *)jsessionid{
    return _jsessionid;
}

#pragma mark - event action
-(void)tapCommit{
    MSLog(@"点击提交员工申请:");
    if (kStringIsEmpty(self.jsessionid)) {
        [MBProgressHUD showTipMessageInWindow:@"请点击获取验证码"];
        return;
    }
    if ([self isSafeData:self.registerUserInfo]) {
        [[UserManager shareUserManager] registerUser:self.registerUserInfo jsessionid:self.jsessionid success:^(id  _Nonnull data) {
            [AlertControllerTools showAlertWithTitle:@"注册成功" msg:@"您已成功注册淘宠惠账号,请前往登录." items:@[@"前往登录"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } fail:^(NSInteger code) {
            
        }];
    }
}

#pragma mark - private method

-(BOOL)isSafeData:(RegisterUserInfo *)userInfo{
    if (kStringIsEmpty(userInfo.nickName)) {
        [MBProgressHUD showTipMessageInWindow:@"昵称不能为空"];
        return NO;
    }
    if (kStringIsEmpty(userInfo.phone) || !Util_IsPhoneString(userInfo.phone)) {
        [MBProgressHUD showTipMessageInWindow:@"请填写正确手机号码"];
        return NO;
    }
    if (kStringIsEmpty(userInfo.verificationCode)) {
        [MBProgressHUD showTipMessageInWindow:@"验证码不能为空"];
        return NO;
    }
    return YES;
}
@end
