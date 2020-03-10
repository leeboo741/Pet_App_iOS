//
//  Station.m
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "Station.h"

@implementation Station
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"stationId":@"businessNo",
             @"stationName":@"businessName",
             @"phoneNumber":@"phoneNumber",
             @"businessStartTime":@"startBusinessHours",
             @"businessEndTime":@"endBusinessHours",
             @"longitude":@"longitude",
             @"latitude":@"latitude",
             @"province":@"province",
             @"city":@"city",
             @"detailAddress":@"detailAddress",
             @"logoImagePath":@"iconAddress",
             @"state":@"state",
             @"businessType":@"businessType",
             @"businessServices":@"businessService",
             };
}
@end
