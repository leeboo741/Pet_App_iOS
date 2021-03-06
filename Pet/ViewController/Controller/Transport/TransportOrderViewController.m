//
//  TransportOrderViewController.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrderViewController.h"
#import "TransportValueAddProtocol.h"
#import "TransportOrderBaseInfoCell.h"
#import "TransportOrderTransportTypeGroupCell.h"
#import "TransportOrder.h"
#import "TransportOrderFooterView.h"
#import "TransportOrderValueAddCell.h"
#import "TransportPayViewController.h"
#import "SelectLocationMapController.h"
#import "AlertControllerTools.h"
#import "CGXPickerView.h"
#import "DateUtils.h"
#import "OrderManager.h"
#import "TransportCitySelectedController.h"
#import "LocationManager.h"
#import "ContractViewController.h"

#pragma mark - Transport Type View Model
#pragma mark -

@interface TransportTypeViewModel : NSObject <TransportTypeProtocol>
@property (nonatomic, copy) NSString * normalIconName;
@property (nonatomic, copy) NSString * normalTitle;
@property (nonatomic, assign) OrderTransportType type;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectColor;
@property (nonatomic, strong) UIColor * disableColor;
@property (nonatomic, assign) BOOL typeIsDisable;
@property (nonatomic, assign) BOOL typeIsSelected;
@end
@implementation TransportTypeViewModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.typeIsDisable = YES;
        self.typeIsSelected = NO;
    }
    return self;
}
-(UIColor *)normalColor{
    return _normalColor?_normalColor:Color_blue_1;
}
-(UIColor *)selectColor{
    return _selectColor?_selectColor:Color_red_2;
}
-(UIColor *)disableColor{
    return _disableColor?_disableColor:Color_gray_2;
}
@end

#pragma mark - Transport Value Add Model
#pragma mark -

@interface TransportValueAdd : NSObject <TransportValueAddProtocol>
@property (nonatomic, assign) BOOL serviceEnableUse; // 是否可用
@property (nonatomic, assign) BOOL serviceEnableTap; // 是否可点击
@property (nonatomic, assign) BOOL serviceIsSelected; // 是否选中
@property (nonatomic, assign) BOOL serviceShowInputArea; // 是否展示输入区
@property (nonatomic, assign) BOOL serviceShowInfoArea; // 是否展示信息区

@property (nonatomic, copy) NSString * serviceName; // 服务名称
@property (nonatomic, copy) NSString * serviceContract; // 服务协议
@property (nonatomic, copy) NSString * serviceDetail; // 服务详情
@property (nonatomic, copy) NSString * serviceValue; // 服务
@property (nonatomic, copy) NSString * serviceValuePlaceholder; // 服务
@property (nonatomic, copy) NSString * serviceInfo; // 服务说明

@property (nonatomic, strong) NSNumber * latitude; // 纬度
@property (nonatomic, strong) NSNumber * longitude; // 经度
@end
@implementation TransportValueAdd
-(instancetype)init{
    self = [super init];
    if (self) {
        self.serviceEnableUse = NO;
        self.serviceEnableTap = YES;
        self.serviceIsSelected = NO;
        self.serviceShowInputArea = NO;
        self.serviceShowInfoArea = NO;
    }
    return self;
}
@end

#pragma mark - Transport Order View Controller
#pragma mark -

static NSString * BaseInfoCellName = @"TransportOrderBaseInfoCell";
static NSString * BaseInfoCellIdentifier = @"BaseInfoCellIdentifier";

static NSString * TransportTypeGroupCellName = @"TransportOrderTransportTypeGroupCell";
static NSString * TransportTypeGroupCellIdentifier = @"TransportTypeGroupCellIdentifier";

static NSString * ValueAddedCellName = @"TransportOrderValueAddCell";
static NSString * ValueAddedCellIdentifier = @"ValueAddedCellIdentifier";

@interface TransportOrderViewController () <TransportOrderBaseInfoCallDelegate, TransportOrderTransportTypeGroupCellDelegate,TransportOrderValueAddCellDelegate,TransportOrderFooterViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) TransportOrder * transportOrder;
@property (nonatomic, strong) NSArray<id<TransportTypeProtocol>>* transportTypeArray;
@property (nonatomic, strong) NSArray<id<TransportValueAddProtocol>>* transportValueAddArray;

