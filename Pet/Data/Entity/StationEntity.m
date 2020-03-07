//
//  StationEntity.m
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "StationEntity.h"

@implementation StationEntity
-(NSString *)stationNo{
    return !_stationNo?@"":_stationNo;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.stationName forKey:@"stationName"];
    [coder encodeObject:self.stationNo forKey:@"stationNo"];
    [coder encodeObject:self.province forKey:@"province"];
    [coder encodeObject:self.district forKey:@"district"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.intoDate forKey:@"intoDate"];
    [coder encodeObject:self.transports forKey:@"transports"];
    [coder encodeObject:self.stationLicenseImage forKey:@"stationLicenseImage"];
    [coder encodeObject:self.idcardFrontImage forKey:@"idcardFrontImage"];
    [coder encodeObject:self.idcardBackImage forKey:@"idcardBackImage"];
    [coder encodeObject:self.startCity forKey:@"startCity"];
    [coder encodeObject:self.airport forKey:@"airport"];
    [coder encodeObject:self.openId forKey:@"openId"];
    [coder encodeObject:self.contact forKey:@"contact"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeInt64:self.state forKey:@"state"];
    [coder encodeDouble:self.lng forKey:@"lng"];
    [coder encodeDouble:self.lat forKey:@"lat"];
    [coder encodeInt64:self.transportType forKey:@"transportType"];
    [coder encodeObject:self.partners forKey:@"partners"];
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.stationName = [coder decodeObjectForKey:@"stationName"];
        self.stationNo = [coder decodeObjectForKey:@"stationNo"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.district = [coder decodeObjectForKey:@"district"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.intoDate = [coder decodeObjectForKey:@"intoDate"];
        self.transports = [coder decodeObjectForKey:@"transports"];
        self.stationLicenseImage = [coder decodeObjectForKey:@"stationLicenseImage"];
        self.idcardBackImage = [coder decodeObjectForKey:@"idcardBackImage"];
        self.idcardFrontImage = [coder decodeObjectForKey:@"idcardFrontImage"];
        self.startCity = [coder decodeObjectForKey:@"startCity"];
        self.airport = [coder decodeObjectForKey:@"airport"];
        self.openId = [coder decodeObjectForKey:@"openId"];
        self.contact = [coder decodeObjectForKey:@"contact"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.state = [coder decodeIntForKey:@"state"];
        self.lng = [coder decodeDoubleForKey:@"lng"];
        self.lat = [coder decodeDoubleForKey:@"lat"];
        self.transportType = [coder decodeIntForKey:@"transportType"];
        self.partners = [coder decodeObjectForKey:@"partners"];
    }
    return self;
}
@end
