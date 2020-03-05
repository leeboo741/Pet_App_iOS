//
//  BusinessEntity.h
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessEntity : NSObject
@property (nonatomic, copy) NSString * businessNo; // 商家编号
@property (nonatomic, copy) NSString * businessName; // 商家名称
@property (nonatomic, copy) NSString * iconAddress; // 商家logo地址
@property (nonatomic, copy) NSString * phoneNumber; // 商家电话
@property (nonatomic, copy) NSString * bondAmount; // 缴纳保证金金额
@property (nonatomic, copy) NSString * registerTime; // 注册时间
@property (nonatomic, copy) NSString * startBusinessHours; // 开始营业时间
@property (nonatomic, copy) NSString * endBusinessHours; // 结束营业时间
@property (nonatomic, copy) NSString * businessService; // 商家营业范围
@property (nonatomic, assign) int businessType; // 商家类型
@property (nonatomic, copy) NSString * describes; // 商家描述
@property (nonatomic, assign) double longitude; // 经度
@property (nonatomic, assign) double  latitude; // 纬度
@property (nonatomic, copy) NSString * businessDegree; // 商家星级
@property (nonatomic, copy) NSString * province; // 省
@property (nonatomic, copy) NSString * city; // 市
@property (nonatomic, copy) NSString * detailAddress; // 详细地址
@property (nonatomic, assign) int state; // 状态

@property (nonatomic, copy) NSString * contacts; // 联系人
@property (nonatomic, copy) NSString * contactPhone; // phone 联系人电话
@property (nonatomic, copy) NSString * nickName; // 昵称
@property (nonatomic, copy) NSString * headerImg; // 头像
@property (nonatomic, copy) NSString * openId;
@property (nonatomic, copy) NSString * unionId;
@property (nonatomic, copy) NSString * verificationCode; // 验证码
@end

NS_ASSUME_NONNULL_END
