//
//  CommonManager.h
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonManager : NSObject
SingleInterface(CommonManager);

/**
 申请获取短信验证码

 @param phoneNumber 手机号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getPhoneCodeByPhoneNumber:(NSString *)phoneNumber success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
