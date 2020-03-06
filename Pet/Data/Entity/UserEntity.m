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

-(USER_ROLE)role{
    if (kStringIsEmpty(self.customerNo)) {
        return USER_ROLE_UNKOWN;
    }
    if (kStringIsEmpty(self.staff.staffNo)
        && kStringIsEmpty(self.business.businessNo)) {
        return USER_ROLE_CUSTOMER;
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
                return USER_ROLE_CUSTOMER;
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
                return USER_ROLE_CUSTOMER;
        }
    }
    return USER_ROLE_UNKOWN;
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
@end
