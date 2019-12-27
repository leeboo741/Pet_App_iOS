//
//  TransportValueAddProtocol.h
//  Pet
//
//  Created by mac on 2019/12/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TransportValueAddProtocol <NSObject>
-(BOOL)serviceEnableUse;
-(BOOL)serviceEnableTap;
-(BOOL)serviceIsSelected;
-(BOOL)serviceShowInputArea;
-(BOOL)serviceShowInfoArea;
-(NSString *)serviceName;
-(NSString *)serviceContract;
-(NSString *)serviceDetail;
-(NSString *)serviceValue;
-(NSString *)serviceValuePlaceholder;
-(NSString *)serviceInfo;
@end

NS_ASSUME_NONNULL_END
