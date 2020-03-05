//
//  BusinessDataBaseHandler.m
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BusinessDataBaseHandler.h"

@implementation BusinessDataBaseHandler

#pragma mark - insert
+(BOOL)insertBusiness:(BusinessEntity *)business{
    FMDatabase * dataBase = [SqliteBase getDatabase];
    NSString * sqlStr;
    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
              Table_Business_TableName,
              Table_Business_BusinessNo,
              Table_Business_BusinessName,
              Table_Business_IconAddress,
              Table_Business_PhoneNumber,
              Table_Business_BondAmount,
              Table_Business_RegisterTime,
              Table_Business_StartBusinessTime,
              Table_Business_EndBusinessTime,
              Table_Business_BusinessService,
              Table_Business_BusinessType,
              Table_Business_Describes,
              Table_Business_Longitude,
              Table_Business_Latitude,
              Table_Business_BusinessDegree,
              Table_Business_Province,
              Table_Business_City,
              Table_Business_DetailAddress,
              Table_Business_State,
              Table_Business_Contact,
              Table_Business_ContactPhone,
              Table_Business_NickName,
              Table_Business_HeaderImage,
              Table_Business_OpenId,
              Table_Business_UnionId];
    BOOL a = [dataBase executeUpdate:sqlStr,
              business.businessNo,
              business.businessName,
              business.iconAddress,
              business.phoneNumber,
              business.bondAmount,
              business.registerTime,
              business.startBusinessHours,
              business.endBusinessHours,
              business.businessService,
              business.businessType,
              business.describes,
              business.longitude,
              business.latitude,
              business.businessDegree,
              business.province,
              business.city,
              business.detailAddress,
              business.state,
              business.contacts,
              business.contactPhone,
              business.nickName,
              business.headerImg,
              business.openId,
              business.unionId];
    if (!a) {
        MSLog(@"business表数据插入失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return YES;
}

#pragma mark - update
+(BOOL)updateBusiness:(BusinessEntity *)business{
    if ([BusinessDataBaseHandler existBusinessWithBusinessNo:business.businessNo]) {
        [BusinessDataBaseHandler deleteBusinessWithBusinessNo:business.businessNo];
        return [BusinessDataBaseHandler insertBusiness:business];
    } else {
        return [BusinessDataBaseHandler insertBusiness:business];
    }
}

#pragma mark - select
+(BusinessEntity *)getBusinessWithBusinessNo:(NSString *)businessNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",Table_Business_TableName, Table_Business_BusinessNo , businessNo];
    MSLog(@"获取business表数据:");
    MSLog(@"%@",sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];
    BusinessEntity * business = nil;
    while ([resultSet next]) {
        business = [[BusinessEntity alloc]init];
        business.businessNo = [resultSet stringForColumn:Table_Business_BusinessNo];
        business.businessName = [resultSet stringForColumn:Table_Business_BusinessName];
        business.iconAddress = [resultSet stringForColumn:Table_Business_IconAddress];
        business.phoneNumber = [resultSet stringForColumn:Table_Business_PhoneNumber];
        business.bondAmount = [resultSet stringForColumn:Table_Business_BondAmount];
        business.registerTime = [resultSet stringForColumn:Table_Business_RegisterTime];
        business.startBusinessHours = [resultSet stringForColumn:Table_Business_StartBusinessTime];
        business.endBusinessHours = [resultSet stringForColumn:Table_Business_EndBusinessTime];
        business.businessService = [resultSet stringForColumn:Table_Business_BusinessService];
        business.businessType = [resultSet intForColumn:Table_Business_BusinessType];
        business.describes = [resultSet stringForColumn:Table_Business_Describes];
        business.longitude = [resultSet doubleForColumn:Table_Business_Longitude];
        business.latitude = [resultSet doubleForColumn:Table_Business_Latitude];
        business.businessDegree = [resultSet stringForColumn:Table_Business_BusinessDegree];
        business.province = [resultSet stringForColumn:Table_Business_Province];
        business.city = [resultSet stringForColumn:Table_Business_Province];
        business.detailAddress = [resultSet stringForColumn:Table_Business_DetailAddress];
        business.state = [resultSet intForColumn:Table_Business_State];
        business.contacts = [resultSet stringForColumn:Table_Business_Contact];
        business.contactPhone = [resultSet stringForColumn:Table_Business_ContactPhone];
        business.nickName = [resultSet stringForColumn:Table_Business_NickName];
        business.headerImg = [resultSet stringForColumn:Table_Business_HeaderImage];
        business.openId = [resultSet stringForColumn:Table_Business_OpenId];
        business.unionId = [resultSet stringForColumn:Table_Business_UnionId];
    }
    [SqliteBase closeDatabase];
    return business;
}
+(BOOL)existBusinessWithBusinessNo:(NSString *)businessNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = '%@'",Table_Business_TableName,Table_Business_BusinessNo,businessNo];
    MSLog(@"统计business表数据数量:");
    MSLog(@"%@",sqlStr);
    NSInteger count = [database intForQuery:sqlStr];
    [SqliteBase closeDatabase];
    if (count <= 0) {
        return NO;
    }
    return YES;
}
#pragma mark - delete
+(BOOL)clearBusinessTable{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@", Table_Business_TableName];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"business表数据删除失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteBusinessWithBusinessNo:(NSString *)businessNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", Table_Business_TableName,Table_Business_BusinessNo,businessNo];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"business表 '%@'数据 删除失败:",businessNo);
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteBusinessTable{
    SqliteBase *sqlite = [SqliteBase shareInstance];
    [sqlite getReadableDatabase];
    BOOL result = [sqlite deleteTable:Table_Business_TableName];
    if (!result) {
        MSLog(@"删除business表失败");
    }
    [sqlite closeDataBase];
    return result;
}
@end
