//
//  LocationManager.h
//  Pet
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * NOTIFICATION_CURRENT_LOCATION_CHANGE_NAME = @"CURRENT_LOCATION_CHANGE_NAME";
static NSString * NOTIFICATION_CURRENT_LOCATION_KEY = @"CURRENT_LOCATION_KEY";

@interface LocationManager : NSObject
SingleInterface(LocationManager);
// 通过经纬度 解析 地址
-(void)geocoderLocation:(CLLocation *)location resultBlock:(void(^)(CLPlacemark * place))resultBlock;
// 通过地址 解析经纬度
-(void)geocoderAddress:(NSString *)address resultBlock:(void(^)(CLLocationCoordinate2D coordinate))resultBlock;
// 通过 经纬度 获取 CLLocation 对象
-(CLLocation *)getLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
// 添加 位置改变通知监听
-(void)addCurrentLocationChangeNotificationObserver:(id)observer selector:(SEL)selector;
// 移除 位置改变通知监听
-(void)currentLocationChangeNotificationRemoveObserver:(id)observer;
// 请求定位 并监听位置改变通知
-(void)requestLocationWithLocationChangeObserver:(id)observer selector:(SEL)selector;
// 获取当前位置
-(CLLocation *)getLocation;
@end

NS_ASSUME_NONNULL_END
