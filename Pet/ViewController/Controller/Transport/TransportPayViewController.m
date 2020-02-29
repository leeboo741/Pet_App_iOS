//
//  TransportPayViewController.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportPayViewController.h"
#import "TransportOrderFooterView.h"
#import "TransportOrder.h"
#import "TransportPayPersonnelCell.h"
#import "TransportPayRemarkCell.h"
#import "TransportPayPetConditionConfirmCell.h"
#import "TransportPayContractConfirmCell.h"
#import "PaymentViewController.h"

static NSString * PersonnelCellName = @"TransportPayPersonnelCell";
static NSString * PersonnelCellIdentifier = @"PersonnelCellIdentifier";

static NSString * RemarkCellName = @"TransportPayRemarkCell";
static NSString * RemarkCellIdentifier = @"RemarkCellIdentifier";

static NSString * PetConditionConfirmCellName = @"TransportPayPetConditionConfirmCell";
static NSString * PetConditionConfirmCellIdentifier = @"PetConditionConfirmCellIdentifier";

static NSString * ContractConfirmCellName = @"TransportPayContractConfirmCell";
static NSString * ContractConfirmCellIdentifier = @"ContractConfirmCellIdentifier";

@interface TransportPayViewController ()
<TransportOrderFooterViewDelegate,
TransportPayPersonnelCellDelegate,
TransportPayRemarkCellDelegate,
TransportPayPetConditionConfirmCellDelegate,
TransportPayContractConfirmCellDelegate>

@property (nonatomic, strong) TransportOrder * transportOrder;

@property (nonatomic, strong) TransportOrderFooterView * footerView;
@property (nonatomic, assign) CGFloat footerY;

@property (nonatomic, assign) BOOL isConfirmCondition;
@property (nonatomic, assign) BOOL isConfirmContract;

@end

@implementation TransportPayViewController
#pragma mark - life cycle
-(instancetype)initWithTransportOrder:(TransportOrder *)order{
    self = [super init];
    if (self) {
        self.transportOrder = order;
        self.isConfirmCondition = NO;
        self.isConfirmContract = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"托运订单";
    [self.tableView registerNib:[UINib nibWithNibName:PersonnelCellName bundle:nil] forCellReuseIdentifier:PersonnelCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCellName bundle:nil] forCellReuseIdentifier:RemarkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PetConditionConfirmCellName bundle:nil] forCellReuseIdentifier:PetConditionConfirmCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ContractConfirmCellName bundle:nil] forCellReuseIdentifier:ContractConfirmCellIdentifier];
    self.tableView.backgroundColor = Color_gray_1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self footerView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView bringSubviewToFront:_footerView];
}

