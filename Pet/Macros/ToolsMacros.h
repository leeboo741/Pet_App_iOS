//
//  ToolsMacros.h
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#ifndef ToolsMacros_h
#define ToolsMacros_h

#pragma mark - 常用方法

// 是否为空
#define kStringIsEmpty(str) ([str isEqualToString:@"(null)"]||[str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO ) // 字符串
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) // 数组
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0) // 字典
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0)) // 对象


// 强引用 弱引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

// 角度 弧度 转化
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

// 十六进制颜色

#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kRandomColor           kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

// 字体
#define kFontSize(size)  [UIFont systemFontOfSize:size]
#define kBlodFontSize(size) [UIFont boldSystemFontOfSize:size]

// 数值
#define kFloatNumber(value) [NSNumber numberWithFloat:value]
#define kDoubleNumber(value) [NSNumber numberWithDouble:value]
#define kIntNumber(value) [NSNumber numberWithInt:value]
#define kIntegerNumber(value) [NSNumber numberWithInteger:value]
#define kLongNumber(value) [NSNumber numberWithLong:value]
#define kBoolNumber(value) [NSNumber numberWithBool:value]

#define k

#pragma mark - 系统方法 缩写

// 缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 获取沙盒路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取temp文件路径
#define kTempPath NSTemporaryDirectory()
// 获取cache文件路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark - 设备相关信息

// 软件版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#define IOS_7  [[UIDevice currentDevice].systemVersion floatValue] >= 7.0
#define IOS_8  [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define IOS_9  [[UIDevice currentDevice].systemVersion floatValue] >= 9.0
#define IOS_10 [[UIDevice currentDevice].systemVersion floatValue] >= 10.0
// 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
// 判断设备类型
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_X_orMore (IS_IPHONE_X==YES || IS_IPHONE_Xr== YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)

// 获取屏幕宽高
#define Device_Width  [[UIScreen mainScreen] bounds].size.width
#define Device_Height [[UIScreen mainScreen] bounds].size.height

#define kStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height


#endif /* ToolsMacros_h */
