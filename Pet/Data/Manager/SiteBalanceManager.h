//
//  SiteBalanceManager.h
//  Pet
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "StationEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiteRebateFlow : NSObject
@property (nonatomic, copy) NSString * billNo;
@property (nonatomic, assign) NSInteger flowNo;
@property (nonatomic, copy) NSString * linkNo;
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, assign) CGFloat flowAmount;
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * dateTime;
@property (nonatomic, assign) CGFloat balance;
@end

@interface SiteBalanceBuffer : NSObject
@property (nonatomic, assign) CGFloat frozen;
@property (nonatomic, assign) CGFloat usable;
@end

@interface SiteWithdrawFlow : NSObject
@property (nonatomic, strong) StaffEntity * staff;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, strong) StationEntity * station;
@property (nonatomic, copy) NSString * withdrawNo;
@property (nonatomic, copy) NSString * withdrawTime;
@end

@interface SiteBalanceManager : NSObject
SingleInterface(SiteBalanceManager);
/**
 获取站点返利流水
 
 @param stationNo 站点编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getRebateFlowWithStationNo:(NSString *)stationNo
                           offset:(NSInteger)offset
                            limit:(NSInteger)limit
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail;

/**
 获取站点 可用余额 和 冻结余额
 
 @param stationNo   站点编号
 @param success success
 @param fail fail
 */
-(void)getBalanceBufferWithStationNo:(NSString *)stationNo
                             success:(SuccessBlock)success
                                fail:(FailBlock)fail;

/**
 获取提现流水
 
 @param stationNo 站点编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getWithdrawFlowWithStationNo:(NSString *)stationNo
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

/**
 站点提现
 
 @param customerNo  客户编号
 @param amount 提现金额
 @param success success
 @param fail fail
 */
-(void)withDrawByCustomerNo:(NSString *)customerNo
                     amount:(CGFloat)amount
                    success:(SuccessBlock)success
                       fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
