//
//  OrderTransportInfoView.h
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderTransportInfoView : UIView
@property (nonatomic, copy) NSString * transportNum; // 航班号|车次号
@property (nonatomic, copy) NSString * startAirportCode; // 始发机场三字码
@property (nonatomic, copy) NSString * endAirportCode; // 目的机场三字码
@property (nonatomic, copy) NSString * departureDate; // 出发时间
@property (nonatomic, copy) NSString * expressNum; // 快递单号
@property (nonatomic, assign) BOOL showAirportLine; // 是否展示机场信息
@end

NS_ASSUME_NONNULL_END
