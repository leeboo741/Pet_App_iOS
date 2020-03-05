//
//  WechatManager.m
//  Pet
//
//  Created by mac on 2020/2/28.
//  Copyright © 2020 mac. All rights reserved.
//

#import "WechatManager.h"
#import "RandomKey.h"

@interface WechatPayParam ()

@end

@implementation WechatPayParam

@end

@interface WechatToken ()

@end

@implementation WechatToken

@end

@interface WechatRefreshToken ()

@end

@implementation WechatRefreshToken

@end

@interface WechatUserInfo ()

@end

@implementation WechatUserInfo

@end

@interface WechatManager ()

@property (nonatomic, strong) NSString *authState;

@property (nonatomic, strong) WechatToken * wechatToken;
@property (nonatomic, strong) WechatUserInfo * wechatUserInfo;

@end

@implementation WechatManager
SingleImplementation(WechatManager);


#pragma mark - Public Methods
#pragma mark -

/**
 注册 app
 
 @return 是否注册成功
 */
-(BOOL)registerApp{
    return [WXApi registerApp:Wechat_App_Id universalLink:Wechat_Universal_Links];
}

/**
 处理 openurl 请求  ios 9.0 以下响应 本项目目前支持9.0以上 所以基本是用不上了
 
 @param url openUrl
 */
-(BOOL)handlerOpenUrl:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

/**
 处理 微信授权完成回到 app的情况 ios 9.0 以上响应
 
 @param userActivity userActivity
 */
-(BOOL)handlerOpenUniversalLinsk:(NSUserActivity *)userActivity{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];;
}

/**
 是否安装了微信
 
 @return 是否安装
 */
-(BOOL)isWechatInstalled{
    return [WXApi isWXAppInstalled];
}

/**
 获取 access_token
 
 @param wechatCode 授权登录返回的 code
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getWechatTokenWithCode:(NSString *)wechatCode
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail{
    __weak typeof(self)weakSelf = self;
    HttpRequestModel * requestModel = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:Wechat_URL_GetAccessToken(Wechat_App_Id, Wechat_App_Secret, wechatCode) isFullUrl:YES useDefaultHandler:NO paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatToken * wechatToken = [WechatToken mj_objectWithKeyValues:data];
        weakSelf.wechatToken = wechatToken;
        if (success) {
            success(wechatToken);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:requestModel];
}

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
                    fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    HttpRequestModel * requestModel = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:Wechat_URL_GetWechatUserInfo(accessToken, openid) isFullUrl:YES useDefaultHandler:NO paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatUserInfo * wechatUserInfo = [WechatUserInfo mj_objectWithKeyValues:data];
        weakSelf.wechatUserInfo = wechatUserInfo;
        if (success) {
            success(wechatUserInfo);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:requestModel];
}

/**
 刷新 微信登录令牌

 @param success 成功回调
 @param fail 失败回调
*/
-(void)refreshWechatTokenWithSuccess:(SuccessBlock)success fail:(FailBlock)fail{
    __weak typeof(self) weakSelf = self;
    HttpRequestModel * requestModel = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:Wechat_URL_RefreshAccessToken(Wechat_App_Id, self.wechatToken.refresh_token) isFullUrl:YES useDefaultHandler:NO paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        WechatRefreshToken * wechatRefreshToken = [WechatRefreshToken mj_objectWithKeyValues:data];
        if (kStringIsEmpty(wechatRefreshToken.refresh_token)) {
            MSLog(@"refresh_token 过期")
            if (fail) {
                fail(HttpResponseCode_Wechat_RefreshTokenExpires);
            }
        } else {
            weakSelf.wechatToken.access_token = wechatRefreshToken.access_token;
            weakSelf.wechatToken.refresh_token = wechatRefreshToken.refresh_token;
            weakSelf.wechatToken.scope = wechatRefreshToken.scope;
            weakSelf.wechatToken.expires_in = wechatRefreshToken.expires_in;
            weakSelf.wechatToken.openid = wechatRefreshToken.openid;
            if (success) {
                success(weakSelf.wechatToken);
            }
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:requestModel];
}