@property (nonatomic, strong) NSArray * petAgeValues;
@property (nonatomic, strong) NSArray * petTypes;
@property (nonatomic, strong) NSNumber * maxPetWeight;
@property (nonatomic, strong) TransportTypeViewModel * selectTransportType;

@property (nonatomic, copy) NSString * servicePhone;

@property (nonatomic, strong) TransportOrderFooterView * footerView;
@property (nonatomic, assign) CGFloat footerY;
@end

@implementation TransportOrderViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"托运订单";
    [self.tableView registerNib:[UINib nibWithNibName:BaseInfoCellName bundle:nil] forCellReuseIdentifier:BaseInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:TransportTypeGroupCellName bundle:nil] forCellReuseIdentifier:TransportTypeGroupCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ValueAddedCellName bundle:nil] forCellReuseIdentifier:ValueAddedCellIdentifier];
    self.tableView.backgroundColor = Color_gray_1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self footerView];
    [self getPetTypesData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView bringSubviewToFront:_footerView];
}

#pragma mark - Table view dataSource and delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerY + self.tableView.contentOffset.y, self.footerView.frame.size.width, self.footerView.frame.size.height);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.transportValueAddArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TransportOrderBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseInfoCellIdentifier forIndexPath:indexPath];
        [self configBaseInfoCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        TransportOrderTransportTypeGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:TransportTypeGroupCellIdentifier forIndexPath:indexPath];
        [self configTransportTypeGroupCell:cell atIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        TransportOrderValueAddCell * cell = [tableView dequeueReusableCellWithIdentifier:ValueAddedCellIdentifier forIndexPath:indexPath];
        [self configValueAddCell:cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:BaseInfoCellIdentifier configuration:^(id cell) {
            [self configBaseInfoCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:TransportTypeGroupCellIdentifier configuration:^(id cell) {
            [self configTransportTypeGroupCell:cell atIndexPath:indexPath];
        }];
    } else if (indexPath.section == 2) {
        TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
        if (valueAdd.serviceEnableUse) {
            return [tableView fd_heightForCellWithIdentifier:ValueAddedCellIdentifier configuration:^(id cell) {
                [self configValueAddCell:cell atIndexPath:indexPath];
            }];
        } else {
            return 0.01;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        if (IS_IPHONE_X_orMore) {
            return 60;
        }
        return 80;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * sectionFooter = [[UIView alloc]init];
    return sectionFooter;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"基础信息";
    } else if (section == 1) {
        return @"运输方式";
    } else {
        return @"增值服务";
    }
}

#pragma mark - transport baseinfo cell delegate

-(void)selectBaseInfoItem:(TransportBaseInfo_Type)baseInfoType{
    if (baseInfoType == TransportBaseInfo_Type_StartCity) {
        __weak typeof(self) weakSelf = self;
        TransportCitySelectedController * citySelectVC = [[TransportCitySelectedController alloc]initWithType:CitySelectedType_Start selectBlock:^(NSString * _Nonnull cityName) {
            if ([cityName isEqualToString:weakSelf.transportOrder.startCity]) {
                return;
            }
            [weakSelf resetStartCityWithCity:cityName detailAddress:nil location:nil];
            [weakSelf getPredictPrice];
        }];
        [self.navigationController pushViewController:citySelectVC animated:YES];
    } else if (baseInfoType == TransportBaseInfo_Type_EndCity) {
        if (kStringIsEmpty(self.transportOrder.startCity)) {
            [MBProgressHUD showErrorMessage:@"请先选择始发城市"];
            return;
        }
        __weak typeof(self) weakSelf = self;
        TransportCitySelectedController * citySelectVC = [[TransportCitySelectedController alloc]initWithType:CitySelectedType_End selectBlock:^(NSString * _Nonnull cityName) {
            if ([cityName isEqualToString:weakSelf.transportOrder.endCity]) {
                return;
            }
            [weakSelf resetEndCityWithCity:cityName];
            [weakSelf getPredictPrice];
        }];
        citySelectVC.startCity = self.transportOrder.startCity;
        [self.navigationController pushViewController:citySelectVC animated:YES];
    } else if (baseInfoType == TransportBaseInfo_Type_Time) {
        NSString * todayStr = [[DateUtils shareDateUtils] getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
        NSDate * maxDate = [[DateUtils shareDateUtils] getDateWithTargetDate:[NSDate date] durationYear:0 durationMonth:1 durationDay:0];
        NSString * maxDateStr = [[DateUtils shareDateUtils]getDateStringWithDate:maxDate withFormatterStr:Formatter_YMD];
        __weak typeof(self) weakSelf = self;
        [CGXPickerView showDatePickerWithTitle:@"出发时间" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:todayStr MaxDateStr:maxDateStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
            weakSelf.transportOrder.outTime = selectValue;
            [weakSelf.tableView reloadData];
            [weakSelf getPredictPrice];
        }];
    } else if (baseInfoType == TransportBaseInfo_Type_Type) {
        if (kArrayIsEmpty(self.petTypes)) {
            return;
        }
        __weak typeof(self) weakSelf = self;
        [AlertControllerTools showActionSheetWithTitle:@"宠物类型" msg:nil items:self.petTypes showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
            weakSelf.transportOrder.petType = weakSelf.petTypes[actionIndex];
            [weakSelf.tableView reloadData];
            [weakSelf getPredictPrice];
        }];
    } else if (baseInfoType == TransportBaseInfo_Type_Age) {
        __weak typeof(self) weakSelf = self;
        [AlertControllerTools showActionSheetWithTitle:@"宠物年龄" msg:nil items:self.petAgeValues showCancel:NO actionTapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger actionIndex) {
            weakSelf.transportOrder.petAge = weakSelf.petAgeValues[actionIndex];
            [weakSelf.tableView reloadData];
            [weakSelf getPredictPrice];
        }];
    }
}

