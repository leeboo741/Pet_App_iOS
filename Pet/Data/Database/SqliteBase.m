//
//  SqliteBase.m
//  BossModule
//
//  Created by YWKJ on 2018/5/21.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import "SqliteBase.h"

static SqliteBase * sqlDatabase = nil;
static NSString * datbaseName  = @"BanMaPetApp.sqlite";

@implementation SqliteBase
#pragma mark -
#pragma mark Creat Table 建表

/**
 建表

 @param database 数据库
 */
- (void)createTable:(FMDatabase *)database{
    if(database == nil){
        return;
    }
    [self createUserTable:database];
}
/**
 *  创建用户表
 *  @param database 数据库
 */
-(void)createUserTable:(FMDatabase *)database{
    NSString * sqlStr = [[NSString alloc]init];
    sqlStr = [sqlStr stringByAppendingFormat:@"create table if not exists %@",Table_User_TableName];
    sqlStr = [sqlStr stringByAppendingString:@"(id integer primary key autoincrement,"];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ integer,", Table_User_Role];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text NOT NULL,", Table_User_Name];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text NOT NULL,", Table_User_Phone];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text,", Table_User_Avater];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text,", Table_User_CustomerNo];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text,", Table_User_StationNo];
    sqlStr = [sqlStr stringByAppendingFormat:@"%@ text)", Table_User_BusinessNo];
    MSLog(@"create %@ = %@",Table_User_TableName,sqlStr);
    if ([database executeUpdate:sqlStr]) {
        MSLog(@"创建 %@ 成功",Table_User_TableName);
    }else{
        MSLog(@"创建 %@ 失败",Table_User_TableName);
    }
    sqlStr = nil;
}
#pragma mark -
#pragma mark Get database path 获取数据库地址

/**
 获取数据库地址

 @param DBName 数据库名称
 @return 地址
 */
- (NSString *)getPath:(NSString *)DBName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:DBName];
}

#pragma mark -
#pragma mark Check database is exist 

/**
 判断数据库文件是否存在

 @return 是否存在
 */
- (BOOL)isDatabaseExist{
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *DbFilePathName = [self getPath:datbaseName];
    isExist = [fileManager fileExistsAtPath:DbFilePathName];
    return isExist;
}

#pragma mark -
#pragma mark Init Database

/**
 初始化

 @return 数据库管理对象
 */
- (id)init{
    if(self = [super init]){
        MSLog(@"数据库文件路径 : %@",[self getPath:datbaseName]);
        BOOL isExist = [self isDatabaseExist];
        if(isExist == NO){
            _db = [self getReadableDatabase];
            [self createTable:_db];
        }
    }
    return self;
}

/**
 单例

 @return 数据库管理对象
 */
+ (id)shareInstance{
    if(sqlDatabase == nil){
        sqlDatabase = [[SqliteBase alloc]init];
    }else{
        if(![sqlDatabase isDatabaseExist]){
            FMDatabase * database = [sqlDatabase getReadableDatabase];
            [sqlDatabase createTable:database];
        }
    }
    return sqlDatabase;
}
#pragma mark -
#pragma mark Ready database

/**
 获取可读数据库

 @return 可读数据库
 */
- (FMDatabase *)getReadableDatabase{
    NSString *fileName = [self getPath:datbaseName];
    _db = [FMDatabase databaseWithPath:fileName];
    if(![_db open]){
        NSAssert1(0, @"Failed to open database file with message '%@'", [_db lastErrorMessage]);
    }
    [_db setShouldCacheStatements:YES];
    return _db;
}

/**
 获取可读数据库 类方法

 @return 可读数据库
 */
+(FMDatabase *)getDatabase{
    SqliteBase * sqlite = [SqliteBase shareInstance];
    return [sqlite getReadableDatabase];
}

#pragma mark -
#pragma mark Close

/**
 关闭数据库 实例方法
 */
- (void)closeDataBase{
    if(nil != _db){
        [_db close];
        _db = nil;
    }
}

/**
 关闭数据库 类方法
 */
+(void)closeDatabase{
    SqliteBase * sqlite = [SqliteBase shareInstance];
    return [sqlite closeDataBase];
}
#pragma mark -
#pragma mark Delete

/**
 删表

 @param table 表名
 @return 是否成功
 */
-(BOOL)deleteTable:(NSString *)table{
    _db = [self getReadableDatabase];
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@", table];
    BOOL a = [_db executeUpdate:sqlStr];
    if (!a) {
        MSLog(@"删除%@失败:",table);
        MSLog(@"%@",sqlStr);
    }
    [self closeDataBase];
    return a;
}
@end
