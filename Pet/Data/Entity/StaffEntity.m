//
//  StaffEntity.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "StaffEntity.h"

@implementation StaffEntity
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"name":@"staffName"
    };
}
-(StationEntity *)station{
    if (!_station) {
        _station = [[StationEntity alloc]init];
    }
    return _station;
}
-(NSString *)staffNo{
    return !_staffNo?@"":_staffNo;
}
@end
