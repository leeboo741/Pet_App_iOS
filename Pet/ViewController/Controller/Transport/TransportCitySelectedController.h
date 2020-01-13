//
//  TransportCitySelectedController.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CitySelectedType) {
    CitySelectedType_Start,
    CitySelectedType_End,
};

typedef void(^SelectCityBlock)(NSString *cityName);

@interface TransportCitySelectedController : UIViewController
@property (nonatomic, assign) CitySelectedType type;
@property (nonatomic, copy) SelectCityBlock selectCityBlock;
@end

NS_ASSUME_NONNULL_END
