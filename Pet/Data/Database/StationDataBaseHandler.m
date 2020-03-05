//
//  StationDataBaseHandler.m
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "StationDataBaseHandler.h"

@implementation StationDataBaseHandler

#pragma mark - insert
+(BOOL)insertStation:(StationEntity *)station{
    
    FMDatabase * dataBase = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
              Table_Station_TableName,
              Table_Station_StationName,
              Table_Station_StationNo,
              Table_Station_Province,
              Table_Station_District,
              Table_Station_City,
              Table_Station_Address,
              Table_Station_IntoDate,
              Table_Station_State,
              Table_Station_Longitude,
              Table_Station_Latitude,
              Table_Station_StationLicenseImage,
              Table_Station_IdCardFront,
              Table_Station_IdCardBack,
              Table_Station_OpenId,
              Table_Station_Contact,
              Table_Station_Phone];
    BOOL a = [dataBase executeUpdate:sqlStr,
              station.stationName,
              station.stationNo,
              station.province,
              station.district,
              station.city,
              station.address,
              station.intoDate,
              station.state,
              station.lng,
              station.lat,
              station.stationLicenseImage,
              station.idcardFrontImage,
              station.idcardBackImage,
              station.openId,
              station.contact,
              station.phone];
    if (!a) {
        MSLog(@"station表数据插入失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return YES;
}
#pragma mark - update
+(BOOL)updateStation:(StationEntity *)station{
    if ([StationDataBaseHandler existStationWithStationNo:station.stationNo]) {
        [StationDataBaseHandler deleteStationWithStationNo:station.stationNo];
        return [StationDataBaseHandler insertStation:station];
    } else {
        return [StationDataBaseHandler insertStation:station];
    }
}
#pragma mark - select
+(StationEntity *)getStationWithStationNo:(NSString *)stationNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",Table_Station_TableName, Table_Station_StationNo , stationNo];
    MSLog(@"获取station表数据:");
    MSLog(@"%@",sqlStr);
    FMResultSet *resultSet = [database executeQuery:sqlStr];
    StationEntity * station = nil;
    while ([resultSet next]) {
        station = [[StationEntity alloc]init];
        station.stationName = [resultSet stringForColumn:Table_Station_StationName];
        station.stationNo = [resultSet stringForColumn:Table_Station_StationNo];
        station.province = [resultSet stringForColumn:Table_Station_Province];
        station.city = [resultSet stringForColumn:Table_Station_City];
        station.district = [resultSet stringForColumn:Table_Station_District];
        station.address = [resultSet stringForColumn:Table_Station_Address];
        station.intoDate = [resultSet stringForColumn:Table_Station_IntoDate];
        station.state = [resultSet intForColumn:Table_Station_State];
        station.lng = [resultSet doubleForColumn:Table_Station_Longitude];
        station.lat = [resultSet doubleForColumn:Table_Station_Latitude];
        station.stationLicenseImage = [resultSet stringForColumn:Table_Station_StationLicenseImage];
        station.idcardFrontImage = [resultSet stringForColumn:Table_Station_IdCardFront];
        station.idcardBackImage = [resultSet stringForColumn:Table_Station_IdCardBack];
        station.openId = [resultSet stringForColumn:Table_Station_OpenId];
        station.contact = [resultSet stringForColumn:Table_Station_Contact];
        station.phone = [resultSet stringForColumn:Table_Station_Phone];
    }
    // 获取 站点对象
    
    [SqliteBase closeDatabase];
    return station;
}
+(BOOL)existStationWithStationNo:(NSString *)stationNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr =  [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = '%@'",Table_Station_TableName,Table_Station_StationNo,stationNo];
    MSLog(@"统计station表数据数量:");
    MSLog(@"%@",sqlStr);
    NSInteger count = [database intForQuery:sqlStr];
    [SqliteBase closeDatabase];
    if (count <= 0) {
        return NO;
    }
    return YES;
}
#pragma mark - delete
+(BOOL)clearStation{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@", Table_Station_TableName];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"station表数据删除失败:");
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteStationWithStationNo:(NSString *)stationNo{
    FMDatabase * database = [SqliteBase getDatabase];
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'", Table_Station_TableName,Table_Station_StationNo,stationNo];
    BOOL result = [database executeUpdate:sqlStr];
    if (!result) {
        MSLog(@"station表 '%@'数据 删除失败:",stationNo);
        MSLog(@"%@",sqlStr);
    }
    [SqliteBase closeDatabase];
    return result;
}
+(BOOL)deleteStationTable{
    SqliteBase *sqlite = [SqliteBase shareInstance];
    [sqlite getReadableDatabase];
    BOOL result = [sqlite deleteTable:Table_Station_TableName];
    if (!result) {
        MSLog(@"删除station表失败");
    }
    [sqlite closeDataBase];
    return result;
}
@end
