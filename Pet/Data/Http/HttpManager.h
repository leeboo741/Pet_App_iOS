//
//  HttpManager.h
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "HttpResponseHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : AFHTTPSessionManager
SingleInterface(HttpManager);
@end

NS_ASSUME_NONNULL_END
