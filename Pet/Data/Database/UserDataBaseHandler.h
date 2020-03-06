//
//  UserDataBaseHandler.h
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHandler.h"
#import "StaffDataBaseHandler.h"
#import "BusinessDataBaseHandler.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserDataBaseHandler : DatabaseHandler
#pragma mark -
#pragma mark Insert
+(BOOL)insertUser:(UserEntity *)user;

#pragma mark -
#pragma mark Update
+(BOOL)updateUser:(UserEntity *)user;
+(BOOL)updateUserRole:(CURRENT_USER_ROLE)role forPhone:(NSString *)phone;

#pragma mark -
#pragma mark Select
+(UserEntity *)getUser;
+(BOOL)userExistWithPhone:(NSString *)phone;

#pragma mark -
#pragma mark Delete
+(BOOL)deleteUser;
+(BOOL)deleteUserWithPhone:(NSString *)phone;
+(BOOL)deleteTable;
@end

NS_ASSUME_NONNULL_END
