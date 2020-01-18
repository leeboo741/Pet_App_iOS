//
//  ApplyManager.h
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyStaffModel : NSObject
@property (nonatomic, copy) NSString * openId;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * staffName;
@property (nonatomic, strong) id station;
@property (nonatomic, copy) NSString * verificationCode;
@end

@interface ApplyStationModel : NSObject
@property (nonatomic, copy) NSString * businessName;
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * startBusinessHours;
@property (nonatomic, copy) NSString * endBusinessHours;
@property (nonatomic, copy) NSString * describes;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * detailAddress;
@property (nonatomic, copy) NSString * verificationCode;
@end

@interface ApplyManager : NSObject
SingleInterface(ApplyManager);
/**
 员工申请
 */
-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel success:(SuccessBlock)success fail:(FailBlock)fail;
/**
 商家申请
 */
-(void)requestStationApply:(ApplyStationModel *)applyStationModel success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
