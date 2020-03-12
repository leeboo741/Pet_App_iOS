//
//  MessageManager.h
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * _Nonnull DEFAULT_LAST_GET_MESSAGE_TIME = @"1900-01-01 00:00:00";
static NSString * _Nonnull LAST_GET_MESSAGE_TIME_KEY = @"LastGetMessageTime";
static NSString * HAVE_NEW_MESSAGE = @"HaveNewMessage_KEY";

static NSString * NOTIFICATION_DATA_HAVE_NEW_MESSAGE_KEY = @"HaveNewMessage";
static NSString * NOTIFICATION_DATA_NEW_MESSAGE_LIST_KEY = @"NewMessageList";


@interface MessageManager : NSObject
SingleInterface(MessageManager);
/**
 存储当前时间为最后获取站内信时间
 */
-(void)saveLastGetMessageTime;

/**
 获取最后获取站内信时间
 */
-(NSString *)getLastGetMessageTime;

/**
 获取站内信列表
 
 @param offset 开始下标
 @param limit 数据长度
 @param success success
 @param fail fail
 */
-(void)getMessageListWithOffset:(NSInteger)offset
                          limit:(NSInteger)limit
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail;

/**
 获取最新站内信
 
 @param success success
 @param fail fail
 */
-(void)getNewMessageListSuccess:(SuccessBlock)success
                           fail:(FailBlock)fail;

/**
 开始定时获取最新站内信
 */
-(void)startGetNewMessage;
/**
 暂停获取最新站内信
 */
-(void) pauseGetNewMessage;

/**
 停止获取最新站内信
 */
-(void) stopGetNewMessage;

/**
 是否有最新站内信
 
 @return yes 有 no 没有
 */
-(BOOL)getHaveNewMessage;

/**
 最新站内信列表
 
 @return 最新站内信列表
 */
-(NSArray *)getLastNewMessageList;

/**
 注册监听是否有最新站内信消息
 
 @param observer 监听者
 @param selector 响应方法
 */
-(void)registerNotificationForNewMessageWithObserver:(id)observer
                                            selector:(SEL)selector;

/**
 移除监听是否有最新站内信消息
 
 @param observer 监听者
 */
-(void)removeNotificationForNewMessageWithObserver:(id)observer;

/**
 注册监听最新站内信消息列表
 
 @param observer 监听者
 @param selector 响应方法
 */
-(void)registerNotificationForNewMessageListWithObserver:(id)observer
                                                selector:(SEL)selector;

/**
 移除监听最新站内信消息列表
 
 @param observer 监听者
 */
-(void)removeNotificationForNewMessageListWithObserver:(id)observer;
@end

NS_ASSUME_NONNULL_END
