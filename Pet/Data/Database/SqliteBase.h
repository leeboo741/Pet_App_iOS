//
//  SqliteBase.h
//  BossModule
//
//  Created by YWKJ on 2018/5/21.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

// 用户

#define Table_User_TableName @"UserTable"
#define Table_User_Role @"role"
#define Table_User_Name @"userName"
#define Table_User_Phone @"phone"
#define Table_User_Avater @"avaterImagePath"
#define Table_User_CustomerNo @"customerNo"
#define Table_User_BusinessNo @"businessNo"
#define Table_User_StationNo  @"stationNo"

@interface SqliteBase : NSObject

@property (nonatomic,strong)FMDatabase * db;

+ (id)shareInstance; // 创建数据库单例
- (FMDatabase *)getReadableDatabase; // 获取可用数据库
+ (FMDatabase *)getDatabase; // 获取可用数据库类方法
+ (void)closeDatabase; // 关闭数据库类方法
- (void)closeDataBase; // 关闭数据库
- (BOOL)deleteTable:(NSString *)table; // 删表

@end
