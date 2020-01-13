//
//  HttpModel.m
//  Pet
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "HttpModel.h"

#pragma mark - HttpModel
#pragma mark -

@interface HttpModel ()

@end

@implementation HttpModel

@end

#pragma mark - HttpRequestModel
#pragma mark -

@interface HttpRequestModel ()

@end

@implementation HttpRequestModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.methodType = HttpRequestMethodType_GET;
        self.header = [NSMutableDictionary dictionary];
        [self.header setObject:HEADER_VALUE_APPLICATION_JSON
                        forKey:HEADER_KEY_ACCEPT];
        [self.header setObject:HEADER_VALUE_APPLICATION_JSON
                        forKey:HEADER_KEY_CONTENT_TYPE];
    }
    return self;
}
-(NSString *)urlStr{
    if (_urlStr) {
        return [NSString stringWithFormat:@"%@%@",URL_BASE,_urlStr];
    }
    return URL_BASE;
}
-(instancetype)initWithType:(HttpRequestMethodType)type Url:(NSString *)url paramers:(id _Nullable)paramers successBlock:(HttpRequestSuccessBlock)successBlock failBlock:(HttpRequestFailBlock)failBlock{
    self = [super init];
    if (self) {
        self.methodType = type;
        self.urlStr = url;
        self.paramers = paramers;
        self.successBlock = successBlock;
        self.failBlock = failBlock;
    }
    return self;
}
@end

#pragma mark - HttpResponseModel
#pragma mark -

@interface HttpResponseModel ()

@end

@implementation HttpResponseModel

@end
