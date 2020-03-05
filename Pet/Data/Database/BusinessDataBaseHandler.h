//
//  BusinessDataBaseHandler.h
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "DatabaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessDataBaseHandler : DatabaseHandler

#pragma mark -
#pragma mark - Insert
+(BOOL)insertBusiness:(BusinessEntity *)business;
#pragma mark -
#pragma mark - Update
+(BOOL)updateBusiness:(BusinessEntity *)business;
#pragma mark -
#pragma mark - Select
+(BusinessEntity *)getBusinessWithBusinessNo:(NSString *)businessNo;
+(BOOL)existBusinessWithBusinessNo:(NSString *)businessNo;
#pragma mark -
#pragma mark - delete
+(BOOL)clearBusinessTable;
+(BOOL)deleteBusinessWithBusinessNo:(NSString *)businessNo;
+(BOOL)deleteBusinessTable;
@end

NS_ASSUME_NONNULL_END
