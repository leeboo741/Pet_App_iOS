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
#import "OrderManager.h"
#import "PayManager.h"
#import "PrivacyPolicyView.h"

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
TransportPayContractConfirmCellDelegate,
PrivacyPolicyViewDelegate>


@property (nonatomic, strong) PrivacyPolicyView * privacyPolicyView;

@property (nonatomic, strong) TransportOrder * transportOrder;

@property (nonatomic, strong) TransportOrderFooterView * footerView;
@property (nonatomic, copy) NSString * predictPrice;
@property (nonatomic, assign) CGFloat footerY;

@property (nonatomic, assign) BOOL isConfirmCondition;
@property (nonatomic, assign) BOOL isConfirmContract;

@property (nonatomic, assign) BOOL payComplete;

@end

@implementation TransportPayViewController
#pragma mark - life cycle
-(instancetype)initWithTransportOrder:(TransportOrder *)order predictPrice:(nonnull NSString *)price{
    self = [super init];
    if (self) {
        self.predictPrice = price;
        self.transportOrder = order;
        self.isConfirmCondition = NO;
        self.isConfirmContract = NO;
        self.payComplete = NO;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.payComplete) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
#pragma mark - privacyPolicy view delegate
-(void)privacyPolicyViewTapButtonAction:(PrivacyPolicyButtonType)buttonType{
    if (buttonType == PrivacyPolicyButtonType_Disagree) {
        self.isConfirmContract = NO;
    } else if (buttonType == PrivacyPolicyButtonType_Agree) {
        self.isConfirmContract = YES;
    } else {
        
    }
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

#pragma mark - transport footer view delegate

-(void)transportOrderFooterTapCall {
    MSLog(@"点击客服电话");
}

-(void)transportOrderFooterTapOrder{
    MSLog(@"点击提交");
    if (kStringIsEmpty(self.transportOrder.senderName)) {
        [MBProgressHUD showTipMessageInWindow:@"寄件人姓名不能为空"];
        return;
    }
    if (kStringIsEmpty(self.transportOrder.senderPhone)) {
        [MBProgressHUD showTipMessageInWindow:@"寄件人电话不能为空"];
        return;
    }
    if (kStringIsEmpty(self.transportOrder.receiverName)) {
        [MBProgressHUD showTipMessageInWindow:@"收件人姓名不能为空"];
        return;
    }
    if (kStringIsEmpty(self.transportOrder.receiverPhone)) {
        [MBProgressHUD showTipMessageInWindow:@"收件人电话不能为空"];
        return;
    }
    if (!self.isConfirmCondition) {
        [MBProgressHUD showTipMessageInWindow:@"请确认条件"];
        return;
    }
    if (!self.isConfirmContract) {
        [MBProgressHUD showTipMessageInWindow:@"请确认条款"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] createOrderWithOrderEntity:self.transportOrder success:^(id  _Nonnull data) {
        [MBProgressHUD hideHUD];
        [AlertControllerTools showAlertWithTitle:@"是否立即支付" msg:nil items:@[@"稍后支付",@"立即支付"] showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
            if (actionIndex == 0) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
            } else {
                PaymentViewController * paymentVC = [[PaymentViewController alloc]init];
                paymentVC.orderNo = (NSString *)data;
                paymentVC.completeBlock = ^(BOOL paySuccess) {
                    weakSelf.payComplete = paySuccess;
                };
                [weakSelf.navigationController pushViewController:paymentVC animated:YES];
            }
        }];
    } fail:^(NSInteger code) {
        
    }];
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
-(void)setIsConfirmContract:(BOOL)isConfirmContract{
    _isConfirmContract = isConfirmContract;
    [self.tableView reloadData];
}
-(PrivacyPolicyView *)privacyPolicyView{
    if (_privacyPolicyView == nil) {
        _privacyPolicyView = [[PrivacyPolicyView alloc]init];
        _privacyPolicyView.delegate = self;
    }
    return _privacyPolicyView;
}
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
        _footerView.price = self.predictPrice;
        [self.tableView addSubview:_footerView];
        [self.tableView bringSubviewToFront:_footerView];
    }
    return _footerView;
}


