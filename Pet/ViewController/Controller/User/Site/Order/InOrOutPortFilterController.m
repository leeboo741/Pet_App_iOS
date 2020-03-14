//
//  InOrOutPortFilterController.m
//  Pet
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import "InOrOutPortFilterController.h"
#import "ApplyInputCell.h"
#import "ApplyItemCellModel.h"
#import "DateUtils.h"
#import "CGXPickerView.h"

static NSString * ApplyInputCellIdentifier = @"ApplyInputCell";
static NSString * TableViewCellIdentifier = @"UITableViewCell";

@interface InOrOutPortFilterController () <ApplyInputCellDelegate>
@property (nonatomic, strong) NSArray * orderStateArray;
@property (nonatomic, strong) NSArray<ApplyItemCellModel *> * inputArray;
@property (nonatomic, strong) DateUtils * dateUtils;
@end

@implementation InOrOutPortFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"开始筛选" forState:UIControlStateNormal];
    [confirmButton setTitleColor:Color_blue_1 forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton * clearButton = [[UIButton alloc]init];
    [clearButton setTitle:@"清空条件" forState:UIControlStateNormal];
    [clearButton setTitleColor:Color_blue_1 forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearFilter) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithCustomView:confirmButton];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithCustomView:clearButton];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    [self.tableView registerNib:[UINib nibWithNibName:ApplyInputCellIdentifier bundle:nil] forCellReuseIdentifier:ApplyInputCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.orderStateArray.count;
    } else {
        return self.inputArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        ApplyInputCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyInputCellIdentifier forIndexPath:indexPath];
        [self configApplyInputCell:cell atIndexPath:indexPath];
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"订单类型";
    } else if (section == 1){
        return @"订单时间";
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:TableViewCellIdentifier configuration:^(id cell) {
            [self configCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:ApplyInputCellIdentifier configuration:^(id cell) {
            [self configApplyInputCell:cell atIndexPath:indexPath];
        }];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string = self.orderStateArray[indexPath.row];
    if ([self.param.orderTypeArray containsObject:string]) {
        [self.param.orderTypeArray removeObject:string];
    } else {
        [self.param.orderTypeArray addObject:string];
    }
    if (kArrayIsEmpty(self.param.orderTypeArray)) {
        [self.param.orderTypeArray addObject:string];
    }
    [tableView reloadData];
}
#pragma mark - config cell
-(void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString * string = self.orderStateArray[indexPath.row];
    for (NSString * string2 in self.param.orderTypeArray) {
        if ([string isEqualToString:string2]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.textLabel.text = string;
}
-(void)configApplyInputCell:(ApplyInputCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ApplyItemCellModel * model = self.inputArray[indexPath.row];
    cell.cellTitle = model.cellTitle;
    cell.cellValue = model.cellValue;
    cell.cellPlaceholder = model.cellPlaceholder;
    cell.showFlag = model.showFlag;
    cell.delegate = self;
}

#pragma mark - apply input cell delegate
-(BOOL)shouldBeganEditing:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:
        {
            NSDate * lastYear = [self.dateUtils getDateWithTargetDate:[NSDate date] durationYear:-1 durationMonth:0 durationDay:0];
            NSString * lastYearStr = [self.dateUtils getDateStringWithDate:lastYear withFormatterStr:Formatter_YMD];
            NSString * currentYearStr = [self.dateUtils getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
            [CGXPickerView showDatePickerWithTitle:@"下单时间(起始)" DateType:UIDatePickerModeDate DefaultSelValue:lastYearStr MinDateStr:lastYearStr MaxDateStr:currentYearStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.inputArray[indexPath.row];
                model.cellValue = selectValue;
                weakSelf.param.startOrderTime = selectValue;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 1:
        {
            NSDate * lastYear = [self.dateUtils getDateWithTargetDate:[NSDate date] durationYear:-1 durationMonth:0 durationDay:0];
            NSString * lastYearStr = [self.dateUtils getDateStringWithDate:lastYear withFormatterStr:Formatter_YMD];
            NSString * currentYearStr = [self.dateUtils getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
            [CGXPickerView showDatePickerWithTitle:@"下单时间(结束)" DateType:UIDatePickerModeDate DefaultSelValue:lastYearStr MinDateStr:lastYearStr MaxDateStr:currentYearStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.inputArray[indexPath.row];
                model.cellValue = selectValue;
                weakSelf.param.endOrderTime = selectValue;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 2:
        {
            [CGXPickerView showDatePickerWithTitle:@"出发时间(起始)" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.inputArray[indexPath.row];
                model.cellValue = selectValue;
                weakSelf.param.startLeaveTime = selectValue;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        case 3:
        {
            [CGXPickerView showDatePickerWithTitle:@"出发时间(结束)" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                ApplyItemCellModel * model = weakSelf.inputArray[indexPath.row];
                model.cellValue = selectValue;
                weakSelf.param.endLeaveTime = selectValue;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        default:
            break;
    }
    return NO;
}
-(BOOL)shouldChangeText:(NSString *)text withTextField:(UITextField *)textField atApplyInputCell:(ApplyInputCell *)cell{
    return YES;
}

#pragma mark - private method
-(void)confirmAction{
    MSLog(@"%@",[self.param mj_JSONString]);
    if (self.returnBlock) {
        self.returnBlock(self.param);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearFilter{
    [self.param.orderTypeArray removeAllObjects];
    [self.param.orderTypeArray addObjectsFromArray:self.orderStateArray];
    self.param.startOrderTime = @"";
    self.param.startLeaveTime = @"";
    self.param.endOrderTime = @"";
    self.param.endLeaveTime = @"";
    
    ApplyItemCellModel * model = self.inputArray[0];
    model.cellValue = @"";
    ApplyItemCellModel * model1 = self.inputArray[1];
    model1.cellValue = @"";
    ApplyItemCellModel * model2 = self.inputArray[2];
    model2.cellValue = @"";
    ApplyItemCellModel * model3 = self.inputArray[3];
    model3.cellValue = @"";
    
    [self.tableView reloadData];
}

#pragma mark - setters and getters
-(NSArray *)orderStateArray{
    if (self.filterType == InOrOutPortFilter_Type_Out) {
        return @[
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToInport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToOutport],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToPack],
        ];
    } else {
        return @[
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToArrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Arrived],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_Delivering],
            [[SiteOrderManager shareSiteOrderManager] getSiteOrderStateStringWithState:SiteOrderState_ToSign],
        ];
    }
}
-(NSArray<ApplyItemCellModel *> *)inputArray{
    if (!_inputArray) {
        ApplyItemCellModel * model1 = [ApplyItemCellModel getCellModelWithTitle:@"下单时间(起始)" placeholder:@"下单时间(起始)" value:@"" type:ApplyItemCellType_Input showFlag:NO];
        ApplyItemCellModel * model2 = [ApplyItemCellModel getCellModelWithTitle:@"下单时间(结束)" placeholder:@"下单时间(结束)" value:[self.dateUtils getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD] type:ApplyItemCellType_Input showFlag:NO];
        ApplyItemCellModel * model3 = [ApplyItemCellModel getCellModelWithTitle:@"出发时间(起始)" placeholder:@"出发时间(起始)" value:[self.dateUtils getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD] type:ApplyItemCellType_Input showFlag:NO];
        ApplyItemCellModel * model4 = [ApplyItemCellModel getCellModelWithTitle:@"出发时间(结束)" placeholder:@"出发时间(结束)" value:@"" type:ApplyItemCellType_Input showFlag:NO];
        
        _inputArray = @[model1,model2,model3,model4];
    }
    return _inputArray;
}

-(void)setParam:(InOrOutPortRequestParam *)param{
    _param = param;
    if (kStringIsEmpty(param.startOrderTime)) {
        ApplyItemCellModel * model = self.inputArray[0];
        model.cellValue = param.startOrderTime;
    }
    if (kStringIsEmpty(param.endOrderTime)) {
        ApplyItemCellModel * model = self.inputArray[1];
        model.cellValue = param.endOrderTime;
    }
    if (kStringIsEmpty(param.startLeaveTime)) {
        ApplyItemCellModel * model = self.inputArray[2];
        model.cellValue = param.startLeaveTime;
    }
    if (kStringIsEmpty(param.endLeaveTime)) {
        ApplyItemCellModel * model = self.inputArray[3];
        model.cellValue = param.endLeaveTime;
    }
}

-(DateUtils *)dateUtils{
    return [DateUtils shareDateUtils];
}
@end