-(void)inputBaseInfoItem:(TransportBaseInfo_Type)baseInfoType withText:(NSString *)text{
    if (baseInfoType == TransportBaseInfo_Type_Count) {
        self.transportOrder.petCount = text;
    } else if (baseInfoType == TransportBaseInfo_Type_Weight) {
        self.transportOrder.petWeight = text;
        [self comparePetWeightWithClear:NO];
    } else if (baseInfoType == TransportBaseInfo_Type_Breed) {
        self.transportOrder.petBreed = text;
    } else if (baseInfoType == TransportBaseInfo_Type_Name) {
        self.transportOrder.petName = text;
    }
}

-(void)endingInputBaseInfoItem:(TransportBaseInfo_Type)baseInfoType{
    if (baseInfoType == TransportBaseInfo_Type_Weight
        || baseInfoType == TransportBaseInfo_Type_Breed
        || baseInfoType == TransportBaseInfo_Type_Count) {
        [self getPredictPrice];
    }
}

#pragma mark - transport type cell delegate

-(void)transportTypeGroupCell:(TransportOrderTransportTypeGroupCell *)cell didSelectTransportTypeAtIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.transportTypeArray.count; i ++) {
        TransportTypeViewModel * model = (TransportTypeViewModel *)self.transportTypeArray[i];
        if (i == index) {
            self.selectTransportType = model;
            self.transportOrder.transportType.typeId = [NSString stringWithFormat:@"%ld",self.selectTransportType.type];
            model.typeIsSelected = YES;
            [self getMaxAblePetWeightWithStartCity:self.transportOrder.startCity endCity:self.transportOrder.endCity transportType:model.type];
            [self getPredictPrice];
        } else {
            model.typeIsSelected = NO;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - transport value add cell delegate

-(BOOL)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueInputShouldBeginEditing:(UITextField *)textField {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    if (indexPath.row == 2 || indexPath.row == 3) {
        if (indexPath.row == 2) {
            SelectLocationMapController * selectLocationMapVC = [[SelectLocationMapController alloc]init];
            selectLocationMapVC.city = self.transportOrder.startCity;
            selectLocationMapVC.detailAddress = valueAdd.serviceValue;
            __weak typeof(self) weakSelf = self;
            selectLocationMapVC.selectReturnBlock = ^(NSString * _Nonnull city, NSString * _Nonnull detailAddress, CLLocationCoordinate2D coordinate) {
                valueAdd.serviceValue = [NSString stringWithFormat:@"%@%@",city,detailAddress];
                valueAdd.latitude = kDoubleNumber(coordinate.latitude);
                valueAdd.longitude = kDoubleNumber(coordinate.longitude);
                weakSelf.transportOrder.receiptLatitude = coordinate.latitude;
                weakSelf.transportOrder.receiptLongitude = coordinate.longitude;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:selectLocationMapVC animated:YES];
        } else {
            SelectLocationMapController * selectLocationMapVC = [[SelectLocationMapController alloc]init];
            selectLocationMapVC.city = self.transportOrder.endCity;
            selectLocationMapVC.detailAddress = valueAdd.serviceValue;
            __weak typeof(self) weakSelf = self;
            selectLocationMapVC.selectReturnBlock = ^(NSString * _Nonnull city, NSString * _Nonnull detailAddress, CLLocationCoordinate2D coordinate) {
                valueAdd.serviceValue = [NSString stringWithFormat:@"%@%@",city,detailAddress];
                valueAdd.latitude = kDoubleNumber(coordinate.latitude);
                valueAdd.longitude = kDoubleNumber(coordinate.longitude);
                weakSelf.transportOrder.sendAddress = valueAdd.serviceValue;
                weakSelf.transportOrder.sendLatitude = coordinate.latitude;
                weakSelf.transportOrder.sendLongitude = coordinate.longitude;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:selectLocationMapVC animated:YES];
        }
        [self.tableView reloadData];
        return NO;
    }
    return YES;
}

-(BOOL)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueinput:(UITextField *)textField afterChangeText:(NSString *)text {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    if (indexPath.row == 0) {
        if (!Util_IsNumberString(text)) {
            return NO;
        } else {
            valueAdd.serviceValue = text;
            self.transportOrder.petAmount = [text doubleValue];
        }
    }
    return YES;
}

-(void)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueinputDidEndEditing:(UITextField *)textField {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    if (indexPath.row == 0) {
        NSInteger num = [valueAdd.serviceValue integerValue];
        if (num < 1000 || num > 6000) {
            if (num < 1000) {
                num = 1000;
            }
            if (num > 6000) {
                num = 6000;
            }
            valueAdd.serviceValue = [NSString stringWithFormat:@"%ld",num];
            [self.tableView reloadData];
        }
    }
}

-(void)valueAddCellTapHeadder:(TransportOrderValueAddCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    valueAdd.serviceIsSelected = !valueAdd.serviceIsSelected;
    TransportOrder_AddValue_SelectType selectType = [self getSelectTypeBySelected:valueAdd.serviceIsSelected];
    switch (indexPath.row) {
        case 0:
        {
            self.transportOrder.insuredPrice = selectType;
        }
            break;
        case 1:
        {
            self.transportOrder.buyPetCage = selectType;
        }
            break;
        case 2:
        {
            self.transportOrder.receipt = selectType;
        }
            break;
        case 3:
        {
            self.transportOrder.send = selectType;
        }
            break;
        case 4:
        {
            self.transportOrder.water = selectType;
        }
            break;
        case 5:
        {
            self.transportOrder.wo = selectType;
        }
            break;
        case 6:
        {
            self.transportOrder.warmCloth = selectType;
        }
            break;
        case 7:
        {
            self.transportOrder.guarantee = selectType;
        }
            break;
        default:
            break;
    }
    if (indexPath.row == 2 || indexPath.row == 3) {
        valueAdd.serviceShowInputArea = valueAdd.serviceIsSelected;
    }
    [self.tableView reloadData];
}

-(void)valueAddCellTapContract:(TransportOrderValueAddCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    MSLog(@"点击Contract: %@",valueAdd.serviceContract);
    ContractViewController * contractViewController = [[ContractViewController alloc]init];
    if (indexPath.row == 0) {
        contractViewController.title = @"评估说明";
        contractViewController.type = ContractType_Text;
        contractViewController.source = @"  根据机场、车站要求，承运宠物必须填写“声明价值”。最低1000元，最高6000元。服务费按照声明价值的1%收取。运输途中，宠物死亡，按照声明价值赔付。备注:理赔时，声明价值超过5000元的宠物，需提供血统证书。\n\n   本服务由中国平安财产保险有限公司提供";
    } else if (indexPath.row == 1) {
        contractViewController.title = @"宠物箱说明";
        contractViewController.type = ContractType_Image;
        contractViewController.source = @"https://img.taochonghui.com/weapp/petCage.jpg";
    } else if (indexPath.row == 2) {
        contractViewController.title = @"接宠说明";
        contractViewController.type = ContractType_Text;
        contractViewController.source = @"  接宠所在地，距离当地网点10公里范围内免费，超出范围接宠司机会收取相应路费。具体以当地网点联系结果为准。";
    } else if (indexPath.row == 3) {
        contractViewController.title = @"送宠说明";
        contractViewController.type = ContractType_Text;
        contractViewController.source = @"1、送宠到家，以下单客户输入的具体地址为准，并根据送宠的距离合理收取路费。\n\n 2、各地机场、车站，均有提货费用。提货费用，收件人自理。\n\n 3、宠物不送上楼，只送到小区门口或者车辆能直接开进去并且顺利倒出来的区域。如有特殊需要，请提前联系当地站点客服。\n\n 4、送宠时效：一般不超过航班落地6小时后。具体以当地机场、车站提货时效为准。\n";
    } else if (indexPath.row == 7) {
        contractViewController.title = @"担保注意事项";
        contractViewController.type = ContractType_Text;
        contractViewController.source = @"1. 斑马速运，不参与买卖双方交易过程！\n\n 2. 可以提供上门拍摄宠物实时视频服务，确保所拍视频真实有效。\n\n 3. 如需上门检测或送当地宠物医院检测，下单时请在备注栏里填写相关需求。检测所需费用，实报实销。";
    }
    [self.navigationController pushViewController:contractViewController animated:YES];
}

#pragma mark - footer view delegate

-(void)transportOrderFooterTapOrder{
    MSLog(@"点击预定");
    if (![self isAbleOrder:YES]) {
        return;
    }
    TransportPayViewController * transportPayVC = [[TransportPayViewController alloc]initWithTransportOrder:self.transportOrder predictPrice:self.footerView.price];
    [self.navigationController pushViewController:transportPayVC animated:YES];
}

-(void)transportOrderFooterTapCall {
    MSLog(@"点击客服电话");
    if (kStringIsEmpty(self.servicePhone)) {
        Util_MakePhoneCall(Service_Phone);
    } else {
        Util_MakePhoneCall(self.servicePhone);
    }
}

#pragma mark - config cell

-(void)configBaseInfoCell:(TransportOrderBaseInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.startCity = self.transportOrder.startCity;
    cell.endCity = self.transportOrder.endCity;
    cell.outTime = self.transportOrder.outTime;
    cell.petCount = self.transportOrder.petCount;
    cell.petType = self.transportOrder.petType;
    cell.petBreed = self.transportOrder.petBreed;
    cell.petWeight = self.transportOrder.petWeight;
    cell.petAge = self.transportOrder.petAge;
    cell.petName = self.transportOrder.petName;
}

-(void)configTransportTypeGroupCell:(TransportOrderTransportTypeGroupCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.transportTypeList = self.transportTypeArray;
}

-(void)configValueAddCell:(TransportOrderValueAddCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    TransportValueAdd * valueAdd = (TransportValueAdd*)self.transportValueAddArray[indexPath.row];
    cell.hidden = !valueAdd.serviceEnableUse;
    cell.serviceEnableTap = valueAdd.serviceEnableTap;
    cell.serviceIsSelected = valueAdd.serviceIsSelected;
    cell.showInputArea = valueAdd.serviceShowInputArea;
    cell.serviceName = valueAdd.serviceName;
    cell.serviceDetail = valueAdd.serviceDetail;
    cell.serviceContract = valueAdd.serviceContract;
    cell.serviceValue = valueAdd.serviceValue;
    cell.serviceValuePlaceholder = valueAdd.serviceValuePlaceholder;
    cell.serviceInfo = valueAdd.serviceInfo;
}

#pragma mark - private method

-(TransportOrder_AddValue_SelectType)getSelectTypeBySelected:(BOOL)selected{
    if (selected) {
        return TransportOrder_AddValue_SelectType_Selected;
    } else {
        return TransportOrder_AddValue_SelectType_Unselected;
    }
}

-(void)resetStartCityWithCity:(NSString *)city detailAddress:(NSString *)detailAddress location:(CLLocation *)location{
    self.transportOrder.startCity = city;
    // 增值服务
    TransportValueAdd * onDoor = (TransportValueAdd *)self.transportValueAddArray[2];
    onDoor.serviceEnableUse = YES;
    NSString * value = @"";
    if (!kStringIsEmpty(detailAddress)) {
        value = detailAddress;
    }
    onDoor.serviceValue = value;
    if (location) {
        onDoor.latitude = kDoubleNumber(location.coordinate.latitude);
        onDoor.longitude = kDoubleNumber(location.coordinate.longitude);
    } else {
        onDoor.latitude = nil;
        onDoor.longitude = nil;
    }
    // 宠物重量
    self.transportOrder.petWeight = @"";
    // 目的城市
    [self resetEndCityWithCity:@""];
    [self getInsureRateWithStartCity:self.transportOrder.startCity];
}

-(void)resetEndCityWithCity:(NSString *)endCity{
    self.transportOrder.endCity = endCity;
    TransportValueAdd * toHome = (TransportValueAdd *)self.transportValueAddArray[3];
    toHome.serviceIsSelected = NO;
    toHome.serviceShowInputArea = NO;
    toHome.serviceValue = @"";
    toHome.latitude = nil;
    toHome.longitude = nil;
    // 运输方式
    self.selectTransportType = nil;
    for (TransportTypeViewModel * typeViewModel in self.transportTypeArray) {
        typeViewModel.typeIsSelected = NO;
        typeViewModel.typeIsDisable = YES;
    }
    if (!kStringIsEmpty(self.transportOrder.endCity)) {
        toHome.serviceEnableUse = YES;
        [self getAbleTransportTypeWithStartCity:self.transportOrder.startCity endCity:self.transportOrder.endCity];
    } else {
        toHome.serviceEnableUse = NO;
    }
    [self.tableView reloadData];
    [self getPredictPrice];
}

-(void)comparePetWeightWithClear:(BOOL)clear{
    if (!kStringIsEmpty(self.transportOrder.petWeight) && self.maxPetWeight) {
        CGFloat inputPetWeight = [self.transportOrder.petWeight floatValue];
        CGFloat maxPetWeight = [self.maxPetWeight floatValue];
        if (inputPetWeight > maxPetWeight) {
            [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"超出允许最大重量: %.1fkg",maxPetWeight] timer:2];
            if (clear) {
                self.transportOrder.petWeight = @"";
                [self.tableView reloadData];
            }
        }
    }
}

-(BOOL)isAbleOrder:(BOOL)willOrder{
    if (kStringIsEmpty(self.transportOrder.startCity)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"起始城市不能为空"];
        }
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.endCity)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"目的城市不能为空"];
        }
        return NO;
    }
    if (!self.selectTransportType ) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请选择运输方式"];
        }
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.petWeight)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请输入宠物重量"];
        }
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.petCount)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请输入宠物数量"];
        }
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.outTime)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请选择出发时间"];
        }
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.petAge) && willOrder) {
        [MBProgressHUD showTipMessageInWindow:@"请选择宠物年龄"];
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.petType) && willOrder) {
        [MBProgressHUD showTipMessageInWindow:@"请选择宠物类型"];
        return NO;
    }
    if (kStringIsEmpty(self.transportOrder.petBreed) && willOrder) {
        [MBProgressHUD showTipMessageInWindow:@"请选择宠物品种"];
        return NO;
    }
    if (self.transportOrder.petAmount < 0) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"声明价值不能小于0"];
        }
        return NO;
    }
    if (self.transportOrder.receipt == TransportOrder_AddValue_SelectType_Selected && kStringIsEmpty(self.transportOrder.receiptAddress)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请选择接宠地址"];
        }
        return NO;
    }
    if (self.transportOrder.send == TransportOrder_AddValue_SelectType_Selected && kStringIsEmpty(self.transportOrder.sendAddress)) {
        if (willOrder) {
            [MBProgressHUD showTipMessageInWindow:@"请选择送宠地址"];
        }
        return NO;
    }
    return YES;
}

