//
//  SelectLocationMapController.m
//  Pet
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "SelectLocationMapController.h"
#import <QMapKit/QMapKit.h>

@interface SelectLocationMapController ()<QMapViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) QMapView * mapView;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) UIButton * confirmSearchButton;
@property (nonatomic, copy) NSString * searchContent;
@end

@implementation SelectLocationMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.confirmSearchButton];
    [self.view bringSubviewToFront:self.searchTextField];
    [self.view bringSubviewToFront:self.confirmSearchButton];
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

#pragma mark - mapview delegate

// 将要启动定位
-(void)mapViewWillStartLocatingUser:(QMapView *)mapView{
    
}

// 已经定位停止
-(void)mapViewDidStopLocatingUser:(QMapView *)mapView{
    
}

// 定位失败
-(void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
}

// 地图加载失败
-(void)mapViewDidFailLoadingMap:(QMapView *)mapView withError:(NSError *)error{
    MSLog(@"地图加载失败 : %@",error);
}

// 刷新位置
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        [mapView setCenterCoordinate:userLocation.coordinate];
    }
}

#pragma mark - textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.searchContent = text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

#pragma mark - private method

-(void)spliceAddress{
    NSString * address = @"";
    NSString * tempCity = @"";
    NSString * tempDetailAddress = @"";
    if (!kStringIsEmpty(self.city)) {
        tempCity = self.city;
    }
    if (!kStringIsEmpty(self.detailAddress)) {
        tempDetailAddress = self.detailAddress;
    }
    address = [NSString stringWithFormat:@"%@%@",tempCity,tempDetailAddress];
    self.searchTextField.text = address;
}


#pragma mark - setters and getters

-(QMapView *)mapView{
    if (!_mapView) {
        _mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel = 16;
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
    }
    return _confirmSearchButton;
}

-(void)setCity:(NSString *)city{
    _city = city;
}

-(void)setDetailAddress:(NSString *)detailAddress{
    _detailAddress = detailAddress;
}



@end
