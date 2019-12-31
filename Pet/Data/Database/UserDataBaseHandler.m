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
    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?)",
              Table_User_TableName,
              Table_User_Role,
              Table_User_Name,
              Table_User_Phone,
              Table_User_Avater,
              Table_User_CustomerNo,
              Table_User_StationNo,
              Table_User_BusinessNo];
    BOOL a = [dataBase executeUpdate:sqlStr,[NSNumber numberWithInteger:user.role],user.userName,user.phone,user.avaterImagePath,user.customerNo,user.stationNo,user.businessNo];
    if (!a) {
        NSLog(@"用户表数据插入失败:");
        NSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
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

+(BOOL)updateUserRole:(USER_ROLE)role forPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%ld' WHERE %@ = '%@'", Table_User_TableName,Table_User_Role,role,Table_User_Phone,phone];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        NSLog(@"更新用户表 '%@' role 数据失败:",phone);
        NSLog(@"%@",sqlStr);
    }
    return result;
}


#pragma mark -
#pragma mark Select
+(UserEntity *)getUser{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",Table_User_TableName];
    NSLog(@"获取用户表数据:");
    NSLog(@"%@",sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];
    UserEntity * user = nil;
    while ([resultSet next]) {
        user = [[UserEntity alloc]init];
        user.role = [resultSet intForColumn:Table_User_Role];
        user.userName = [resultSet stringForColumn:Table_User_Name];
        user.phone = [resultSet stringForColumn:Table_User_Phone];
        user.avaterImagePath = [resultSet stringForColumn:Table_User_Avater];
        user.customerNo = [resultSet stringForColumn:Table_User_CustomerNo];
        user.stationNo = [resultSet stringForColumn:Table_User_StationNo];
        user.businessNo = [resultSet stringForColumn:Table_User_BusinessNo];
    }
    [SqliteBase closeDatabase];
    return user;
}

+(BOOL)userExistWithPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = '%@'",Table_User_TableName,Table_User_Phone,phone];
    NSLog(@"统计用户表数据数量:");
    NSLog(@"%@",sqlStr);
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
        NSLog(@"用户表数据删除失败:");
        NSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteUserWithPhone:(NSString *)phone{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", Table_User_TableName,Table_User_Phone,phone];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        NSLog(@"用户表 '%@'数据 删除失败:",phone);
        NSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteTable{
    SqliteBase *sqlite = [SqliteBase shareInstance];
    [sqlite getReadableDatabase];
    BOOL result = [sqlite deleteTable:Table_User_TableName];
    if (!result) {
        NSLog(@"删除用户表失败");
    }
    [sqlite closeDataBase];
    return result;
}

@end
