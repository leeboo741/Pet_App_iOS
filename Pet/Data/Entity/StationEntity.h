//
//  StationEntity.h
//  Pet
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationEntity : NSObject
@property (nonatomic, copy) NSString * stationName; // 站点名称
@property (nonatomic, copy) NSString * stationNo; // 站点编号
@property (nonatomic, copy) NSString * province; // 省
@property (nonatomic, copy) NSString * district; // 区县
@property (nonatomic, copy) NSString * city; // 市
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * intoDate; // 入驻时间??
@property (nonatomic, assign) int state; // 站点状态
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;
@property (nonatomic, copy) NSString * transports;
@property (nonatomic, assign) int transportType;
@property (nonatomic) id partners;
@property (nonatomic, copy) NSString * stationLicenseImage; // 营业执照
@property (nonatomic, copy) NSString * idcardFrontImage; // 身份证正面
@property (nonatomic, copy) NSString * idcardBackImage; // 身份证背面
@property (nonatomic, copy) NSString * startCity; // ???
@property (nonatomic, copy) NSString * airport; // ???

@property (nonatomic, copy) NSString * openId;
@property (nonatomic, copy) NSString * contact; // 联系人
@property (nonatomic, copy) NSString * phone;
@end

NS_ASSUME_NONNULL_END
