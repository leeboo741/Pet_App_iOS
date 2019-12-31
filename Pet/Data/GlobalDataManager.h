//
//  GlobalDataManager.h
//  TestTabbar
//
//  Created by lee on 2019/12/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleInstanceMacro.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GLOBAL_DATA_KEY) {
    GLOBAL_DATA_KEY_MAINTABBAR = 0, // MainTabbarController
}; // key值 枚举

@interface GlobalDataManager : NSObject
/**
 *  获取单例对象
 */
//+(instancetype)shareGlobalDataManager;
SingleInterface(GlobalDataManager);
/**
 *  存储数据
 *  @param data 要存储的数据
 *  @param key key值
 */
-(void)setData:(id)data withKey:(GLOBAL_DATA_KEY)key;
/**
 *  获取存储数据
 *  @param key key值
 */
-(id)getDataWithKey:(GLOBAL_DATA_KEY)key;
@end

NS_ASSUME_NONNULL_END
