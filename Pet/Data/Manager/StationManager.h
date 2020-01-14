//
//  StationManager.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "Station.h"

NS_ASSUME_NONNULL_BEGIN

@interface StationManager : NSObject
SingleInterface(StationManager);
-(void)getStationWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize latitude:(double)latitude longitude:(double)longitude success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
