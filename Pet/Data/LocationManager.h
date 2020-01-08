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

static NSString * NOTIFICATION_CURRENT_LOCATION_CHANGE = @"currentLocationChange";

@interface LocationManager : NSObject
SingleInterface(LocationManager);
-(CLLocation *)getCurrentLocation;
-(void)geocoderLocation:(CLLocation *)location resultBlock:(void(^)(CLPlacemark * place))resultBlock;
-(void)geocoderAddress:(NSString *)address resultBlock:(void(^)(CLLocationCoordinate2D coordinate))resultBlock;
-(CLLocation *)getLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
-(void)addCurrentLocationChangeNotificationObserver:(id)observer selector:(SEL)selector;
-(void)currentLocationChangeNotificationRemoveObserver:(id)observer;
@end

NS_ASSUME_NONNULL_END
