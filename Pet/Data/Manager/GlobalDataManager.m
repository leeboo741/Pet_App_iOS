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
//+(instancetype)shareGlobalDataManager;
SingleImplementation(GlobalDataManager)

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

#pragma mark - private method
/**
 *  根据key枚举获取keystr
 *  @param key key值
 */
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
