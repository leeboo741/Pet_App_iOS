//
//  BusinessBalanceManager.h
//  Pet
//
//  Created by mac on 2020/3/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "BusinessEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessRebate : NSObject
@property (nonatomic, copy) NSString * billNo;
@property (nonatomic, assign) NSInteger flowNo;
@property (nonatomic, copy) NSString * linkNo;
@property (nonatomic, strong) BusinessEntity * business;
@property (nonatomic, assign) CGFloat flowAmount;
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * dateTime;
@property (nonatomic, assign) CGFloat balance;
@end

@interface BusinessBalanceBuffer : NSObject
@property (nonatomic, assign) CGFloat frozen;
@property (nonatomic, assign) CGFloat usable;
@end

@interface BusinessWithdrawFlow : NSObject
@property (nonatomic, strong) BusinessEntity * business;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * withdrawNo;
@property (nonatomic, copy) NSString * withdrawTime;
@end

@interface BusinessBalanceManager : NSObject
SingleInterface(BusinessBalanceManager);
/**
 获取商家返利流水
 
 @param businessNo 商家编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getRebateFlowWithBusinessNo:(NSString *)businessNo
                           offset:(NSInteger)offset
                            limit:(NSInteger)limit
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail;

/**
 获取商家 可用余额 和 冻结余额
 
 @param businessNo 商家编号
 @param success success
 @param fail fail
 */
-(void)getBalanceBufferWithBusinessNo:(NSString *)businessNo
                             success:(SuccessBlock)success
                                fail:(FailBlock)fail;

/**
 获取提现流水
 
 @param businessNo 商家编号
 @param offset 下标
 @param limit 长度
 @param success success
 @param fail fail
 */
-(void)getWithdrawFlowWithBusinessNo:(NSString *)businessNo
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

/**
 商家提现
 
 @param businessNo 商家编号
 @param amount 提现金额
 @param success success
 @param fail fail
 */
-(void)withDrawByBusinessNo:(NSString *)businessNo
                     amount:(CGFloat)amount
                    success:(SuccessBlock)success
                       fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
