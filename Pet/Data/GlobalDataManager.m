//
//  GlobalDataManager.m
//  TestTabbar
//
//  Created by lee on 2019/12/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "GlobalDataManager.h"

@interface GlobalDataManager ()
@property (nonatomic, strong) NSMutableDictionary * dataDict;
@end

static GlobalDataManager * shareSelf = nil;
@implementation GlobalDataManager

#pragma mark - public method
/**
 *  获取单例对象
 */
+(instancetype)shareInstance{
    if (shareSelf == nil) {
        shareSelf = [[GlobalDataManager alloc] init];
    }
    return shareSelf;
}
/**
 *  存储数据
 *  @param data 要存储的数据
 *  @param key key值
 */
-(void)setData:(id)data withKey:(GLOBAL_DATA_KEY)key{
    [self.dataDict setObject:data forKey:[self getKeyStringWithKey:key]];
}
/**
 *  获取存储数据
 *  @param key key值
 */
-(id)getDataWithKey:(GLOBAL_DATA_KEY)key{
    return [self.dataDict objectForKey:[self getKeyStringWithKey:key]];
}

#pragma mark - life cycle
/*
 创建对象的步骤分为申请内存(alloc)、初始化(init)这两个步骤，我们要确保对象的唯一性，因此在第一步这个阶段我们就要拦截它。
 当我们调用alloc方法时，OC内部会调用allocWithZone这个方法来申请内存，我们覆写这个方法，然后在这个方法中调用shareInstance方法返回单例对象，这样就可以达到我们的目的。
 拷贝对象也是同样的原理，覆写copyWithZone方法，然后在这个方法中调用shareInstance方法返回单例对象
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSelf = [super allocWithZone:zone];
    });
    return shareSelf;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - private method

-(NSString *)getKeyStringWithKey:(GLOBAL_DATA_KEY)key {
    return [NSString stringWithFormat:@"%ld",key];
}

#pragma mark - setters and getters

-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}
@end
