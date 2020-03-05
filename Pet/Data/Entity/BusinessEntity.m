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
@end
