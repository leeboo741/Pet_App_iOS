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
#define Table_User_StaffRole @"staffRole"
#define Table_User_CurrentRole  @"currentRole"
#define Table_User_Name @"userName"
#define Table_User_Phone @"phone"
#define Table_User_Avater @"avaterImagePath"
#define Table_User_CustomerNo @"customerNo"
#define Table_User_ShareBusinessNo @"shareBusiness"
#define Table_User_ShareStationNo  @"shareStation"
#define Table_User_Sex  @"sex"
#define Table_User_Points @"points"
#define Table_User_Balance @"balance"
#define Table_User_OpenId   @"openId"
#define Table_User_UnionId  @"unionId"
#define Table_User_LastLoginTime    @"lastLoginTime"
#define Table_User_RegisterDate @"registerDate"
#define Table_User_BusinessNo   @"businessNo"
#define Table_User_StaffNo    @"staffNo"


#define Table_Staff_TableName   @"StaffTable"
#define Table_Staff_Name    @"staffName"
#define Table_Staff_StaffNo @"staffNo"
#define Table_Staff_Openid  @"openId"
#define Table_Staff_Phone   @"phone"
#define Table_Staff_Sex     @"sex"
#define Table_Staff_StationNo   @"stationNo"


#define Table_Station_TableName @"StationTable"
#define Table_Station_StationName   @"stationName"
#define Table_Station_StationNo @"stationNo"
#define Table_Station_Province  @"province"
#define Table_Station_District  @"district"
#define Table_Station_City  @"city"
#define Table_Station_Address @"address"
#define Table_Station_IntoDate  @"intoDate"
#define Table_Station_State @"state"
#define Table_Station_Longitude @"longitude"
#define Table_Station_Latitude  @"latitude"
#define Table_Station_StationLicenseImage   @"stationLicenseImage"
#define Table_Station_IdCardFront   @"idcardFront"
#define Table_Station_IdCardBack    @"idcardBack"
#define Table_Station_OpenId    @"openid"
#define Table_Station_Contact   @"contact"
#define Table_Station_Phone @"phone"

#define Table_Business_TableName    @"BusinessTable"
#define Table_Business_BusinessNo   @"businessNo"
#define Table_Business_BusinessName @"businessName"
#define Table_Business_IconAddress  @"iconAddress"
#define Table_Business_PhoneNumber  @"phoneNumber"
#define Table_Business_BondAmount   @"bondAmount"
#define Table_Business_RegisterTime @"registerTime"
#define Table_Business_StartBusinessTime    @"startBusinessTime"
#define Table_Business_EndBusinessTime  @"endBusinessTime"
#define Table_Business_BusinessService  @"BusinessService"
#define Table_Business_BusinessType @"businessType"
#define Table_Business_Describes    @"describes"
#define Table_Business_Longitude    @"longitude"
#define Table_Business_Latitude @"latitude"
#define Table_Business_BusinessDegree   @"businessDegree"
#define Table_Business_Province @"province"
#define Table_Business_City @"city"
#define Table_Business_DetailAddress    @"detailAddress"
#define Table_Business_State    @"state"
#define Table_Business_Contact  @"contact"
#define Table_Business_ContactPhone @"contactPhone"
#define Table_Business_NickName @"nickName"
#define Table_Business_HeaderImage  @"headerImage"
#define Table_Business_OpenId   @"openId"
#define Table_Business_UnionId  @"unionId"

@interface SqliteBase : NSObject

@property (nonatomic,strong)FMDatabase * db;

+ (id)shareInstance; // 创建数据库单例
- (FMDatabase *)getReadableDatabase; // 获取可用数据库
+ (FMDatabase *)getDatabase; // 获取可用数据库类方法
+ (void)closeDatabase; // 关闭数据库类方法
- (void)closeDataBase; // 关闭数据库
- (BOOL)deleteTable:(NSString *)table; // 删表

@end