#pragma mark - tableview datasource and delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerY + self.tableView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TransportPayPersonnelCell * cell = [tableView dequeueReusableCellWithIdentifier:PersonnelCellIdentifier forIndexPath:indexPath];
        [self configPersonnelCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        TransportPayRemarkCell * cell = [tableView dequeueReusableCellWithIdentifier:RemarkCellIdentifier forIndexPath:indexPath];
        [self configRemarkCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        TransportPayPetConditionConfirmCell * cell = [tableView dequeueReusableCellWithIdentifier:PetConditionConfirmCellIdentifier forIndexPath:indexPath];
        [self configPetConditionCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3) {
        TransportPayContractConfirmCell * cell = [tableView dequeueReusableCellWithIdentifier:ContractConfirmCellIdentifier forIndexPath:indexPath];
        [self configContractCell:cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:PersonnelCellIdentifier configuration:^(id cell) {
            [self configPersonnelCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:RemarkCellIdentifier configuration:^(id cell) {
            [self configRemarkCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:PetConditionConfirmCellIdentifier configuration:^(id cell) {
            [self configPetConditionCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 3) {
        return [tableView fd_heightForCellWithIdentifier:ContractConfirmCellIdentifier configuration:^(id cell) {
            [self configContractCell:cell atIndexPath:indexPath];
        }];
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * sectionFooter = [[UIView alloc]init];
    return sectionFooter;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        if (IS_IPHONE_X_orMore) {
            return 60;
        }
        return 80;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    view.backgroundColor = Color_gray_1;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 30)];
    [view addSubview:label];
    label.backgroundColor = Color_gray_1;
    if (section == 0) {
        label.text = @"人员信息";
    } else if (section == 1) {
        label.text = @"备注信息";
    } else if (section == 2) {
        label.text = @"条件确认";
    } else {
        label.text = @"条款确认";
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - personnel cell delegate

-(BOOL)transportPayPersonnelCell:(TransportPayPersonnelCell *)cell changeText:(NSString *)text textFieldType:(TransportPayPersonnelCell_TextFieldType)type{
    if (type == TransportPayPersonnelCell_TextFieldType_SenderName) {
        self.transportOrder.senderName = text;
    } else if (type == TransportPayPersonnelCell_TextFieldType_SenderPhone) {
        self.transportOrder.senderPhone = text;
    } else if (type == TransportPayPersonnelCell_TextFieldType_ReceiverName) {
        self.transportOrder.receiverName = text;
    } else {
        self.transportOrder.receiverPhone = text;
    }
    return YES;
}

-(void)transportPayPersonnelCell:(TransportPayPersonnelCell *)cell didEndEditingTextFieldType:(TransportPayPersonnelCell_TextFieldType)type{
    if (type == TransportPayPersonnelCell_TextFieldType_SenderPhone) {
        if (!Util_IsPhoneString(self.transportOrder.senderPhone)) {
            self.transportOrder.senderPhone = @"";
        }
    } else if (type == TransportPayPersonnelCell_TextFieldType_ReceiverPhone) {
        if (!Util_IsPhoneString(self.transportOrder.senderPhone)) {
            self.transportOrder.receiverPhone = @"";
        }
    }
}

#pragma mark - remark cell delegate

-(BOOL)transportPayRemarkCell:(TransportPayRemarkCell *)cell textView:(UITextView *)textView changeText:(NSString *)text{
    self.transportOrder.remark = text;
    return YES;
}

#pragma mark - pet condition delegate

-(void)transportPayPetConditionConfirmCellTapConfirmButton:(TransportPayPetConditionConfirmCell *)cell{
    self.isConfirmCondition = !self.isConfirmCondition;
    [self.tableView reloadData];
}

#pragma mark - contract delegate

-(void)transportPayContractConfirmCellTapConfirm:(TransportPayContractConfirmCell *)cell{
    self.isConfirmContract = !self.isConfirmContract;
    [self.tableView reloadData];
}

#pragma mark - transport footer view delegate

-(void)transportOrderFooterTapCall {
    MSLog(@"点击客服电话");
}

-(void)transportOrderFooterTapOrder{
    MSLog(@"点击提交");
    PaymentViewController * paymentVC = [[PaymentViewController alloc]init];
    paymentVC.paymentPrice = 32.0f;
    [self.navigationController pushViewController:paymentVC animated:YES];
}

#pragma mark - config cell

-(void)configPersonnelCell:(TransportPayPersonnelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.senderName = self.transportOrder.senderName;
    cell.senderPhone = self.transportOrder.senderPhone;
    cell.receiverName = self.transportOrder.receiverName;
    cell.receiverPhone = self.transportOrder.receiverPhone;
}

-(void)configRemarkCell:(TransportPayRemarkCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.remark = self.transportOrder.remark;
}

-(void)configPetConditionCell:(TransportPayPetConditionConfirmCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.isConfirm = self.isConfirmCondition;
}

-(void)configContractCell:(TransportPayContractConfirmCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.isConfirm = self.isConfirmContract;
}

#pragma mark - private method


#pragma mark - setters and getters
-(TransportOrderFooterView *)footerView{
    if (!_footerView) {
        if (IS_IPHONE_X_orMore) {
            _footerView = [[TransportOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height-40, self.tableView.frame.size.width, 80)];
        } else {
            _footerView = [[TransportOrderFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height-60, self.tableView.frame.size.width, 80)];
        }
        self.footerY = _footerView.frame.origin.y;
        _footerView.delegate = self;
        _footerView.type = TransportOrderFooterView_Type_Commit;
        _footerView.price = @"0";
        [self.tableView addSubview:_footerView];
        [self.tableView bringSubviewToFront:_footerView];
    }
    return _footerView;
}

@end
