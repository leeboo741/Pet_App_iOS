//
//  WechatManager.h
//  Pet
//
//  Created by mac on 2020/2/28.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import "HttpManager.h"


NS_ASSUME_NONNULL_BEGIN

@protocol WechatAuthDelegate <NSObject>

@optional
- (void)wechatAuthSucceed:(NSString*_Nullable)code;
- (void)wechatAuthDenied;
- (void)wechatAuthCancel;
@end

@protocol WechatPayDelegate <NSObject>

@optional
-(void)wechatPaySuccess;
-(void)wechatPayFail;
-(void)wechatPayCancel;

@end

@interface WechatPayParam : NSObject
@property (nonatomic, copy) NSString * partnerid;
@property (nonatomic, copy) NSString * package;
@property (nonatomic, copy) NSString * timestamp;
@property (nonatomic, copy) NSString * paySign;
@property (nonatomic, copy) NSString * noncestr;
@property (nonatomic, copy) NSString * appid;
@property (nonatomic, copy) NSString * prepayid;
@end

@interface WechatToken : NSObject
@property (nonatomic, copy) NSString * refresh_token; // 刷新 token 30天有效期
@property (nonatomic, copy) NSString * scope; // 授权域
@property (nonatomic, copy) NSString * unionid; // 联合 id
@property (nonatomic, copy) NSString * expires_in; // 过期时间
@property (nonatomic, copy) NSString * access_token; // token 2小时有效期
@property (nonatomic, copy) NSString * openid; // open id
@end

@interface WechatRefreshToken: NSObject
@property (nonatomic, copy) NSString * refresh_token;
@property (nonatomic, copy) NSString * scope;
@property (nonatomic, copy) NSString * expires_in;
@property (nonatomic, copy) NSString * access_token;
@property (nonatomic, copy) NSString * openid;
@end

@interface WechatUserInfo : NSObject
@property (nonatomic, copy) NSString * country;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, strong) NSArray * privilege;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * headimgurl;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * openid;
@property (nonatomic, copy) NSString * unionid;
@end

@interface WechatManager : NSObject <WXApiDelegate>
@property (nonatomic, assign) id<WechatAuthDelegate, NSObject> delegate;
@property (nonatomic, weak) id<WechatPayDelegate> payDelegate;
SingleInterface(WechatManager);

/**
 * 注册 app
 *
 * @return 是否注册成功
 */
-(BOOL)registerApp;

/**
 处理 openurl 请求  ios 9.0 以下响应 本项目目前支持9.0以上 所以基本是用不上了
 */
-(BOOL)handlerOpenUrl:(NSURL *)url;

/**
 处理 微信授权完成回到 app的情况 ios 9.0 以上响应
 */
-(BOOL)handlerOpenUniversalLinsk:(NSUserActivity*)userActivity;

/**
 是否安装了微信
 */
-(BOOL)isWechatInstalled;

/**
 获取 access_token openid unionid
 
 @param wechatCode 授权登录返回的 code
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getWechatTokenWithCode:(NSString *)wechatCode
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail;

/**
 刷新 微信登录令牌
 
 @param success 成功回调
 @param fail 失败回调
 */
-(void)refreshWechatTokenWithSuccess:(SuccessBlock)success
                                fail:(FailBlock)fail;

/**
 获取微信用户信息
 
 @param accessToken access_token
 @param openid openid
 @param success sucess
 @param fail fail
 */
-(void)getWechatUserInfo:(NSString *)accessToken
                  openid:(NSString *)openid
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;
/**
 *  发送微信验证请求.
 *
 *  @restrict 该方法支持未安装微信的用户.
 *
 *  @param viewController 发起验证的VC
 *  @param delegate       处理验证结果的代理
 *  @param complete       发送完成结果
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WechatAuthDelegate>)delegate
                             complete:(void (^ __nullable)(BOOL success))complete;

/**
 *  发送链接到微信.
 *
 *  @restrict 该方法要求用户一定要安装微信.
 *
 *  @param urlString 链接的Url
 *  @param title     链接的Title
 *  @param desc      链接的描述
 *  @param scene     发送的场景，分为朋友圈, 会话和收藏
 *  @param complete   发送结果
 *
 */
- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)desc
                AtScene:(enum WXScene)scene
               complete:(void (^ __nullable)(BOOL success))complete;
/**
 *  发送文件到微信.
 *
 *  @restrict 该方法要求用户一定要安装微信.
 *
 *  @param fileData   文件的数据
 *  @param extension  文件扩展名
 *  @param title      文件的Title
 *  @param desc       文件的描述
 *  @param thumbImage 文件缩略图
 *  @param scene      发送的场景，分为朋友圈, 会话和收藏
 *  @param complete   发送结果
 */
- (void)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)desc
          ThumbImage:(UIImage *)thumbImage
             AtScene:(enum WXScene)scene
             complete:(void (^ __nullable)(BOOL success))complete;

/**
 发送 支付 请求
 
 @param payParam 支付参数
 @param delegate payDelegate
 @param complete 完成回调
 */
-(void)sendPayRequestWithParam:(WechatPayParam *)payParam delegate:(id<WechatPayDelegate>)delegate complete:(void (^ __nullable)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
