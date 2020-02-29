//
//  WechatManager.m
//  Pet
//
//  Created by mac on 2020/2/28.
//  Copyright © 2020 mac. All rights reserved.
//

#import "WechatManager.h"
#import "RandomKey.h"

@interface WechatManager ()

@property (nonatomic, strong) NSString *authState;

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
-(void)getAccessTokenWithCode:(NSString *)wechatCode
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail{
    HttpRequestModel * requestModel = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:Wechat_URL_GetAccessToken(Wechat_App_Id, Wechat_App_Secret, wechatCode) isFullUrl:YES paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(@"");
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
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    self.authState = req.state = [NSString randomKey];
    self.delegate = delegate;
    [WXApi sendAuthReq:req viewController:viewController delegate:self completion:complete];
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
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthSucceed:)])
                    [self.delegate wechatAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthDenied)])
                    [self.delegate wechatAuthDenied];
                break;
            case WXErrCodeUserCancel:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatAuthCancel)])
                    [self.delegate wechatAuthCancel];
            default:
                break;
        }
    }
}
@end
