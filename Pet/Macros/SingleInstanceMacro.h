//
//  SingleInstanceMacro.h
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#ifndef SingleInstanceMacro_h
#define SingleInstanceMacro_h

#ifdef __OBJC__

#pragma mark - 单例模式 .h文件内容

#define SingleInterface(name) +(instancetype)share##name;

#pragma mark - 单例模式 .m文件内容

#if __has_feature(objc_arc)

/*
 创建对象的步骤分为申请内存(alloc)、初始化(init)这两个步骤，我们要确保对象的唯一性，因此在第一步这个阶段我们就要拦截它。
 当我们调用alloc方法时，OC内部会调用allocWithZone这个方法来申请内存，我们覆写这个方法，然后在这个方法中调用shareInstance方法返回单例对象，这样就可以达到我们的目的。
 拷贝对象也是同样的原理，覆写copyWithZone方法，然后在这个方法中调用shareInstance方法返回单例对象
 */

#define SingleImplementation(name) +(instancetype)share##name {return [[self alloc]init];} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static id instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone{return self;} \
- (id)mutableCopyWithZone:(NSZone *)zone {return self;}

#else

#define SingleImplementation(name) +(instancetype)share##name {return [[self alloc]init];} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static id instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone{return self;} \
- (id)mutableCopyWithZone:(NSZone *)zone {return self;} \
- (instancetype)retain {return self;} \
- (instancetype)autorelease {return self;} \
- (oneway void)release {} \
- (NSUInteger)retainCount {return MAXFLOAT;} \

#endif

#endif

#endif /* SingleInstanceMacro_h */
