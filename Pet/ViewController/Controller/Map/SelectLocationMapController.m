//
//  SelectLocationMapController.m
//  Pet
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SelectLocationMapController.h"
#import <QMapKit/QMapKit.h>
#import "LocationManager.h"

@interface SelectLocationMapController ()<QMapViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) QMapView * mapView;
@property (nonatomic, strong) QPointAnnotation * selectAnnotation;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) UIButton * confirmSearchButton;
@property (nonatomic, copy) NSString * searchContent;

@property (nonatomic, copy) NSString * selectedCity;
@property (nonatomic, copy) NSString * selectDetailAddress;
@end

@implementation SelectLocationMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择地点";
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.confirmSearchButton];
    [self.view bringSubviewToFront:self.searchTextField];
    [self.view bringSubviewToFront:self.confirmSearchButton];
    
    // 如果传入城市为空，按照自己当前定位位置来确定城市
    // 如果传入城市不为空，按照传入城市定位
    // 如果传入详细地址也不为空，按照传入城市和详细地址定位
    if (kStringIsEmpty(self.city)) {
        [[LocationManager shareLocationManager] requestLocationWithLocationChangeObserver:self selector:@selector(locationUpdate:)];
    } else {
        [self spliceAddress];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.searchTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(navigationBarAndStatusBarHeight + 10);
        make.height.mas_equalTo(50);
        make.width.equalTo(self.view).multipliedBy(0.96);
    }];
    
    [self.confirmSearchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - location manager notification

-(void)locationUpdate:(NSNotification *)notification{
    CLLocation * location = [notification.userInfo objectForKey:NOTIFICATION_CURRENT_LOCATION_KEY];
    [self resetMapCenterWithCoordinate:location.coordinate];
}

#pragma mark - mapview delegate

// 地图加载失败
-(void)mapViewDidFailLoadingMap:(QMapView *)mapView withError:(NSError *)error{
    MSLog(@"地图加载失败 : %@",error);
}

// 配置annotation view
-(QAnnotationView *)mapView:(QMapView *)mapView
          viewForAnnotation:(id<QAnnotation>)annotation {
    static NSString *pointReuseIndentifier = @"pointReuseIdentifier";
 
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        //添加默认pinAnnotation
        if ([annotation isEqual:self.selectAnnotation]) {
            QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil) {
                annotationView = [[QPinAnnotationView alloc]
                                  initWithAnnotation:annotation
                                  reuseIdentifier:pointReuseIndentifier];
            }
            //显示气泡，默认NO
            annotationView.canShowCallout = NO;
            //设置大头针颜色
            annotationView.pinColor = QPinAnnotationColorRed;
            //可以拖动
            annotationView.draggable = NO;
            annotationView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Location_2, 32, Color_red_1)];
            return annotationView;
        }
    }
    return nil;
}

//-(void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view didChangeDragState:(QAnnotationViewDragState)newState fromOldState:(QAnnotationViewDragState)oldState{
//    if (view.annotation == self.selectAnnotation && newState == QAnnotationViewDragStateEnding) {
//        view.annotation.coordinate
//    }
//}

#pragma mark - textfield delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.searchContent = text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!kStringIsEmpty(self.searchContent)) {
        __weak typeof(self) weakSelf = self;
        [[LocationManager shareLocationManager] geocoderAddress:self.searchContent resultBlock:^(CLLocationCoordinate2D coordinate) {
            [weakSelf resetMapCenterWithCoordinate:coordinate];
        }];
    }
    return YES;
}

#pragma mark - gesture recognizer delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - private method

// 添加标注
-(void)addMarkToMapWithLocation:(CLLocationCoordinate2D)coordinate{
    
    __weak typeof(self) weakSelf = self;
    CLLocation * location = [[LocationManager shareLocationManager] getLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [[LocationManager shareLocationManager] geocoderLocation:location resultBlock:^(CLPlacemark * _Nonnull place) {
        NSString * city = place.locality;
        if (!city) {
            city = place.administrativeArea;
        }
        if (![city isEqualToString:self.city] && !kStringIsEmpty(self.city)) {
            [MBProgressHUD showTipMessageInWindow:@"选择位置超出城市范围"];
            return;
        }
        NSString * disctict = place.subLocality;
        NSString * street = @"";
        if (!kStringIsEmpty(place.thoroughfare)) street = place.thoroughfare;
        NSString * name = @"";
        if (!kStringIsEmpty(place.name)) name = place.name;
        weakSelf.selectedCity = city;
        weakSelf.city = city;
        weakSelf.selectDetailAddress = [NSString stringWithFormat:@"%@%@",disctict,name];
        weakSelf.searchTextField.text = [NSString stringWithFormat:@"%@%@",weakSelf.selectedCity,weakSelf.selectDetailAddress];
        
        QPointAnnotation * annotation = [[QPointAnnotation alloc]init];
        annotation.coordinate = coordinate;
        [weakSelf.mapView removeAnnotation:weakSelf.selectAnnotation];
        weakSelf.selectAnnotation = annotation;
        [weakSelf.mapView addAnnotation:annotation];
    }];
}

// 拼接传入的城市和详细地址
// 解析地址成坐标
// 定位地图到当前位置
-(void)spliceAddress{
    NSString * address = nil;
    NSString * tempCity = self.city;
    NSString * tempAddress = @"";
    if (!kStringIsEmpty(self.detailAddress)) {
        tempAddress = self.detailAddress;
    }
    address = [NSString stringWithFormat:@"%@%@",tempCity,tempAddress];
    self.searchTextField.text = address;
    __weak typeof(self) weakSelf = self;
    [[LocationManager shareLocationManager] geocoderAddress:address resultBlock:^(CLLocationCoordinate2D coordinate) {
        [weakSelf resetMapCenterWithCoordinate:coordinate];
    }];
}

// 设置地图中心点
-(void)resetMapCenterWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self.mapView.centerCoordinate = coordinate;
    [self addMarkToMapWithLocation:coordinate];
}

#pragma mark - event action

// 点击确定按钮
-(void)tapConfirm{
    if (self.selectReturnBlock) {
        self.selectReturnBlock(self.selectedCity, self.selectDetailAddress, self.selectAnnotation.coordinate);
    }
}

// 点击地图
-(void)tapMap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationOfTouch:0 inView:_mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self addMarkToMapWithLocation:coordinate];
}

#pragma mark - setters and getters

-(QMapView *)mapView{
    if (!_mapView) {
        _mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.zoomLevel = 16;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMap:)];
        tap.delegate = self;
        [_mapView addGestureRecognizer:tap];
    }
    return _mapView;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.borderColor = Color_gray_1.CGColor;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.placeholder = @"请输入要定位的地址";
        _searchTextField.backgroundColor = Color_white_1;
        _searchTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTextField;
}

-(UIButton *)confirmSearchButton{
    if (!_confirmSearchButton) {
        _confirmSearchButton = [[UIButton alloc]init];
        _confirmSearchButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _confirmSearchButton.backgroundColor = Color_red_1;
        [_confirmSearchButton setTitleColor:Color_white_1 forState:UIControlStateNormal];
        [_confirmSearchButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmSearchButton addTarget:self action:@selector(tapConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmSearchButton;
}



@end