/**
*  发送微信验证请求.
*
*  @restrict 该方法支持未安装微信的用户.
*
*  @param viewController 发起验证的VC
*  @param delegate       处理验证结果的代理
*  @param complete       发送完成结果
*
*/
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WechatAuthDelegate>)delegate
                             complete:(void (^ __nullable)(BOOL success))complete{
    if ([self isWechatInstalled]) {
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        self.authState = req.state = [NSString randomKey];
        self.delegate = delegate;
        [WXApi sendAuthReq:req viewController:viewController delegate:self completion:complete];
    } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"尚未安装微信" message:@"请先安装微信App" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        UIViewController * currentVC = Util_GetCurrentVC;
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}

/**
 *  发送链接到微信.
 *
 *  @restrict 该方法要求用户一定要安装微信.
 *
 *  @param urlString 链接的Url
 *  @param title     链接的Title
 *  @param description      链接的描述
 *  @param scene     发送的场景，分为朋友圈, 会话和收藏
 *  @param complete   发送结果
 *
 */
- (void)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                AtScene:(enum WXScene)scene
                complete:(void (^ __nullable)(BOOL success))complete{
    
    if (![self isWechatInstalled]) {
        [MBProgressHUD showErrorMessage:@"您还没有安装微信,不能使用该功能"];
        return;
    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    message.mediaObject = ext;
    message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"wxLogoGreen"]);

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
    [WXApi sendReq:req completion:complete];
}
/**
*  发送文件到微信.
*
*  @restrict 该方法要求用户一定要安装微信.
*
*  @param fileData   文件的数据
*  @param extension  文件扩展名
*  @param title      文件的Title
*  @param description       文件的描述
*  @param thumbImage 文件缩略图
*  @param scene      发送的场景，分为朋友圈, 会话和收藏
*  @param complete   发送结果
*
*/
- (void)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             AtScene:(enum WXScene)scene
             complete:(void (^ __nullable)(BOOL success))complete{
    if (![self isWechatInstalled]) {
        [MBProgressHUD showErrorMessage:@"您还没有安装微信,不能使用该功能"];
        return;
    }

    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
    
   [WXApi sendReq:req completion:complete];
}

/**
 发送 支付 请求
 
 @param payParam 支付参数
 @param delegate payDelegate
 @param complete 完成回调
 */
-(void)sendPayRequestWithParam:(WechatPayParam *)payParam delegate:(id<WechatPayDelegate>)delegate complete:(void (^ __nullable)(BOOL success))complete{
    self.payDelegate = delegate;
    PayReq * payReq = [[PayReq alloc]init];
    payReq.prepayId = payParam.prepayid;
    payReq.nonceStr = payParam.noncestr;
    payReq.package = payParam.package;
    payReq.partnerId = payParam.partnerid;
    payReq.sign = payParam.paySign;
    payReq.timeStamp = [payParam.timestamp intValue];
    [WXApi sendReq:payReq completion:complete];
}

#pragma mark - WXApiDelegate
#pragma mark -

-(void)onReq:(BaseReq *)req{
    // just leave it here, WeChat will not call our app
}
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        /* Prevent Cross Site Request Forgery */
        if (![authResp.state isEqualToString:self.authState]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthDenied)])
                [self.delegate wechatAuthDenied];
            return;
        }
        
        switch (resp.errCode) {
            case WXSuccess:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthSucceed:)])
                    [self.delegate wechatAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                [MBProgressHUD showTipMessageInWindow:@"授权失败"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthDenied)])
                    [self.delegate wechatAuthDenied];
                break;
            case WXErrCodeUserCancel:
                [MBProgressHUD showTipMessageInWindow:@"取消授权"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthCancel)])
                    [self.delegate wechatAuthCancel];
            default:
                break;
        }
    }else if([resp isKindOfClass:[PayResp class]]){
           
           switch (resp.errCode) {
               case WXSuccess:
                   if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(wechatPaySuccess)]) {
                       [self.payDelegate wechatPaySuccess];
                   }
                   break;
               case WXErrCodeUserCancel:
                   [MBProgressHUD showTipMessageInWindow:@"取消支付"];
                   if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(wechatPayCancel)]) {
                       [self.payDelegate wechatPayCancel];
                   }
                   break;
               default:
                   [MBProgressHUD showTipMessageInWindow:@"支付失败"];
                   if (self.payDelegate && [self.payDelegate respondsToSelector:@selector(wechatPayFail)]) {
                       [self.payDelegate wechatPayFail];
                   }
                   break;
           }
       }
}
@end
