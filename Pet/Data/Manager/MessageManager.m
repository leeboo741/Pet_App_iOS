//
//  MessageManager.m
//  Pet
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MessageManager.h"
#import "DateUtils.h"
#import "OrderDetailController.h"

@interface MessageEntity ()

@end

@implementation MessageEntity

@end

static NSInteger DefaultTimeLoop = 60; // 计时循环

static NSString * NOTIFICATION_KEY_HAVENEWMESSAGE = @"HaveNewMessage_Notification";

static NSString * Message_LinkType_Action = @"action";
static NSString * Message_LinkType_OrderDetail = @"/pages/orderDetail/orderDetail";

static NSString * Message_LinkAction_Login = @"login";

@interface MessageManager ()
@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic) dispatch_source_t gcdTimer;
@end

@implementation MessageManager
SingleImplementation(MessageManager);
-(instancetype)init{
    if (self = [super init]) {
        [self gcdTimer];
    }
    return self;
}
/**
停止获取message定时器
*/
-(void)stopGetMessageTimer{
    if (self.gcdTimer) {
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}
/**
 重置最后获取站内信时间
 */
-(void)resetLastGetMessageTime{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_GET_MESSAGE_TIME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
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
    __weak typeof(self) weakSelf = self;
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Message_GetMessageList paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        weakSelf.haveNewMessage = NO;
        [weakSelf saveLastGetMessageTime];
        NSArray * messageList = [MessageEntity mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(messageList);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 获取最新站内信数量
 
 @param success success
 @param fail fail
 */
-(void)getNewMessageCountSuccess:(SuccessBlock)success
                           fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"lastModifyTime":[self getLastGetMessageTime],
        @"customerNo":[[UserManager shareUserManager] getCustomerNo]
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
 是否有最新站内信
 
 @return yes 有 no 没有
 */
-(BOOL)getHaveNewMessage{
    return [[NSUserDefaults standardUserDefaults]boolForKey:HAVE_NEW_MESSAGE];
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
 处理消息 中 的links
 */
-(void)handlerMessageLinks:(NSString *)messageLinks{
    NSArray * array = [messageLinks componentsSeparatedByString:@"?"];
    NSString * pathType = [array firstObject];
    if ([Message_LinkType_Action isEqualToString:pathType]) {
        NSString * actionType = array[1];
        if ([Message_LinkAction_Login isEqualToString:actionType]) {
            MSLog(@"静默更新用户信息");
        }
    } else if ([Message_LinkType_OrderDetail isEqualToString:pathType]) {
        NSString * paramStr = array[1];
        NSArray * paramArray = [paramStr componentsSeparatedByString:@"&"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        for (NSString * param in paramArray) {
            NSArray * tempArray = [param componentsSeparatedByString:@"="];
            [dict setObject:tempArray[1] forKey:tempArray[0]];
        }
        OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
        orderDetailVC.orderNo = [dict objectForKey:@"orderno"];
        UIViewController * currentVC = Util_GetCurrentVC;
        [currentVC.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

#pragma mark - setters and getters
-(void)setHaveNewMessage:(BOOL)haveNewMessage{
    _haveNewMessage = haveNewMessage;
    [[NSUserDefaults standardUserDefaults] setBool:haveNewMessage forKey:HAVE_NEW_MESSAGE];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_HAVENEWMESSAGE object:self userInfo:@{NOTIFICATION_DATA_HAVE_NEW_MESSAGE_KEY:kBoolNumber(haveNewMessage)}];
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
               MSLog(@"计时+1");
               [weakSelf getNewMessageCountSuccess:^(id  _Nonnull data) {
                   if ([data intValue] > 0) {
                       weakSelf.haveNewMessage = YES;
                   } else {
                       weakSelf.haveNewMessage = NO;
                   }
               } fail:^(NSInteger code) {
                   
               }];
           });
       });
       // 启动任务，GCD计时器创建后需要手动启动
       dispatch_resume(_gcdTimer);
   }
    return _gcdTimer;
}
@end