#pragma mark - contract delegate

-(void)transportPayContractConfirmCellTapConfirm:(TransportPayContractConfirmCell *)cell{
    [self.privacyPolicyView addPopViewToWindowWithHtml:@"<div><p style=\"line-height:20pt; margin:17pt 0pt 16.5pt; text-align:center\"><span style=\"font-family:微软雅黑; font-size:16pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">斑马平台交易条款</span></p><p style=\"margin:0pt\"><span style=\"font-family:微软雅黑; font-size:11pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">服务声明：斑马平台（以下简称“斑马”或“平台”）是由本司经营的用于为您提供物流资源整合服务的网络信息平台。您在平台提交斑马速运订单成功后，平台的城市合伙人（以下简称“合伙人”）将为您提供宠物托运服务。合伙人作为平台各机场唯一合作供应商，执行平台统一的服务规范，并对服务期间的质量负责。</span></p><h1 style=\"line-height:12pt; margin:13pt 0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">1、</span><span style=\"font-family:sans-serif; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">托运人权利和义务</span></h1><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(1)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人应准确填写订单信息，如实告知平台所托运宠物的品类、重量、是否符合规定托运条件，并办理有效《动物检疫合格证明》，</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">如托运人自备航空箱，需提供符合航空托运标准的航空箱。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(2)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人应准确填写收/发宠人的信息（联系人、联系电话、地址等），</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">若托运人在下单时所填写的收/发宠人或单方信息有误，或通讯不畅</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">，导致宠物时效延误、运输错误、错误签收、费用变更等问题的，相应的违约责任及托运异常后果由托运人自行承担。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(3)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">因各城市宠物的收运限制和包装容器标准差异较大，</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">如托运宠物属于短鼻类、烈性犬、重量大于15KG、需当天收寄等情况应提前联系平台城市客服确认后再下单，否则合伙人有权利取消不符合要求的订单。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(4)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人必须遵守《中华人民共和国民用航空法》、《中国民用航空货物国内运输规则》、《中华人民共和国动物防疫法》以及其他适用的法律、政府规定、行业规范等。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(5)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人不得托运或在所托运的航空笼或宠物中夹带、瞒报禁止运输的物品，详细参见《宠物限运说明》。对于已接受委托，如发现托运人所托运的宠物为承运人不能安全、合法运输的宠物（包括但不限于危险品、违禁品、限运动物），承运人保留拒绝运输的权利，相应的违约责任由托运人自行承担。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">(6)</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">.</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">托运人下单前应了解宠物航空运输的基本知识、阅读平台提供的《购票须知》和《产品介绍》，如因托运人违反了以上规则和托运要求下单导致平台无法执行订单，由托运人承担相应后果。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(7)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人所托运宠物应符合以下要求：</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 28.35pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">a)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">重量：单只宠物重量不超过平台限制（具体重量限制以航司要求为准）；</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 28.35pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">b)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">健康：未患有各类疾病，起运前48小时内未做过手术，且交接前未服用镇静剂或安眠药；</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 28.35pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">c)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">年龄：宠物年龄大于等于2个月（具体要求以航司公布信息为准）；</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 28.35pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">d)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">其他具体规定以下单界面《宠物限运说明》为准。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(8)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人须在平台提示的最晚交宠时间之前将宠物交付平台指定合作供应商处或指定的司机，若因托运人原因，宠物未在规定时间内交付平台指定合作供应商处或指定的司机，影响正常发宠的，平台有权拒收宠物，并由托运人承担违约责任。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(9)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人在平台的订单选择港到自提时，发宠人或收宠人（依据托运人在平台订单上为准）在收到平台推送的提货通知后，应在航班落地4小时内完成提货。若收宠人在航班落地后6小时内未回复平台提货状态，则默认提货无异常，后续宠物出现的任何问题由托运人自行承担。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(10)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人在平台的订单选择送宠上门时，平台或合伙人在送宠上门前与收宠人预约送达时间。若因收宠人要求，预约送达时间超过航班落地18小时的，宠物在到达目的地机场至配送完成过程中出现异常时，平台及合伙人不承担责任。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(11)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人应了解航空运输中宠物身体异常会产生的风险，托运人隐匿相关宠物健康问题导致的运输风险，由托运人自行承担。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(12)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人应了解托运宠物性格，提前计划宠物不适合托运的处理方式，如托运过程中发生因宠物自身问题导致产生不能继续托运的状况，托运人应承担已产生相关费用。</span></p><p style=\"margin:0pt; padding-left:22.5pt; text-align:justify; text-indent:-22.5pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">(13)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">托运人下单时应如实填写运输需求，并应支付服务对应的相关费用，托运人在预约交接日期前1天取消订单，可以享受全额退款；托运人在预约交接时间当天不能再变更交接时间！托运人在预约交接日期当天，取消订单需扣除50元退单费，预约交接时间前3小时内无法取消上门服务！ 托运人应知晓在对订单服务进行变更时，平台提供的派送服务可以取消但不退款、保价服务不可以取消，其他始发地提供的服务取消成功后可以全额退款！</span></p><h1 style=\"line-height:12pt; margin:13pt 0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:10.5pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">2、</span><span style=\"font-family:sans-serif; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">平台及合伙人权利和义务</span></h1><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(1)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">本协议项下平台合伙人指取得“斑马速运”品牌使用权，并具备斑马速运网络经营权的物流服务主体。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(2)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">（2）. 合伙人作为平台各机场唯一合伙人，具备独立的经营管理权，应向托运人开具订单所负责环节费用的发票，一个订单的发票开具人可能由1个以上合伙人组成。</span><br><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">合伙人接受托运人委托后，应安全、准时的提供航空运输服务，</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">合伙人优先按照托运人要求航班运输，但不承诺指定航班</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">，因不可抗力（包含但不限于航司拒收、航班取消、机型更换、航班延误、航班备降风险等）产生的航班改配或订单取消，平台与合伙人不承担任何责任，并需退还未产生服务环节费用给托运人。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(3)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">（3）. 合伙人应免费向客户提供收宠交接、打包完成、柜台交宠、目的地机场提宠、客户签收环节的视频或照片（不包含可能涉及收费的机场货站内部视频/照片、宠物直播视频等），并在航班起飞前通知（短信、微信公众号）托运人、发宠人、收宠人提货信息或上门送宠信息。如合伙人已履行通知义务，未选择目的地送宠上门的托运人应要求收宠人及时提取宠物，如航班落地后6小时内仍未提取宠物，平台与合伙人不承担任何责任。选择目的地送宠上门的，合伙人将于航班实际落地后的18小时内完成配送。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(4)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">合伙人对宠物的以下情况不承担责任：</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 21.25pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\"> Ø </span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">宠物自身问题导致的航空运输风险（包括但不限于宠物情绪暴躁引起的自身伤害、托运人要求多只宠物共用航空箱时宠物互相伤害、宠物身体虚弱且宠物主拒绝平台提供的增值服务导致的死亡、宠物主未声明喂食过宠物药物导致的死亡等非可控因素）；</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 21.3pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\"> Ø </span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人隐匿宠物健康状况，导致的宠物托运风险；</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 21.3pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\"> Ø </span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">因不可抗力（包括但不限于疫情时期，管理当局命令屠杀；飞行事故；战争等社会异常事件）造成的宠物死亡、丢失。</span></p><p style=\"line-height:12.65pt; margin:0pt 0pt 0pt 21.3pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\"> Ø </span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">因托运人伪造《动物检疫合格证明》、提供劣质航空箱等导致的宠物运输风险。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(5)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人对宠物有声明价值，并支付保价费用后，平台对宠物的丢失、死亡应按照实际价值依法承担赔偿义务，赔偿金额不超过声明价值；若托运人未进行保价，合伙人对宠物的丢失、死亡按行业标准赔偿（不超过100元/公斤）；托运人索赔时，合伙人有权要求托运人提供索赔资料及相关证明材料。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(6)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">宠物作为航空运输中的特殊货物，合伙人对宠物死亡、丢失以外的情况不承担任何责任（包含但不限于精神萎靡、身体虚弱、形象邋遢等非人为性故意伤害），</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-decoration:underline; text-transform:none; vertical-align:baseline\">航空运输环节中出现宠物死亡时，如实际承运人拒绝出具“事故证明”的情况，平台与合伙人不承担赔偿责任。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(7)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">合伙人作为平台各机场唯一指定合作伙伴，须遵守平台规则向托运人提供服务，并对宠物运输服务质量承担完全责任。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(8)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"color:#ff0000; font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">平台仅对合伙人和托运人在平台发生的交易订单（以生成平台有效订单为依据）承担相应的义务，</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">如合伙人和托运人发生交易行为，但未在平台生成有效订单（包含但不限于托运人主动要求线下交易、合伙人引诱托运人线下交易等），交易过程中发生的事故、纠纷等平台不承担任何责任。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(9)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">托运人恶意骗保，利用平台漏洞损害合伙人利益，听信他人使用非平台约定服务导致的运输风险，平台不承担相关责任风险，并依法保留向托运人索赔的权利。</span></p><h1 style=\"line-height:12pt; margin:13pt 0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:10.5pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">3、</span><span style=\"font-family:sans-serif; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">下单及支付</span><span style=\"font-family:sans-serif; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">&nbsp;</span></h1><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(1)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">订单根据托运人选择的服务或产品进行计价，并汇总收费，因托运人填写信息有误导致的费用变更平台执行多退少补的原则，托运人应予配合；</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(2)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">客户下单是填写信息应该准确、真实，平台依据客户填写信息收取的费用仅作为预估费用，订单实际费用以收宠时核验结果为准，以下是对下单界面名字的解释：</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">宠物重量</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：指宠物实际重量和超出航空箱标配产生的附属物重量之和，不足</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">1KG</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">的以</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">1KG</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">计算；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">航空箱</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：系统会按照宠物重量、品类匹配相应航空箱，但此匹配航空箱仅供参考，应以实际使用航空箱为准，产生的费用变更执行多退少补的规则；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">斑马速运</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：指平台按照流向、宠物重量为基础，制定规范的报价，客户下单时提交订单成功后平台即保障价格，如后续价格变更不影响此订单费用；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">保价费</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：保价以订单为单位，声明价值也是对同一订单内的所有宠物汇总价值，保价费率以下单时实际执行为准；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">上门收宠</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：指平台向托运人提供上门服务时收取的费用，在期望交接时间前</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">4</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">小时取消订单且平台司机未出发，客户取消上门时平台全额退款；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">送宠到家：</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">指平台或平台合伙人向托运人/收宠人提供送宠上门服务时收取的费用；在始发地客户与平台或平台合伙人交接后，送宠到家服务可以取消，但不退还相关费用；</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">机票日期</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：指客户期望的宠物乘坐航班的日期，因受限于航班数量、开通航司等因素，平台并不承诺按照机票日期指定航班。</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">收宠人</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">：指签收宠物的指定人员，托运人必须保证姓名、手机号正确，否则因航司、机场规定产生的“改名费”由托运人支付。</span></p><p style=\"margin:0pt 0pt 0pt 21pt; text-align:justify\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">以上费用仅包括平台向托运人定义的服务，不包含现有及未来可能会增加的其他增值服务、未声明包含的服务项（如机场提货费、机场速提费、退货费等）。</span></p><p style=\"margin:0pt; padding-left:21pt; text-align:justify; text-indent:-21pt\"><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">(3)</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">&nbsp;</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:normal; text-transform:none; vertical-align:baseline\">.</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">托运人订单提交后，应在当日</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">24</span><span style=\"font-family:微软雅黑; font-size:9pt; font-style:normal; font-weight:bold; text-transform:none; vertical-align:baseline\">点前支付订单，否则订单失效。</span></p><p style=\"margin:0pt; orphans:0; text-align:justify; widows:0\"><span style=\"font-family:Calibri; font-size:10.5pt\">&nbsp;</span></p></div>" title:@"斑马平台交易条款"];
}
@end
