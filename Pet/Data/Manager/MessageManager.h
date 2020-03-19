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

@interface MessageEntity : NSObject
@property (nonatomic, copy) NSString * sendNo;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, assign) NSInteger messageNo;
@property (nonatomic, copy) NSString * messageTitle;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * sendTime;
@property (nonatomic, copy) NSString * link;
@property (nonatomic, copy) NSString * receiveNo;
@property (nonatomic, copy) NSString * messageContent;
@end

static NSString * _Nonnull DEFAULT_LAST_GET_MESSAGE_TIME = @"1900-01-01 00:00:00";
static NSString * _Nonnull LAST_GET_MESSAGE_TIME_KEY = @"LastGetMessageTime";
static NSString * HAVE_NEW_MESSAGE = @"HaveNewMessage_KEY";

static NSString * NOTIFICATION_DATA_HAVE_NEW_MESSAGE_KEY = @"HaveNewMessage";


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
 获取最新站内信数量
 
 @param success success
 @param fail fail
 */
-(void)getNewMessageCountSuccess:(SuccessBlock)success
                            fail:(FailBlock)fail;

/**
 是否有最新站内信
 
 @return yes 有 no 没有
 */
-(BOOL)getHaveNewMessage;

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
 停止获取message定时器
 */
-(void)stopGetMessageTimer;
/**
 重置最后获取站内信时间
 */
-(void)resetLastGetMessageTime;

/**
 处理消息 中 的links
 */
-(void)handlerMessageLinks:(NSString *)messageLinks;
@end

NS_ASSUME_NONNULL_END
