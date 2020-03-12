//
//  UserManager.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UserManager.h"
#import <WXApi.h>

@implementation RegisterUserInfo
-(instancetype)init{
    self = [super init];
    if (self) {
        self.sex = SEX_MALE;
    }
    return self;
}
-(NSString *)sexStr{
    if (self.sex == SEX_MALE) {
        return @"男";
    } else {
        return @"女";
    }
}
-(NSString *)appType{
    return APP_TYPE;
}

+(RegisterUserInfo *)getUserInfoFromWechatUserInfo:(WechatUserInfo *)wechatUserInfo{
    RegisterUserInfo * registerUserinfo = [[RegisterUserInfo alloc]init];
    registerUserinfo.headImageUrl = wechatUserInfo.headimgurl;
    registerUserinfo.nickName = wechatUserInfo.nickname;
    registerUserinfo.openid = wechatUserInfo.openid;
    registerUserinfo.unionid = wechatUserInfo.unionid;
    registerUserinfo.sex = [wechatUserInfo.sex integerValue];
    return registerUserinfo;
}

@end

static NSString * User_Key = @"USER_KEY";

@interface UserManager ()
@property (nonatomic, strong) UserEntity * user;
@end

@implementation UserManager

#pragma mark - life cycle
/**
 *  单例
 */
SingleImplementation(UserManager)
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addObserver:self
               forKeyPath:@"user"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [self.user addObserver:self
                    forKeyPath:@"currentRole"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
    }
    return self;
}

#pragma mark - public method

/**
 手机号码登录
 
 @param phone 手机号码
 @param jsessionId jsessionId
 @param code 短信验证码
 @param success success
 @param fail fail 
 */
-(void)loginWithPhone:(NSString *)phone
           jsessionId:(NSString *)jsessionId
                 code:(NSString *)code
              success:(SuccessBlock)success
                 fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_LoginWithPhone paramers:@{@"phone":phone,@"verificationCode":code} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",jsessionId];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    HttpManager * httpManager = [HttpManager shareHttpManager];
    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST",@"GET",@"HEAD"]];
    [httpManager requestWithRequestModel:model];
}

/**
 微信 unionid 登录
 
 @param unionid 微信 unionid
 @param success success
 @param fail fail
 */
-(void)loginWithWechatUnionid:(NSString *)unionid
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_LoginWithId paramers:@{@"unionId":unionid} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * httpManager = [HttpManager shareHttpManager];
    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST",@"GET",@"HEAD"]];
    [httpManager requestWithRequestModel:model];
}

/**
 注册用户
 
 @param registerUserInfo 注册用户
 @param jsessionid jsessionid
 @param success success
 @param fail fail
 */
-(void)registerUser:(RegisterUserInfo *)registerUserInfo
         jsessionid:(NSString *)jsessionid
            success:(SuccessBlock)success
               fail:(FailBlock)fail{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (kStringIsEmpty(registerUserInfo.phone)) {
        [MBProgressHUD showTipMessageInWindow:@"手机号不能为空"];
        return;
    }
    [dict setObject:registerUserInfo.phone forKey:@"phone"];
    if (kStringIsEmpty(registerUserInfo.verificationCode)) {
        [MBProgressHUD showTipMessageInWindow:@"验证码不能为空"];
        return;
    }
    [dict setObject:registerUserInfo.verificationCode forKey:@"verificationCode"];
    if (!kStringIsEmpty(registerUserInfo.nickName)) {
        [dict setObject:registerUserInfo.nickName forKey:@"customerName"];
    }
    if (!kStringIsEmpty(registerUserInfo.headImageUrl)) {
        [dict setObject:[LeeUtils replaceSepcialChar:registerUserInfo.headImageUrl] forKey:@"headerImage"];
    }
    if (!kStringIsEmpty(registerUserInfo.openid)) {
        [dict setObject:registerUserInfo.openid forKey:@"openId"];
    }
    if (!kStringIsEmpty(registerUserInfo.unionid)) {
        [dict setObject:registerUserInfo.unionid forKey:@"unionId"];
    }
    if (!kStringIsEmpty(registerUserInfo.appType)) {
    }
    if (!kStringIsEmpty(registerUserInfo.shareStationNo)) {
        [dict setObject:registerUserInfo.shareStationNo forKey:@"shareOpenId"];
    }
    if (!kStringIsEmpty(registerUserInfo.shareBusinessNo)) {
        [dict setObject:registerUserInfo.shareBusinessNo forKey:@"businessNo"];
    }
    [dict setObject:registerUserInfo.appType forKey:@"appType"];
    [dict setObject:registerUserInfo.sexStr forKey:@"sex"];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Register paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",jsessionid];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    HttpManager * httpManager = [HttpManager shareHttpManager];
    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST",@"GET",@"HEAD"]];
    [httpManager requestWithRequestModel:model];
}

