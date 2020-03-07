//
//  BusinessEntity.m
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BusinessEntity.h"

@implementation BusinessEntity
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"contactPhone":@"phone"
    };
}
-(NSString *)businessNo{
    return !_businessNo?@"":_businessNo;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.businessNo = [coder decodeObjectForKey:@"businessNo"];
        self.businessName = [coder decodeObjectForKey:@"businessName"];
        self.iconAddress = [coder decodeObjectForKey:@"iconAddress"];
        self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
        self.bondAmount = [coder decodeObjectForKey:@"bondAmount"];
        self.registerTime = [coder decodeObjectForKey:@"registerTime"];
        self.startBusinessHours = [coder decodeObjectForKey:@"startBusinessHours"];
        self.endBusinessHours = [coder decodeObjectForKey:@"endBusinessHours"];
        self.businessService = [coder decodeObjectForKey:@"businessService"];
        self.businessType = [coder decodeIntForKey:@"businessType"];
        self.describes = [coder decodeObjectForKey:@"describes"];
        self.longitude = [coder decodeDoubleForKey:@"longitude"];
        self.latitude = [coder decodeDoubleForKey:@"latitude"];
        self.businessDegree = [coder decodeObjectForKey:@"businessDegree"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.detailAddress = [coder decodeObjectForKey:@"detailAddress"];
        self.state = [coder decodeIntForKey:@"state"];
        self.contacts = [coder decodeObjectForKey:@"contacts"];
        self.contactPhone = [coder decodeObjectForKey:@"contactPhone"];
        self.nickName = [coder decodeObjectForKey:@"nickName"];
        self.headerImg = [coder decodeObjectForKey:@"headerImg"];
        self.openId = [coder decodeObjectForKey:@"openId"];
        self.unionId = [coder decodeObjectForKey:@"unionId"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.businessName forKey:@"businessName"];
    [coder encodeObject:self.businessNo forKey:@"businessNo"];
    [coder encodeObject:self.iconAddress forKey:@"iconAddress"];
    [coder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:self.bondAmount forKey:@"bondAmount"];
    [coder encodeObject:self.registerTime forKey:@"registerTime"];
    [coder encodeObject:self.startBusinessHours forKey:@"startBusinessHours"];
    [coder encodeObject:self.endBusinessHours forKey:@"endBusinessHours"];
    [coder encodeObject:self.businessService forKey:@"businessService"];
    [coder encodeInt:self.businessType forKey:@"businessType"];
    [coder encodeObject:self.describes forKey:@"describes"];
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeObject:self.businessDegree forKey:@"businessDegree"];
    [coder encodeObject:self.province forKey:@"province"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:self.detailAddress forKey:@"detailAddress"];
    [coder encodeInt:self.state forKey:@"state"];
    [coder encodeObject:self.contactPhone forKey:@"contactPhone"];
    [coder encodeObject:self.contacts forKey:@"contacts"];
    [coder encodeObject:self.nickName forKey:@"nickName"];
    [coder encodeObject:self.headerImg forKey:@"headerImg"];
    [coder encodeObject:self.openId forKey:@"openId"];
    [coder encodeObject:self.unionId forKey:@"unionId"];
}
@end
