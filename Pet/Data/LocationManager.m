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
        [self locationManager];
        [self addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentLocation"];
}

#pragma mark - location manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = locations[0];
}

#pragma mark - private method



#pragma mark - public method

-(CLLocation *)getLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    return location;
}

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

-(CLLocation *)getCurrentLocation{
    return self.currentLocation;
}

-(void)addCurrentLocationChangeNotificationObserver:(id)observer selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NOTIFICATION_CURRENT_LOCATION_CHANGE object:self];
}

-(void)currentLocationChangeNotificationRemoveObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:NOTIFICATION_CURRENT_LOCATION_CHANGE object:self];
}

#pragma mark - kvo

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentLocation"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CURRENT_LOCATION_CHANGE object:self userInfo:nil];
    }
}

#pragma mark - setters and getters

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [_locationManager startUpdatingLocation];
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
