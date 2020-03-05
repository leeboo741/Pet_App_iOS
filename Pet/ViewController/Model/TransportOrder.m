//
//  TransportOrder.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportOrder.h"

@implementation TransportType

@end

@implementation TransportOrder
-(NSString *)customerNo{
    return [[UserManager shareUserManager] getCustomerNo];
}
-(TransportType *)transportType{
    if (!_transportType) {
        _transportType = [[TransportType alloc]init];
    }
    return _transportType;
}
@end
