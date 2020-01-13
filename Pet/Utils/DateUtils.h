//
//  DateUtils.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * Formatter_YMD = @"yyyy-MM-dd";
static NSString * Formatter_YMDHMS = @"yyyy-MM-dd HH:mm:ss";
static NSString * Formatter_HMS = @"HH:mm:ss";

@interface DateUtils : NSObject
SingleInterface(DateUtils);
/**
 获取 相对于目标时间 N年 N月 N日之后的 时间
 
 @param date 目标时间
 @param year 差距年份
 @param month 差距月份
 @param day 差距天数
 */
-(NSDate *)getDateWithTargetDate:(NSDate *)date durationYear:(NSInteger)year durationMonth:(NSInteger)month durationDay:(NSInteger)day;

/**
 通过 string 获取 date
 
 @param dateString 时间字符串
 @param formatterStr 时间格式
 */
-(NSDate *)getDateWithDateString:(NSString *)dateString withFormatterStr:(NSString *)formatterStr;

/**
 通过 date 获取 string
 
 @param date 时间
 @param formatterStr 时间格式
 */
-(NSString *)getDateStringWithDate:(NSDate *)date withFormatterStr:(NSString *)formatterStr;
@end

NS_ASSUME_NONNULL_END
