//
//  MessageManager.m
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MessageManager.h"
#import "DateUtils.h"

static NSInteger DefaultTimeLoop = 1; // 计时循环

static NSString * NOTIFICATION_KEY_HAVENEWMESSAGE = @"HaveNewMessage_Notification";
static NSString * NOTIFICATION_KEY_NEWMESSAGELIST = @"NewMessageList_Notification";

@interface MessageManager ()
@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, strong) NSArray * lastNewMessageList;
@property (nonatomic) dispatch_source_t gcdTimer;
@end

@implementation MessageManager
SingleImplementation(MessageManager);
/**
 存储当前时间为最后获取站内信时间
 */
-(void)saveLastGetMessageTime{
    NSString * currentDateString = [[DateUtils shareDateUtils]getDateStringWithDate:[NSDate date] withFormatterStr:Formatter_YMDHMS];
    [[NSUserDefaults standardUserDefaults] setObject:currentDateString forKey:LAST_GET_MESSAGE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 获取最后获取站内信时间
 */
-(NSString *)getLastGetMessageTime{
    NSString * lastGetMessageTime = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_GET_MESSAGE_TIME_KEY];
    if (kStringIsEmpty(lastGetMessageTime)) {
        lastGetMessageTime = DEFAULT_LAST_GET_MESSAGE_TIME;
    }
    return lastGetMessageTime;
}

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
                           fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"customerNo": [[UserManager shareUserManager] getCustomerNo],
        @"offset":kIntegerNumber(offset),
        @"limit":kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Message_GetMessageList paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 获取最新站内信
 
 @param success success
 @param fail fail
 */
-(void)getNewMessageListSuccess:(SuccessBlock)success
                           fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"lastModifyTime": [self getLastGetMessageTime],
        @"customerNo": [[UserManager shareUserManager] getCustomerNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Message_GetNewMessageList paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 开始定时获取最新站内信
 */
-(void)startGetNewMessage{
    [self gcdTimer];
}
/**
 暂停获取最新站内信
 */
-(void)pauseGetNewMessage{
    dispatch_suspend(self.gcdTimer);
}
/**
 停止获取新站内信
 */
-(void) stopGetNewMessage{
    dispatch_source_cancel(self.gcdTimer);
    self.gcdTimer = nil;
}
/**
 是否有最新站内信
 
 @return yes 有 no 没有
 */
-(BOOL)getHaveNewMessage{
    return [[NSUserDefaults standardUserDefaults]boolForKey:HAVE_NEW_MESSAGE];
}

/**
 最新站内信列表
 
 @return 最新站内信列表
 */
-(NSArray *)getLastNewMessageList{
    return _lastNewMessageList;
}

/**
 注册监听是否有最新站内信消息
 
 @param observer 监听者
 @param selector 响应方法
 */
-(void)registerNotificationForNewMessageWithObserver:(id)observer selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NOTIFICATION_KEY_HAVENEWMESSAGE object:self];
}

/**
 移除监听是否有最新站内信消息
 
 @param observer 监听者
 */
-(void)removeNotificationForNewMessageWithObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:NOTIFICATION_KEY_HAVENEWMESSAGE object:self];
}

/**
 注册监听最新站内信消息列表
 
 @param observer 监听者
 @param selector 响应方法
 */
-(void)registerNotificationForNewMessageListWithObserver:(id)observer selector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:NOTIFICATION_KEY_NEWMESSAGELIST object:self];
}

/**
 移除监听最新站内信消息列表
 
 @param observer 监听者
 */
-(void)removeNotificationForNewMessageListWithObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:NOTIFICATION_KEY_NEWMESSAGELIST object:self];
}
#pragma mark - setters and getters
-(void)setHaveNewMessage:(BOOL)haveNewMessage{
    _haveNewMessage = haveNewMessage;
    [[NSUserDefaults standardUserDefaults] setBool:HAVE_NEW_MESSAGE forKey:HAVE_NEW_MESSAGE];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_HAVENEWMESSAGE object:self userInfo:@{NOTIFICATION_DATA_HAVE_NEW_MESSAGE_KEY:kBoolNumber(haveNewMessage)}];
}
-(void)setLastNewMessageList:(NSArray *)lastNewMessageList{
    if (lastNewMessageList == nil) {
        lastNewMessageList = @[];
    }
    _lastNewMessageList = lastNewMessageList;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_NEWMESSAGELIST object:self userInfo:@{NOTIFICATION_DATA_NEW_MESSAGE_LIST_KEY:lastNewMessageList}];
}
-(dispatch_source_t)gcdTimer{
    if (!_gcdTimer) {
       /** 创建定时器对象
        * para1: DISPATCH_SOURCE_TYPE_TIMER 为定时器类型
        * para2-3: 中间两个参数对定时器无用
        * para4: 最后为在什么调度队列中使用
        */
       _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
       /** 设置定时器
        * para2: 任务开始时间
        * para3: 任务的间隔
        * para4: 可接受的误差时间，设置0即不允许出现误差
        * Tips: 单位均为纳秒
        */
       dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, DefaultTimeLoop * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
       /** 设置定时器任务
        * 可以通过block方式
        * 也可以通过C函数方式
        */
       __weak typeof(self) weakSelf = self;
       dispatch_source_set_event_handler(_gcdTimer, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf getNewMessageListSuccess:^(id  _Nonnull data) {
                   
               } fail:^(NSInteger code) {
                   
               }];
           });
       });
       // 启动任务，GCD计时器创建后需要手动启动
        dispatch_resume(self.gcdTimer);
   }
    return _gcdTimer;
}
@end
