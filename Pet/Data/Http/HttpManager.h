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

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSInteger code);

@interface HttpManager : AFHTTPSessionManager
//SingleInterface(HttpManager);
+(instancetype)shareHttpManager; // 碰到进程崩溃,初步判断是AFNetworking多任务时线程不安全访问数据导致的,所以先不使用单例模式
-(void)requestWithRequestModel:(HttpRequestModel *)model;
@end

NS_ASSUME_NONNULL_END
