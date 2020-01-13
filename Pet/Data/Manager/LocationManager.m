//
//  LocationManager.m
//  Pet
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder * geocoder;
@property (nonatomic, strong) CLLocation * currentLocation;
@end

@implementation LocationManager
SingleImplementation(LocationManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    
}

#pragma mark - location manager delegate
// 定位 改变 回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    self.currentLocation = locations[0];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENT_LOCATION_CHANGE_NAME object:self userInfo:@{NOTIFICATION_CURRENT_LOCATION_KEY:self.currentLocation}];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [MBProgressHUD showErrorMessage:@"定位失败"];
}

#pragma mark - private method



#pragma mark - public method

// 通过 经纬度 获取 CLLocation 对象
-(CLLocation *)getLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    return location;
}

// 通过地址 解析经纬度
-(void)geocoderAddress:(NSString *)address resultBlock:(void(^)(CLLocationCoordinate2D coordinate))resultBlock{
    if (self.geocoder.isGeocoding) {
        [self.geocoder cancelGeocode];
    }
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks[0];
        if (resultBlock) {
            resultBlock(placemark.location.coordinate);
        }
    }];
}

// 通过经纬度 解析 地址
-(void)geocoderLocation:(CLLocation *)location resultBlock:(void(^)(CLPlacemark * place))resultBlock {
    if (self.geocoder.isGeocoding) {
        [self.geocoder cancelGeocode];
    }
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks[0];
        if (resultBlock) {
            resultBlock(placemark);
        }
    }];
}

// 获取当前定位
-(CLLocation *)getLocation{
    return self.currentLocation;
}

// 请求定位 并监听位置改变通知
-(void)requestLocationWithLocationChangeObserver:(id)observer selector:(SEL)selector{
    [self addCurrentLocationChangeNotificationObserver:observer selector:selector];
    [self.locationManager stopUpdatingLocation];
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [self.locationManager startUpdatingLocation];
                break;
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
            {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"需要授权定位权限" message:@"我们需要您的授权以供在下单，申请等等功能中定位，用以更好的提供服务。您可以在系统设置中打开授权。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:confirmAction];
                UIViewController * currentVC = Util_GetCurrentVC;
                [currentVC presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

// 添加 位置改变通知监听
-(void)addCurrentLocationChangeNotificationObserver:(id)observer selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NOTIFICATION_CURRENT_LOCATION_CHANGE_NAME object:self];
}

// 移除 位置改变通知监听
-(void)currentLocationChangeNotificationRemoveObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:NOTIFICATION_CURRENT_LOCATION_CHANGE_NAME object:self];
}

#pragma mark - setters and getters

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    }
    return _locationManager;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}
@end
