//
//  StationDataBaseHandler.h
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "DatabaseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface StationDataBaseHandler : DatabaseHandler

#pragma mark -
#pragma mark - Insert
+(BOOL)insertStation:(StationEntity *)station;
#pragma mark -
#pragma mark - Update
+(BOOL)updateStation:(StationEntity *)station;
#pragma mark -
#pragma mark - Select
+(StationEntity *)getStationWithStationNo:(NSString *)stationNo;
+(BOOL)existStationWithStationNo:(NSString *)stationNo;
#pragma mark -
#pragma mark - delete
+(BOOL)clearStation;
+(BOOL)deleteStationWithStationNo:(NSString *)stationNo;
+(BOOL)deleteStationTable;
@end

NS_ASSUME_NONNULL_END
