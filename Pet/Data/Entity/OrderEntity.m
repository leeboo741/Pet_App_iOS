//
//  OrderEntity.m
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderEntity.h"

@implementation PetType

@end

@implementation PetBreed
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"petBreedName":@"petClassifyName"
    };
}
@end

@implementation OrderTransport

-(NSString *)transportTypeName{
    switch (self.transportType) {
        case 1:
            return @"专车";
        case 2:
            return @"铁路";
        case 3:
            return @"单飞";
        case 4:
            return @"随机";
        case 5:
            return @"大巴";
        default:
            return @"未知";
    }
}
@end

@implementation AddedInsure

@end

@implementation OrderRemarks

@end

@implementation OrderTempDeliver

@end

@implementation OrderPremium

@end

@implementation OrderMedia

@end

@implementation OrderStatus
+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"orderMediaList":@"OrderMedia"
    };
}
@end

@implementation OrderEntity
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"orderState":@"state",
        @"assignmentedStaffArray":@"orderAssignments",
        @"orderAmount":@"paymentAmount",
        @"petBreed":@"petClassify",
        @"orderRemark":@"remarks",
        @"outportTime":@"leaveDate",
    };
}
+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"assignmentedStaffArray":@"StaffEntity",
        @"orderTempDelivers":@"OrderTempDeliver",
        @"orderPremiumList":@"OrderPremium",
        @"orderStates":@"OrderStatus",
        @"orderRemarksList":@"OrderRemarks"
    };
}
-(NSString *)assignmentedStaffString{
    NSString * string = @"";
    for (StaffEntity * staff in self.assignmentedStaffArray) {
        if (kStringIsEmpty(string)) {
            string = staff.name;
        } else {
            string = [string stringByAppendingFormat:@",%@",staff.name];
        }
    }
    return string;
}
-(NSArray<StaffEntity *> *)assignmentedStaffArray{
    if (!_assignmentedStaffArray) {
        _assignmentedStaffArray = @[];
    }
    return _assignmentedStaffArray;
}
@end
