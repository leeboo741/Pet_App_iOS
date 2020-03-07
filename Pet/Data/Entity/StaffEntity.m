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
-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.staffNo forKey:@"staffNo"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.openId forKey:@"openId"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.station forKey:@"station"];
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.staffNo = [coder decodeObjectForKey:@"staffNo"];
        self.openId = [coder decodeObjectForKey:@"openId"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.station = [coder decodeObjectForKey:@"station"];
    }
    return self;
}
@end
