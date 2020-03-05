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
        self.isFullUrl = NO;
        self.useDefaultHandler = YES;
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
        if (self.isFullUrl) {
            return _urlStr;
        }
        return [NSString stringWithFormat:@"%@%@",URL_BASE,_urlStr];
    }
    return URL_BASE;
}

-(instancetype)initWithType:(HttpRequestMethodType)type Url:(NSString *)url isFullUrl:(BOOL)isFull useDefaultHandler:(BOOL)useDefaultHandler paramers:(id)paramers successBlock:(HttpRequestSuccessBlock)successBlock failBlock:(HttpRequestFailBlock)failBlock{
    HttpRequestModel * model = [[HttpRequestModel alloc] init];
    if (model) {
        model.methodType = type;
        model.urlStr = url;
        model.paramers = paramers;
        model.successBlock = successBlock;
        model.failBlock = failBlock;
        model.isFullUrl = isFull;
        model.useDefaultHandler = useDefaultHandler;
    }
    return model;
}

-(instancetype)initWithType:(HttpRequestMethodType)type Url:(NSString *)url paramers:(id _Nullable)paramers successBlock:(HttpRequestSuccessBlock)successBlock failBlock:(HttpRequestFailBlock)failBlock{
    HttpRequestModel * model = [[HttpRequestModel alloc] init];
    if (model) {
        model.methodType = type;
        model.urlStr = url;
        model.paramers = paramers;
        model.successBlock = successBlock;
        model.failBlock = failBlock;
    }
    return model;
}
@end

#pragma mark - HttpResponseModel
#pragma mark -

@interface HttpResponseModel ()

@end

@implementation HttpResponseModel

@end
