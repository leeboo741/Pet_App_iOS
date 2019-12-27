//
//  Utils.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Util_IsPhoneString(Str) [Utils isPhoneString:Str]
#define Util_IsNumberString(Str) [Utils isNumberString:Str]
#define Util_IsEmptyString(Str) [Utils isEmptyString:Str]
#define Util_IsEmptyArray(Arr) [Utils isEmptyArray:Arr]
#define Util_IsEmptyDict(Dict) [Utils isEmptyDict:Dict]

#define Util_GetCurrentVC [Utils getCurrentViewController];

@interface Utils : NSObject

/**
 是否是电话
 
 @param string 字符串
 @return true 是 false 不是
 */
+(BOOL)isPhoneString:(NSString *)string;

/**
 是否是字符串数字

 @param string 字符串
 @return true 是 false 不是
 */
+(BOOL)isNumberString:(NSString *)string;

/**
 是否是空字串

 @param string 字符串
 @return true 是 false 不是
 */
+(BOOL)isEmptyString:(NSString *)string;

/**
 是否是空数组

 @param array 数组
 @return true 是 false 不是
 */
+(BOOL)isEmptyArray:(NSArray *)array;

/**
 是否是空字典

 @param dict 字典
 @return true 是 false 不是
 */
+(BOOL)isEmptyDict:(NSDictionary *)dict;

/**
 获取当前的viewController

 @return viewController
 */
+(UIViewController *)getCurrentViewController;

@end

NS_ASSUME_NONNULL_END
