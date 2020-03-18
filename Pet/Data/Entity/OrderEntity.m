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
        case OrderTransport_TransportType_Code_Zhuanche:
            return @"专车";
        case OrderTransport_TransportType_Code_Huoche:
            return @"铁路";
        case OrderTransport_TransportType_Code_Danfei:
            return @"单飞";
        case OrderTransport_TransportType_Code_Suiji:
            return @"随机";
        case OrderTransport_TransportType_Code_Daba:
            return @"大巴";
        default:
            return @"未知";
    }
}
@end

@implementation OrderTransportInfo

@end

@implementation AddedInsure

@end

@implementation AddedWeightCage

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
-(OrderTransportInfo *)orderTransport{
    if (!_orderTransport) {
        _orderTransport = [[OrderTransportInfo alloc]init];
    }
    return _orderTransport;
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
-(NSArray<OrderPremium *> *)orderPremiumList{
    if (!_orderPremiumList) {
        _orderPremiumList = @[];
    }
    return _orderPremiumList;
}
-(NSArray<OrderRemarks *> *)orderRemarksList{
    if (!_orderRemarksList) {
        _orderRemarksList = @[];
    }
    return _orderRemarksList;
}

-(OrderTempDeliver *)waitAddTempDelivers{
    if (!_waitAddTempDelivers) {
        _waitAddTempDelivers = [[OrderTempDeliver alloc]init];
    }
    return _waitAddTempDelivers;
}
@end

@implementation OrderEvaluate

@end
