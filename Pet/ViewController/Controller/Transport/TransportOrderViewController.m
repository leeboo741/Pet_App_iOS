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

#pragma mark - Transport Type View Model
#pragma mark -

@interface TransportTypeViewModel : NSObject <TransportTypeProtocol>
@property (nonatomic, copy) NSString * normalIconName;
@property (nonatomic, copy) NSString * normalTitle;
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
@property (nonatomic, assign) BOOL serviceEnableUse;
@property (nonatomic, assign) BOOL serviceEnableTap;
@property (nonatomic, assign) BOOL serviceIsSelected;
@property (nonatomic, assign) BOOL serviceShowInputArea;
@property (nonatomic, assign) BOOL serviceShowInfoArea;

@property (nonatomic, copy) NSString * serviceName;
@property (nonatomic, copy) NSString * serviceContract;
@property (nonatomic, copy) NSString * serviceDetail;
@property (nonatomic, copy) NSString * serviceValue;
@property (nonatomic, copy) NSString * serviceValuePlaceholder;
@property (nonatomic, copy) NSString * serviceInfo;

@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    view.backgroundColor = Color_gray_1;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 30)];
    [view addSubview:label];
    label.backgroundColor = Color_gray_1;
    if (section == 0) {
        label.text = @"基础信息";
    } else if (section == 1) {
        label.text = @"运输方式";
    } else {
        label.text = @"增值服务";
    }
    return view;
}

#pragma mark - transport baseinfo cell delegate

-(void)selectBaseInfoItem:(TransportBaseInfo_Type)baseInfoType{
    if (baseInfoType == TransportBaseInfo_Type_StartCity) {
        self.transportOrder.startCity = @"南昌市";
    } else if (baseInfoType == TransportBaseInfo_Type_EndCity) {
        self.transportOrder.endCity = @"北京市";
    } else if (baseInfoType == TransportBaseInfo_Type_Time) {
        self.transportOrder.outTime = @"2019-11-11";
    } else if (baseInfoType == TransportBaseInfo_Type_Type) {
        self.transportOrder.petType = @"狗";
    } else if (baseInfoType == TransportBaseInfo_Type_Age) {
        self.transportOrder.petAge = @"0~3个月";
    }
    [self.tableView reloadData];
}

-(void)inputBaseInfoItem:(TransportBaseInfo_Type)baseInfoType withText:(NSString *)text{
    if (baseInfoType == TransportBaseInfo_Type_Count) {
        self.transportOrder.petCount = text;
    } else if (baseInfoType == TransportBaseInfo_Type_Weight) {
        self.transportOrder.petWeight = text;
    } else if (baseInfoType == TransportBaseInfo_Type_Breed) {
        self.transportOrder.petBreed = text;
    } else if (baseInfoType == TransportBaseInfo_Type_Name) {
        self.transportOrder.petName = text;
    }
}

#pragma mark - transport type cell delegate

-(void)transportTypeGroupCell:(TransportOrderTransportTypeGroupCell *)cell didSelectTransportTypeAtIndex:(NSInteger)index{
    TransportTypeViewModel * type = (TransportTypeViewModel*)[self.transportTypeArray objectAtIndex:index];
    type.typeIsSelected = !type.typeIsSelected;
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
            selectLocationMapVC.selectReturnBlock = ^(NSString * _Nonnull city, NSString * _Nonnull detailAddress, CLLocationCoordinate2D coordinate) {
                valueAdd.serviceValue = [NSString stringWithFormat:@"%@%@",city,detailAddress];
            };
            [self.navigationController pushViewController:selectLocationMapVC animated:YES];
        } else {
            SelectLocationMapController * selectLocationMapVC = [[SelectLocationMapController alloc]init];
            selectLocationMapVC.city = self.transportOrder.endCity;
            selectLocationMapVC.selectReturnBlock = ^(NSString * _Nonnull city, NSString * _Nonnull detailAddress, CLLocationCoordinate2D coordinate) {
                valueAdd.serviceValue = [NSString stringWithFormat:@"%@%@",city,detailAddress];
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
    if (indexPath.row == 2 || indexPath.row == 3) {
        valueAdd.serviceShowInputArea = valueAdd.serviceIsSelected;
    }
    [self.tableView reloadData];
}
-(void)valueAddCellTapContract:(TransportOrderValueAddCell *)cell {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    TransportValueAdd * valueAdd = (TransportValueAdd *)self.transportValueAddArray[indexPath.row];
    MSLog(@"点击Contract: %@",valueAdd.serviceContract);
}

#pragma mark - footer view delegate
-(void)transportOrderFooterTapOrder{
    MSLog(@"点击预定");
    TransportPayViewController * transportPayVC = [[TransportPayViewController alloc]init];
    [self.navigationController pushViewController:transportPayVC animated:YES];
}
-(void)transportOrderFooterTapCall {
    MSLog(@"点击客服电话");
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


#pragma mark - setters and getters
-(TransportOrder *)transportOrder{
    if (!_transportOrder) {
        _transportOrder = [[TransportOrder alloc]init];
    }
    return _transportOrder;
}

-(NSArray<id<TransportTypeProtocol>> *)transportTypeArray{
    if (!_transportTypeArray) {
        
        TransportTypeViewModel * type_2 = [[TransportTypeViewModel alloc]init];
        type_2.normalTitle = @"铁路";
        type_2.normalIconName = IconFont_Train;
        type_2.typeIsDisable = NO;
        
        
        TransportTypeViewModel * type_3 = [[TransportTypeViewModel alloc]init];
        type_3.normalTitle = @"单飞";
        type_3.normalIconName = IconFont_AirPlane;
        type_3.typeIsDisable = NO;
        
        
        TransportTypeViewModel * type_4 = [[TransportTypeViewModel alloc]init];
        type_4.normalTitle = @"随机";
        type_4.normalIconName = IconFont_AirPlane;
        type_4.typeIsDisable = NO;
        
        
        TransportTypeViewModel * type_5 = [[TransportTypeViewModel alloc]init];
        type_5.normalTitle = @"大巴";
        type_5.normalIconName = IconFont_Car;
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
        onDoor.serviceEnableUse = YES;
        onDoor.serviceName = @"上门接宠";
        onDoor.serviceContract = @"接宠说明";
        onDoor.serviceValuePlaceholder = @"请选择接宠地址";
        
        // 送宠到家
        TransportValueAdd * toHome = [[TransportValueAdd alloc]init];
        toHome.serviceEnableUse = YES;
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
