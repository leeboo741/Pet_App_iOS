//
//  DateUtils.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "DateUtils.h"

@interface DateUtils ()
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) NSCalendar * calendar;
@property (nonatomic, strong) NSDateComponents * dateComponents;
@end

@implementation DateUtils
SingleImplementation(DateUtils);

#pragma mark - public method

-(NSDate *)getDateWithTargetDate:(NSDate *)date durationYear:(NSInteger)year durationMonth:(NSInteger)month durationDay:(NSInteger)day{
    [self setDateComponentsValueWithYear:year month:month day:day];
    NSDate * resultDate = [self.calendar dateByAddingComponents:self.dateComponents toDate:date options:0];
    return resultDate;
}

-(NSString *)getDateStringWithDate:(NSDate *)date withFormatterStr:(NSString *)formatterStr{
    [self.dateFormatter setDateFormat:formatterStr];
    return [self.dateFormatter stringFromDate:date];
}

-(NSDate *)getDateWithDateString:(NSString *)dateString withFormatterStr:(NSString *)formatterStr{
    [self.dateFormatter setDateFormat:formatterStr];
    return [self.dateFormatter dateFromString:dateString];
}

#pragma mark - private method

-(void)setDateComponentsValueWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    [self.dateComponents setYear:year];
    [self.dateComponents setMonth:month];
    [self.dateComponents setDay:day];
}

#pragma mark - setters and getters

-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}

-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

-(NSDateComponents *)dateComponents{
    if (!_dateComponents) {
        _dateComponents = [[NSDateComponents alloc]init];
    }
    return _dateComponents;
}
@end
