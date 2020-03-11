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
    OrderPremium * premium1 = [[OrderPremium alloc]init];
    premium1.amount = 132.1;
    premium1.billNo = @"123123123";
    premium1.orderNo = @"232323";
    premium1.orderDate = @"2010-10-10";
    premium1.orderTime = @"12:11:11";
    premium1.reason = @"ceshiceshi";
    premium1.state = @"待付款";
    
    OrderPremium * premium2 = [[OrderPremium alloc]init];
    premium2.amount = 12.22;
    premium2.billNo = @"123123123";
    premium2.orderNo = @"232323";
    premium2.orderDate = @"2010-10-10";
    premium2.orderTime = @"12:11:11";
    premium2.reason = @"ceshiceshi1";
    premium2.state = @"已付款";
    
    OrderPremium * premium3 = [[OrderPremium alloc]init];
    premium3.amount = 200;
    premium3.billNo = @"123123123";
    premium3.orderNo = @"232323";
    premium3.orderDate = @"2010-10-10";
    premium3.orderTime = @"12:11:11";
    premium3.reason = @"ceshiceshi12";
    premium3.state = @"已取消";
    return @[premium1,premium2,premium3];
}
@end

@implementation OrderEvaluate

@end
