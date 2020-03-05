//
//  StaffDataBaseHandler.h
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHandler.h"
#import "StationDataBaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface StaffDataBaseHandler : DatabaseHandler
#pragma mark -
#pragma mark - Insert
+(BOOL)insertStaff:(StaffEntity *)staffEntity;

#pragma mark -
#pragma mark - Update
+(BOOL)updateStaff:(StaffEntity *)staffEntity;

#pragma mark -
#pragma mark - Select
+(StaffEntity *)getStaffWithStaffNo:(NSString *)staffNo;
+(BOOL)exsitStaffWithStaffNo:(NSString *)staffNo;

#pragma mark -
#pragma mark - delete
+(BOOL)clearStaffTable;
+(BOOL)deleteStaffWithStaffNo:(NSString *)staffNo;
+(BOOL)deleteStaffTable;
@end

NS_ASSUME_NONNULL_END