/**
 *  保存用户
 *  @param user 用户
 */
-(void)saveUser:(UserEntity *)user{
    self.user = user;
//    [UserDataBaseHandler updateUser:user];
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:User_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  获取用户
 */
-(UserEntity *)getUser{
    return self.user;
}
/**
 *  改变用户角色
 *  @param role 角色
 */
-(void)changeUserRole:(CURRENT_USER_ROLE)role{
    self.user.currentRole = role;
//    [UserDataBaseHandler updateUser:self.user];
    
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:self.user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:User_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  获取用户当前角色
 */
-(CURRENT_USER_ROLE)getCurrentUserRole{
    return self.user.currentRole;
}
/**
 获取用户角色
 */
-(USER_ROLE)getUserRole{
    return self.user.userRole;
}
-(BOOL)isStaff{
    return self.user.userRole == USER_ROLE_B_MANAGER
    || self.user.userRole == USER_ROLE_MANAGER
    || self.user.userRole == USER_ROLE_B_DRIVER
    || self.user.userRole == USER_ROLE_DRIVER
    || self.user.userRole == USER_ROLE_B_SERVICE
    || self.user.userRole == USER_ROLE_SERVICE;
}
-(BOOL)isManager{
    return self.user.userRole == USER_ROLE_B_MANAGER
    || self.user.userRole == USER_ROLE_MANAGER;
}
-(BOOL)isDriver{
    return self.user.userRole == USER_ROLE_B_DRIVER
    || self.user.userRole == USER_ROLE_DRIVER;
}
-(BOOL)isService{
    return self.user.userRole == USER_ROLE_B_SERVICE
    || self.user.userRole == USER_ROLE_SERVICE;
}
-(BOOL)isBusiness{
    return self.user.userRole == USER_ROLE_B_MANAGER
    || self.user.userRole == USER_ROLE_B_DRIVER
    || self.user.userRole == USER_ROLE_B_SERVICE
    || self.user.userRole == USER_ROLE_BUSINESS;
}
/**
 获取员工
 */
-(StaffEntity *)getStaff{
    return self.user.staff;
}
/**
 获取员工编号
 */
-(NSString *)getStaffNo{
    return self.user.staff.staffNo;
}
/**
 *  获取客户编号
 */
-(NSString *)getCustomerNo{
    return self.user.customerNo;
}
/**
 *  获取商户编号
 */
-(NSString *)getBusinessNo{
    return self.user.business.businessNo;
}
/**
 *  获取站点编号
 */
-(NSString *)getStationNo{
    return self.user.staff.station.stationNo;
}

/**
 *  获取手机号
 */
-(NSString *)getPhone{
    return self.user.phone;
}

/**
 *  注册UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 *  @parma action 注册响应方法
 */
-(void)registerUserManagerNotificationWithObserver:(id)observer
                                  notificationName:(NSString *)notificationName
                                            action:(SEL)action{
    // observer: 观察者
    // selector: 响应方法
    // name: 通知名称
    // object: 观察者只接收来自于object对象的发出的所注册通知
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:action
                                                 name:notificationName
                                               object:self];
}

/**
 *  移除UserManager相关通知监听
 *  @param observer 观察者
 *  @param notificationName 通知名称
 */
-(void)removeObserverForUserManager:(id)observer notificationName:(NSString *)notificationName{
    // observer: 观察者
    // name: 通知名称
    // object: 观察者只接收来自于object对象的发出的所注册通知
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:notificationName
                                                  object:self];
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"user"]) {
        [self postUserChangeNotification];
    } else if ([keyPath isEqualToString:@"currentRole"]) {
        [self postUserRoleChangeNotification];
    }
}

#pragma mark - notification

/**
 *  发送通知
 *  @param notificationName 通知名称
 *  @param data 附带数据
 */
-(void)postNotificationWithName:(NSString *)notificationName userInfoData:(id)data{
    // name: notification 注册名
    // object: 发送通知的对象
    // userInfo: 给观察者的额外信息
    NSDictionary * userInfo = nil;
    if (data != nil) {
        userInfo = @{@"data":data};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self userInfo:userInfo];
}

/**
 *  发送用户改变通知
 */
-(void)postUserChangeNotification{
    [self postNotificationWithName:USER_CHANGE_NOTIFICATION_NAME
                      userInfoData:self.user];
}

/**
 *  发送用户角色改变通知
 */
-(void)postUserRoleChangeNotification{
    [self postNotificationWithName:USER_ROLE_CHANGE_NOTIFICATION_NAME
                      userInfoData:kIntegerNumber(self.user.currentRole)];
}

#pragma mark - setters and getters
-(UserEntity *)user{
    if (!_user) {
//        _user = [UserDataBaseHandler getUser];
        NSData * userData = [[NSUserDefaults standardUserDefaults] objectForKey:User_Key];
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return _user;
}

@end
