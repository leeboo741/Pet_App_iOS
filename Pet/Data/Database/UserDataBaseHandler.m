//
//  UserDataBaseHandler.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UserDataBaseHandler.h"

@implementation UserDataBaseHandler
#pragma mark -
#pragma mark Insert
+(BOOL)insertUser:(UserEntity *)user{

    FMDatabase * dataBase = [SqliteBase getDatabase];
    NSString * sqlStr;
    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
              Table_User_TableName,
              Table_User_StaffRole,
              Table_User_CurrentRole,
              Table_User_Name,
              Table_User_Phone,
              Table_User_Avater,
              Table_User_CustomerNo,
              Table_User_ShareBusinessNo,
              Table_User_ShareStationNo,
              Table_User_Sex,
              Table_User_Points,
              Table_User_Balance,
              Table_User_OpenId,
              Table_User_UnionId,
              Table_User_LastLoginTime,
              Table_User_RegisterDate,
              Table_User_BusinessNo,
              Table_User_StaffNo];
    BOOL a = [dataBase executeUpdate:sqlStr,
              kIntegerNumber(user.staffRole),
              kIntegerNumber(user.currentRole),
              user.userName,
              user.phone,
              user.avaterImagePath,
              user.customerNo,
              user.shareBusiness,
              user.shareStation,
              user.sex,
              [NSNumber numberWithFloat:user.points],
              [NSNumber numberWithFloat:user.balance],
              user.openId,
              user.unionId,
              user.lastLogintime,
              user.registrationDate,
              user.business.businessNo,
              user.staff.staffNo];
    if (!a) {
        MSLog(@"用户表数据插入失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    // 插入 business 表
//    [BusinessDataBaseHandler insertBusiness:user.business];
    // 插入 staff 表
    [StaffDataBaseHandler insertStaff:user.staff];
//    [StationDataBaseHandler insertStation:user.staff.station];
    return YES;
}

#pragma mark -
#pragma mark Update
+(BOOL)updateUser:(UserEntity *)user{
    if ([UserDataBaseHandler userExistWithPhone:user.phone]) {
        [UserDataBaseHandler deleteUserWithPhone:user.phone];
        [UserDataBaseHandler insertUser:user];
    } else {
        [UserDataBaseHandler insertUser:user];
    }
    return YES;
}

+(BOOL)updateUserRole:(CURRENT_USER_ROLE)role forPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%ld' WHERE %@ = '%@'", Table_User_TableName,Table_User_CurrentRole,role,Table_User_Phone,phone];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"更新用户表 '%@' role 数据失败:",phone);
        MSLog(@"%@",sqlStr);
    }
    return result;
}


#pragma mark -
#pragma mark Select
+(UserEntity *)getUser{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",Table_User_TableName];
    MSLog(@"获取用户表数据:");
    MSLog(@"%@",sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];
    UserEntity * user = nil;
    while ([resultSet next]) {
        user = [[UserEntity alloc]init];
        user.staffRole = [resultSet intForColumn:Table_User_StaffRole];
        user.currentRole = [resultSet intForColumn:Table_User_CurrentRole];
        user.userName = [resultSet stringForColumn:Table_User_Name];
        user.sex = [resultSet stringForColumn:Table_User_Sex];
        user.phone = [resultSet stringForColumn:Table_User_Phone];
        user.avaterImagePath = [resultSet stringForColumn:Table_User_Avater];
        user.customerNo = [resultSet stringForColumn:Table_User_CustomerNo];
        user.staff.staffNo = [resultSet stringForColumn:Table_User_StaffNo];
        user.business.businessNo = [resultSet stringForColumn:Table_User_BusinessNo];
        user.shareStation = [resultSet stringForColumn:Table_User_ShareStationNo];
        user.shareBusiness = [resultSet stringForColumn:Table_User_ShareBusinessNo];
        user.points = [resultSet doubleForColumn:Table_User_Points];
        user.balance = [resultSet doubleForColumn:Table_User_Balance];
        user.unionId = [resultSet stringForColumn:Table_User_UnionId];
        user.openId = [resultSet stringForColumn:Table_User_OpenId];
        user.lastLogintime = [resultSet stringForColumn:Table_User_LastLoginTime];
        user.registrationDate = [resultSet stringForColumn:Table_User_RegisterDate];
    }
    // 获取 用户 员工对象
    // 获取 用户 商家对象
    [SqliteBase closeDatabase];
    StaffEntity * staff = [StaffDataBaseHandler getStaffWithStaffNo:user.staff.staffNo];
    user.staff = staff;
    BusinessEntity * business = [BusinessDataBaseHandler getBusinessWithBusinessNo:user.business.businessNo];
    user.business = business;
    StationEntity * station = [StationDataBaseHandler getStationWithStationNo:user.staff.station.stationNo];
    user.staff.station = station;
    return user;
}

+(BOOL)userExistWithPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = '%@'",Table_User_TableName,Table_User_Phone,phone];
    MSLog(@"统计用户表数据数量:");
    MSLog(@"%@",sqlStr);
    NSInteger count = [database intForQuery:sqlStr];
    [SqliteBase closeDatabase];
    if (count <= 0) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Delete
+(BOOL)deleteUser{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@", Table_User_TableName];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"用户表数据删除失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    // 删除 staff 表
    // 删除 business 表
    [StaffDataBaseHandler clearStaffTable];
    [BusinessDataBaseHandler clearBusinessTable];
    [StationDataBaseHandler clearStation];
    return result;
}
+(BOOL)deleteUserWithPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", Table_User_TableName,Table_User_Phone,phone];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"用户表 '%@'数据 删除失败:",phone);
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteTable{
    SqliteBase *sqlite = [SqliteBase shareInstance];
    [sqlite getReadableDatabase];
    BOOL result = [sqlite deleteTable:Table_User_TableName];
    if (!result) {
        MSLog(@"删除用户表失败");
    }
    [sqlite closeDataBase];
    return result;
}

@end
