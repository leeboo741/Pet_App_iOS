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

NS_ASSUME_NONNULL_BEGIN

@interface ApplyStaffModel : NSObject
@property (nonatomic, copy) NSString * openId; // openId
@property (nonatomic, copy) NSString * phone; // 电话
@property (nonatomic, copy) NSString * staffName; // 名称
@property (nonatomic, strong) id station; // 站点
@property (nonatomic, copy) NSString * verificationCode; // 验证码
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
@end

@interface ApplyManager : NSObject
SingleInterface(ApplyManager);

/**
 员工申请

 @param applyStaffModel 申请内容
 @param success 成功回调
 @param fail 失败回调
 */
-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 商家申请

 @param applyStationModel 申请内容
 @param success 成功回调
 @param fail 失败回调
 */
-(void)requestStationApply:(ApplyStationModel *)applyStationModel success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
