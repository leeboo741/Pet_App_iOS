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

typedef NS_ENUM(NSInteger, Table_Column_Type) {
    Table_Column_Type_Text   = 0,
    Table_Column_Type_Int    = 1,
    Table_Column_Type_Float  = 2,
    Table_Column_Type_Bool   = 3,
};

@interface SqliteColumnObj : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) Table_Column_Type type;
@property (nonatomic, assign) BOOL nullAble;
@end
@implementation SqliteColumnObj

+(instancetype)columnObjWithName:(NSString *)name type:(Table_Column_Type)type nullAble:(BOOL)nullAble{
    SqliteColumnObj * obj = [[SqliteColumnObj alloc]initWithName:name type:type nullAble:nullAble];
    return obj;
}

-(instancetype)initWithName:(NSString *)name type:(Table_Column_Type)type nullAble:(BOOL)nullAble{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.nullAble = nullAble;
    }
    return self;
}

@end

@interface SqliteBase ()
@property (nonatomic, strong) NSArray<SqliteColumnObj *> * userTableColumnList;
@property (nonatomic, strong) NSArray<SqliteColumnObj *> * staffTableColumnList;
@property (nonatomic, strong) NSArray<SqliteColumnObj *> * stationTableColumnList;
@property (nonatomic, strong) NSArray<SqliteColumnObj *> * businessTableColumnList;
@end

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
    [self createTableWithDataBase:database tableName:Table_User_TableName columnList:self.userTableColumnList]; // 用户表
    [self createTableWithDataBase:database tableName:Table_Staff_TableName columnList:self.staffTableColumnList]; // 员工表
    [self createTableWithDataBase:database tableName:Table_Station_TableName columnList:self.stationTableColumnList]; // 站点表
    [self createTableWithDataBase:database tableName:Table_Business_TableName columnList:self.businessTableColumnList]; // 商家表
}

/**
 建表
 
 @param database 数据库
 @parma tableName 表名
 @param columnList 表 列 列表
 */
-(void)createTableWithDataBase:(FMDatabase *)database tableName:(NSString *)tableName columnList:(NSArray<SqliteColumnObj *> *)columnList{
    NSString * sqlStr = [[NSString alloc]init];
    sqlStr = [sqlStr stringByAppendingFormat:@"create table if not exists %@",tableName];
//    sqlStr = [sqlStr stringByAppendingString:@"(id integer primary key autoincrement,"];
    sqlStr = [sqlStr stringByAppendingString:@"("];
    for (SqliteColumnObj * columnObj in columnList) {
        sqlStr = [sqlStr stringByAppendingString:[self getSqlStrWithColumnObj:columnObj isLastObj:(columnObj == columnList.lastObject)]];
    }
    MSLog(@"===> create table %@ <===\n===> sqlStr: %@ <===",tableName,sqlStr);
    if ([database executeUpdate:sqlStr]) {
        MSLog(@"创建 %@ 成功",tableName);
    }else{
        MSLog(@"创建 %@ 失败",tableName);
    }
    sqlStr = nil;
}

/**
 生成建表sql语句
 
 @param columnObj lie 对象
 @param isLastObj 是否是最后一列
 
 @return 返回sql语句
 */
-(NSString *)getSqlStrWithColumnObj:(SqliteColumnObj *)columnObj isLastObj:(BOOL)isLastObj{
    NSString * sqlStr = columnObj.name;
    switch (columnObj.type) {
        case Table_Column_Type_Text:
            sqlStr = [sqlStr stringByAppendingString:@" text"];
            break;
        case Table_Column_Type_Int:
            sqlStr = [sqlStr stringByAppendingString:@" integer"];
            break;
        case Table_Column_Type_Float:
            sqlStr = [sqlStr stringByAppendingString:@" float"];
            break;
        case Table_Column_Type_Bool:
            sqlStr = [sqlStr stringByAppendingString:@" boolean"];
            break;
        default:
            break;
    }
    if (!columnObj.nullAble) {
        sqlStr = [sqlStr stringByAppendingString:@" NOT NULL"];
    }
    if (!isLastObj) {
        sqlStr = [sqlStr stringByAppendingString:@","];
    } else {
        sqlStr = [sqlStr stringByAppendingString:@")"];
    }
    return sqlStr;
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

#pragma mark - setters and getters
-(NSArray<SqliteColumnObj *> *)userTableColumnList{
    if (!_userTableColumnList) {
        _userTableColumnList = @[
            [SqliteColumnObj columnObjWithName:Table_User_StaffRole type:Table_Column_Type_Int nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_CurrentRole type:Table_Column_Type_Int nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_Name type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_Phone type:Table_Column_Type_Text nullAble:NO],
            [SqliteColumnObj columnObjWithName:Table_User_Avater type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_CustomerNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_ShareBusinessNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_ShareStationNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_Sex type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_Points type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_Balance type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_OpenId type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_UnionId type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_LastLoginTime type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_RegisterDate type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_BusinessNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_User_StaffNo type:Table_Column_Type_Text nullAble:YES],
        ];
    }
    return _userTableColumnList;
}

-(NSArray<SqliteColumnObj *> *)staffTableColumnList{
    if (!_staffTableColumnList) {
        _staffTableColumnList = @[
            [SqliteColumnObj columnObjWithName:Table_Staff_Name type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Staff_StaffNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Staff_Openid type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Staff_Phone type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Staff_Sex type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Staff_StationNo type:Table_Column_Type_Text nullAble:YES],
        ];
    }
    return _staffTableColumnList;
}

-(NSArray<SqliteColumnObj *> *)stationTableColumnList{
    if (!_stationTableColumnList) {
        _stationTableColumnList = @[
            [SqliteColumnObj columnObjWithName:Table_Station_StationName type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_StationNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Province type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_District type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_City type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Address type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_IntoDate type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_State type:Table_Column_Type_Int nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Longitude type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Latitude type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_StationLicenseImage type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_IdCardFront type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_IdCardBack type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_OpenId type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Contact type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Station_Phone type:Table_Column_Type_Text nullAble:YES],
        ];
    }
    return _stationTableColumnList;
}

-(NSArray<SqliteColumnObj *> *)businessTableColumnList{
    if (!_businessTableColumnList) {
        _businessTableColumnList = @[
            [SqliteColumnObj columnObjWithName:Table_Business_BusinessNo type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_BusinessName type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_IconAddress type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_PhoneNumber type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_BondAmount type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_RegisterTime type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_StartBusinessTime type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_EndBusinessTime type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_BusinessService type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_BusinessType type:Table_Column_Type_Int nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_Describes type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_Longitude type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_Latitude type:Table_Column_Type_Float nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_BusinessDegree type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_Province type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_City type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_DetailAddress type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_State type:Table_Column_Type_Int nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_Contact type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_ContactPhone type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_NickName type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_HeaderImage type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_OpenId type:Table_Column_Type_Text nullAble:YES],
            [SqliteColumnObj columnObjWithName:Table_Business_UnionId type:Table_Column_Type_Text nullAble:YES],
        ];
    }
    return _businessTableColumnList;
}

@end
