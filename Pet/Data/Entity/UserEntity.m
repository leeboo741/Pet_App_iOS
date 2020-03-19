//
//  UserEntity.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UserEntity.h"

@interface UserEntity ()

@end

@implementation UserEntity
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"userName":@"customerName",
        @"avaterImagePath":@"headerImage",
        @"staffRole":@"role"
    };
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.currentRole = CURRENT_USER_ROLE_CUSTOMER;
    }
    return self;
}

-(NSString *)avaterImagePath{
    if (_avaterImagePath) {
        return [LeeUtils recoverySpecialChar:_avaterImagePath];
    }
    return nil;
}

-(NSString *)customerNo{
    if (!_customerNo) {
        _customerNo = @"";
    }
    return _customerNo;
}

-(USER_ROLE)userRole{
    if (kStringIsEmpty(self.customerNo)) {
        return USER_ROLE_UNKOWN;
    }
    if (!kStringIsEmpty(self.business.businessNo)
        && kStringIsEmpty(self.staff.staffNo)) {
        return USER_ROLE_BUSINESS;
    }
    if (!kStringIsEmpty(self.staff.staffNo)
        && kStringIsEmpty(self.business.businessNo)) {
        switch (self.staffRole) {
            case 1:
                return USER_ROLE_MANAGER;
            case 2:
                return USER_ROLE_DRIVER;
            case 3:
                return USER_ROLE_SERVICE;
            default:
                return USER_ROLE_SERVICE;
        }
    } else if (!kStringIsEmpty(self.staff.staffNo)
               && !kStringIsEmpty(self.business.businessNo)) {
        switch (self.staffRole) {
            case 1:
                return USER_ROLE_B_MANAGER;
            case 2:
                return USER_ROLE_B_DRIVER;
            case 3:
                return USER_ROLE_B_SERVICE;
            default:
                return USER_ROLE_B_SERVICE;
        }
    }
    return USER_ROLE_CUSTOMER;
}

-(StaffEntity *)staff{
    if (!_staff) {
        _staff = [[StaffEntity alloc]init];
    }
    return _staff;
}
-(BusinessEntity *)business{
    if (!_business) {
        _business = [[BusinessEntity alloc]init];
    }
    return _business;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInt64:self.currentRole forKey:@"currentRole"];
    [coder encodeInt:self.staffRole forKey:@"staffRole"];
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.customerNo forKey:@"customerNo"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.shareBusiness forKey:@"shareBusiness"];
    [coder encodeObject:self.shareStation forKey:@"shareStation"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.avaterImagePath forKey:@"avaterImagePath"];
    [coder encodeFloat:self.points forKey:@"points"];
    [coder encodeFloat:self.balance forKey:@"balance"];
    [coder encodeObject:self.unionId forKey:@"unionId"];
    [coder encodeObject:self.openId forKey:@"openId"];
    [coder encodeObject:self.lastLogintime forKey:@"lastLogintime"];
    [coder encodeObject:self.registrationDate forKey:@"registrationDate"];
    [coder encodeObject:self.staff forKey:@"staff"];
    [coder encodeObject:self.business forKey:@"business"];
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.currentRole = [coder decodeInt64ForKey:@"currentRole"];
        self.staffRole = [coder decodeIntForKey:@"staffRole"];
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.customerNo = [coder decodeObjectForKey:@"customerNo"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.shareBusiness = [coder decodeObjectForKey:@"shareBusiness"];
        self.shareStation = [coder decodeObjectForKey:@"shareStation"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.avaterImagePath = [coder decodeObjectForKey:@"avaterImagePath"];
        self.points = [coder decodeFloatForKey:@"points"];
        self.balance = [coder decodeFloatForKey:@"balance"];
        self.unionId = [coder decodeObjectForKey:@"unionId"];
        self.openId = [coder decodeObjectForKey:@"openId"];
        self.lastLogintime = [coder decodeObjectForKey:@"lastLogintime"];
        self.registrationDate = [coder decodeObjectForKey:@"registrationDate"];
        self.staff = [coder decodeObjectForKey:@"staff"];
        self.business = [coder decodeObjectForKey:@"business"];;
    }
    return self;
}
@end
