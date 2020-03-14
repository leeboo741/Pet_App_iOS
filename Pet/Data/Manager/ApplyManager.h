//
//  ApplyManager.h
//  申请管理
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "StationEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyStaffModel : NSObject
@property (nonatomic, copy) NSString * customerNo; // openId
@property (nonatomic, copy) NSString * phone; // 电话
@property (nonatomic, copy) NSString * staffName; // 名称
@property (nonatomic, strong) StationEntity * station; // 站点
@property (nonatomic, copy) NSString * verificationCode; // 验证码
@property (nonatomic, copy) NSString * jsessionId;
@property (nonatomic, copy) NSString * staffNo;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, strong) UserEntity * customer;
@property (nonatomic, assign) NSInteger state;
@end

@interface ApplyStationModel : NSObject
@property (nonatomic, copy) NSString * businessName; // 商家名称
@property (nonatomic, copy) NSString * phoneNumber; // 电话
@property (nonatomic, copy) NSString * startBusinessHours; // 开始营业时间
@property (nonatomic, copy) NSString * endBusinessHours; // 结束营业时间
@property (nonatomic, copy) NSString * describes; // 描述
@property (nonatomic, copy) NSString * province; // 省
@property (nonatomic, copy) NSString * city; // 市
@property (nonatomic, copy) NSString * detailAddress; // 详细地址
@property (nonatomic, copy) NSString * verificationCode; // 验证码
@property (nonatomic, copy) NSString * jsessionId;
@property (nonatomic, copy) NSString * businessNo;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString * registerTime;
@property (nonatomic, assign) NSInteger state;
@end

@interface ApplyManager : NSObject
SingleInterface(ApplyManager);
#pragma mark - 申请
/**
 员工申请

 @param applyStaffModel 申请内容
 @param success 成功回调
 @param fail 失败回调
 */
-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;

/**
 商家申请

 @param applyStationModel 申请内容
 @param success 成功回调
 @param fail 失败回调
 */
-(void)requestStationApply:(ApplyStationModel *)applyStationModel
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail;

#pragma mark - 审批
/**
 获取待审批的员工列表
 
 @param customerNo  用户编号
 @param success success
 @param fail fail
 */
-(void)getUnauditedStaffListByCustomerNo:(NSString *)customerNo
                                 success:(SuccessBlock)success
                                    fail:(FailBlock)fail;
/**
 获取待审批的商家列表
 
 @param customerNo  用户编号
 @param success success
 @param fail fail
 */
-(void)getUnauditedBusinessListByCustomerNo:(NSString *)customerNo
                                    success:(SuccessBlock)success
                                       fail:(FailBlock)fail;
/**
 拒绝员工审核
 
 @param staff 员工对象
 @param success success
 @param fail fail
 */
-(void)rejectStaff:(ApplyStaffModel *)staff
           success:(SuccessBlock)success
              fail:(FailBlock)fail;
/**
 通过员工申请
 
 @param staff 员工对象
 @param success success
 @param fail fail
 */
-(void)approveStaff:(ApplyStaffModel *)staff
            success:(SuccessBlock)success
               fail:(FailBlock)fail;
/**
 拒绝商家申请
 
 @param business 商家对象
 @param success success
 @param fail fail
 */
-(void)rejectBusiness:(ApplyStationModel *)business
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;
/**
 通过商家申请
 
 @param business 商家对象
 @param success success
 @param fail fail
 */
-(void)approveBusiness:(ApplyStationModel *)business
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
