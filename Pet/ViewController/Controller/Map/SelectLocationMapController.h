//
//  SelectLocationMapController.h
//  Pet
//
//  Created by mac on 2020/1/8.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectLocationReturnBlock)(NSString * city, NSString * detailAddress, CLLocationCoordinate2D coordinate);
@interface SelectLocationMapController : UIViewController
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * detailAddress;
@property (nonatomic, copy) SelectLocationReturnBlock selectReturnBlock;
@end

NS_ASSUME_NONNULL_END
