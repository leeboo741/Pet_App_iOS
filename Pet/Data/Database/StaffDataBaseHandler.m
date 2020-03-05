//
//  StaffDataBaseHandler.m
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "StaffDataBaseHandler.h"

@implementation StaffDataBaseHandler
#pragma mark - insert
+(BOOL)insertStaff:(StaffEntity *)staffEntity{
    FMDatabase * dataBase = [SqliteBase getDatabase];
    NSString * sqlStr;
    sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?)",
              Table_Staff_TableName,
              Table_Staff_Name,
              Table_Staff_StaffNo,
              Table_Staff_Openid,
              Table_Staff_Phone,
              Table_Staff_Sex,
              Table_Staff_StationNo
              ];
    BOOL a = [dataBase executeUpdate:sqlStr,
              staffEntity.name,
              staffEntity.staffNo,
              staffEntity.openId,
              staffEntity.phone,
              staffEntity.sex,
              staffEntity.station.stationNo];
    if (!a) {
        MSLog(@"staff表数据插入失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return YES;
}
#pragma mark - update
+(BOOL)updateStaff:(StaffEntity *)staffEntity{
    if ([StaffDataBaseHandler exsitStaffWithStaffNo:staffEntity.staffNo]) {
        [StaffDataBaseHandler deleteStaffWithStaffNo:staffEntity.staffNo];
        [StaffDataBaseHandler insertStaff:staffEntity];
    } else {
        [StaffDataBaseHandler insertStaff:staffEntity];
    }
    return YES;
}

#pragma mark - select
+(StaffEntity *)getStaffWithStaffNo:(NSString *)staffNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",Table_Staff_TableName, Table_Staff_StaffNo , staffNo];
    MSLog(@"获取staff表数据:");
    MSLog(@"%@",sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];
    StaffEntity * staff = nil;
    while ([resultSet next]) {
        staff = [[StaffEntity alloc]init];
        staff.name = [resultSet stringForColumn:Table_Staff_Name];
        staff.staffNo = [resultSet stringForColumn:Table_Staff_StaffNo];
        staff.openId = [resultSet stringForColumn:Table_Staff_Openid];
        staff.phone = [resultSet stringForColumn:Table_Staff_Phone];
        staff.sex = [resultSet stringForColumn:Table_Staff_Sex];
        staff.station.stationNo = [resultSet stringForColumn:Table_Staff_StationNo];
    }
    [SqliteBase closeDatabase];
    return staff;
}

+(BOOL)exsitStaffWithStaffNo:(NSString *)staffNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = '%@'",Table_Staff_TableName,Table_Staff_StaffNo,staffNo];
    MSLog(@"统计staff表数据数量:");
    MSLog(@"%@",sqlStr);
    NSInteger count = [database intForQuery:sqlStr];
    [SqliteBase closeDatabase];
    if (count <= 0) {
        return NO;
    }
    return YES;
}

#pragma mark - delete
+(BOOL)clearStaffTable{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@", Table_Staff_TableName];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"staff表数据删除失败:");
        MSLog(@"%@",sqlStr);
    }
    
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteStaffWithStaffNo:(NSString *)staffNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", Table_Staff_TableName,Table_Staff_StaffNo,staffNo];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"staff表 '%@'数据 删除失败:",staffNo);
        MSLog(@"%@",sqlStr);
    }
    
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteStaffTable{
    SqliteBase *sqlite = [SqliteBase shareInstance];
    [sqlite getReadableDatabase];
    BOOL result = [sqlite deleteTable:Table_Staff_TableName];
    if (!result) {
        MSLog(@"删除staff表失败");
    }
    [sqlite closeDataBase];
    return result;
}
@end
