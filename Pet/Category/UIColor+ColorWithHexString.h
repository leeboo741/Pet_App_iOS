//
//  UIColor+ColorWithHexString.h
//  BossModule
//
//  Created by YWKJ on 2018/5/21.
//  Copyright © 2018年 YWKJ. All rights reserved.
//
//  根据十六进制转换颜色

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHexString)
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
