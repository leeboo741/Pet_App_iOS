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

@interface SelectLocationMapController : UIViewController
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * detailAddress;
@end

NS_ASSUME_NONNULL_END
