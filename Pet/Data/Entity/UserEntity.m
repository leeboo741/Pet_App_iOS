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
        @"avaterImagePath":@"headerImage"
    };
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