#pragma mark - request data

-(void)getPredictPrice{
    if (![self isAbleOrder:NO]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] getPredictPriceWithModel:self.transportOrder success:^(id  _Nonnull data) {
        NSNumber * number = (NSNumber* )data;
        weakSelf.footerView.price = [NSString stringWithFormat:@"%.2f",[number floatValue]];
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getMaxAblePetWeightWithStartCity:(NSString *)startCity endCity:(NSString *)endCity transportType:(OrderTransportType)type{
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] getMaxPetCageWeightWithStartCity:startCity endCity:endCity transportType:type success:^(id  _Nonnull data) {
        weakSelf.maxPetWeight = data;
        [weakSelf comparePetWeightWithClear:YES];
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getAbleTransportTypeWithStartCity:(NSString *)startCity endCity:(NSString *)endCity{
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] getAbleTransportTypeWithStartCity:startCity endCity:endCity success:^(id  _Nonnull data) {
        NSArray * ableResult = data;
        for (NSNumber * number in ableResult) {
            for (TransportTypeViewModel * model in weakSelf.transportTypeArray) {
                if (model.type == [number integerValue]) {
                    model.typeIsDisable = NO;
                    break;
                }
            }
        }
        [weakSelf.tableView reloadData];
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getPetTypesData{
    if (kStringIsEmpty(self.transportOrder.petType) || kArrayIsEmpty(self.petTypes)) {
        [MBProgressHUD showActivityMessageInWindow:@"请稍等..."];
        __weak typeof(self) weakSelf = self;
        [[OrderManager shareOrderManager] getPetTypeSuccess:^(id  _Nonnull data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                weakSelf.petTypes = data;
                weakSelf.transportOrder.petType = weakSelf.petTypes[0];
                [weakSelf.tableView reloadData];
                [weakSelf getCurrentLocation];
            });
        } fail:^(NSInteger code) {
            [MBProgressHUD hideHUD];
        }];
    } else {
        [self getCurrentLocation];
    }
}

-(void)requestServicePhoneWithStartCity:(NSString *)startCity{
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] getServicePhoneByStartCity:startCity success:^(id  _Nonnull data) {
        weakSelf.servicePhone = data;
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getInsureRateWithStartCity:(NSString *)startCity{
    
    __weak typeof(self) weakSelf = self;
    [[OrderManager shareOrderManager] getInsureRateByStartCity:startCity success:^(id  _Nonnull data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            InsureRateModel * insureRate = data;
            CGFloat rate = insureRate.rate;
            TransportValueAdd * insureValueAdd = (TransportValueAdd *)weakSelf.transportValueAddArray[0];
            insureValueAdd.serviceDetail = [NSString stringWithFormat:@"费率 %.2f%%",(rate * 100)];
            [weakSelf.tableView reloadData];
            
            [weakSelf requestServicePhoneWithStartCity:self.transportOrder.startCity];
        });
    } fail:^(NSInteger code) {
        
    }];
}

-(void)getCurrentLocation{
    CLLocation * location =[[LocationManager shareLocationManager] getLocation];
    if (location) {
        [self handlerLocation:location];
    } else {
        [[LocationManager shareLocationManager] requestLocationWithLocationChangeObserver:self selector:@selector(locationChange:)];
    }
}

-(void)locationChange:(NSNotification *)notification{
    if (!kStringIsEmpty(self.transportOrder.startCity)) {
        return;
    }
    CLLocation * location = [notification.userInfo objectForKey:NOTIFICATION_CURRENT_LOCATION_KEY];
    [self handlerLocation:location];
}

-(void)handlerLocation:(CLLocation *)location{
    __weak typeof(self) weakSelf = self;
    [[LocationManager shareLocationManager] geocoderLocation:location resultBlock:^(CLPlacemark * _Nonnull place) {
        NSString * city = place.locality;
        if (!city) {
            city = place.administrativeArea;
        }
        NSString * disctict = place.subLocality;
        NSString * street = @"";
        if (!kStringIsEmpty(place.thoroughfare)) street = place.thoroughfare;
        NSString * name = @"";
        if (!kStringIsEmpty(place.name)) name = place.name;
        [weakSelf resetStartCityWithCity:city detailAddress:[NSString stringWithFormat:@"%@%@",disctict,name] location:location];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - setters and getters

-(TransportOrder *)transportOrder{
    if (!_transportOrder) {
        _transportOrder = [[TransportOrder alloc]init];
        _transportOrder.outTime = [[DateUtils shareDateUtils] getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMD];
    }
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[0];
    _transportOrder.petAmount = [valueAdd.serviceValue doubleValue];
    TransportValueAdd * receipt = (TransportValueAdd *)self.transportValueAddArray[2];
    if (receipt.serviceIsSelected) {
        _transportOrder.receiptAddress = receipt.serviceValue;
        _transportOrder.receiptLatitude = [receipt.latitude doubleValue];
        _transportOrder.receiptLongitude = [receipt.longitude doubleValue];
    }
    TransportValueAdd * send = (TransportValueAdd *)self.transportValueAddArray[3];
    if(send.serviceIsSelected) {
        _transportOrder.sendAddress = send.serviceValue;
        _transportOrder.sendLatitude = [send.latitude doubleValue];
        _transportOrder.sendLongitude = [send.longitude doubleValue];
    }
    return _transportOrder;
}

-(NSArray *)petAgeValues{
    if (!_petAgeValues) {
        _petAgeValues = @[@"2~6个月",@"6个月~1岁",@"1~3岁",@"3~6岁",@"6~9岁",@"9岁以上"];
    }
    return _petAgeValues;
}

-(NSArray<id<TransportTypeProtocol>> *)transportTypeArray{
    if (!_transportTypeArray) {
        
        TransportTypeViewModel * type_2 = [[TransportTypeViewModel alloc]init];
        type_2.normalTitle = @"铁路";
        type_2.normalIconName = IconFont_Train;
        type_2.typeIsDisable = YES;
        type_2.type = OrderTransportType_HUOCHE;
        
        
        TransportTypeViewModel * type_3 = [[TransportTypeViewModel alloc]init];
        type_3.normalTitle = @"单飞";
        type_3.normalIconName = IconFont_AirPlane;
        type_3.typeIsDisable = YES;
        type_3.type = OrderTransportType_DANFEI;
        
        
        TransportTypeViewModel * type_4 = [[TransportTypeViewModel alloc]init];
        type_4.normalTitle = @"随机";
        type_4.normalIconName = IconFont_AirPlane;
        type_4.typeIsDisable = YES;
        type_4.type = OrderTransportType_SUIJI;
        
        
        TransportTypeViewModel * type_5 = [[TransportTypeViewModel alloc]init];
        type_5.normalTitle = @"大巴";
        type_5.normalIconName = IconFont_Car;
        type_5.typeIsDisable = YES;
        type_5.type = OrderTransportType_DABA;
        
        _transportTypeArray = @[type_2,type_3,type_4,type_5];
    }
    return _transportTypeArray;
}

-(NSArray<id<TransportValueAddProtocol>> *)transportValueAddArray{
    if (!_transportValueAddArray) {
        // 保价
        TransportValueAdd * insurance = [[TransportValueAdd alloc]init];
        insurance.serviceEnableUse = YES;
        insurance.serviceEnableTap = NO;
        insurance.serviceIsSelected = YES;
        insurance.serviceShowInputArea = YES;
        insurance.serviceName = @"声明价值";
        insurance.serviceDetail = @"费率 1%";
        insurance.serviceContract = @"评估说明";
        insurance.serviceValue = @"1000";
        
        // 宠物箱
        TransportValueAdd * petBox = [[TransportValueAdd alloc]init];
        petBox.serviceEnableUse = YES;
        petBox.serviceName = @"购买宠物箱";
        petBox.serviceContract = @"航空箱说明";
        petBox.serviceInfo = @"自备航空箱需符合航空公司要求的适用规则!";
        
        // 上门接宠
        TransportValueAdd * onDoor = [[TransportValueAdd alloc]init];
        onDoor.serviceEnableUse = NO;
        onDoor.serviceName = @"上门接宠";
        onDoor.serviceContract = @"接宠说明";
        onDoor.serviceValuePlaceholder = @"请选择接宠地址";
        
        // 送宠到家
        TransportValueAdd * toHome = [[TransportValueAdd alloc]init];
        toHome.serviceEnableUse = NO;
        toHome.serviceName = @"送宠到家";
        toHome.serviceContract = @"送宠说明";
        toHome.serviceValuePlaceholder = @"请选择送宠地址";
        
        // 饮水
        TransportValueAdd * water = [[TransportValueAdd alloc]init];
        water.serviceEnableUse = YES;
        water.serviceName = @"饮水器";
        
        // 暖窝
        TransportValueAdd * warm = [[TransportValueAdd alloc]init];
        warm.serviceEnableUse = YES;
        warm.serviceName = @"暖窝";
        
        // 保暖外套
        TransportValueAdd * coat = [[TransportValueAdd alloc]init];
        coat.serviceEnableUse = YES;
        coat.serviceName = @"保暖外套";
        
        // 中介担保
        TransportValueAdd * guarantee = [[TransportValueAdd alloc]init];
        guarantee.serviceEnableUse = YES;
        guarantee.serviceName = @"中介担保";
        guarantee.serviceContract = @"担保注意事项";
        
        _transportValueAddArray = @[insurance,petBox,onDoor,toHome,water,warm,coat,guarantee];
    }
    return _transportValueAddArray;
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
        _footerView.price = @"0";
        [self.tableView addSubview:_footerView];
        [self.tableView bringSubviewToFront:_footerView];
    }
    return _footerView;
}

@end
