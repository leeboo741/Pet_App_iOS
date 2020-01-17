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
-(void)getPhoneCodeByPhoneNumber:(NSString *)phoneNumber success:(SuccessBlock)success fail:(FailBlock)fail;
@end

NS_ASSUME_NONNULL_END
