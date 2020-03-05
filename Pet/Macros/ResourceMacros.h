//
//  ResourceMacros.h
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#ifndef ResourceMacros_h
#define ResourceMacros_h

#pragma mark - Iconfont Resource Macros

#define IconFont_Bill_2         @"\U0000E605" // 单据_2 审批
#define IconFont_Withdrawal     @"\U0000E607" // 提现
#define IconFont_Pet            @"\U0000E608" // 宠物
#define IconFont_Add            @"\U0000E609" // 新增
#define IconFont_Phone          @"\U0000E60A" // 电话
#define IconFont_Scan           @"\U0000E60B" // 扫描
#define IconFont_Star           @"\U0000E60C" // 星星
#define IconFont_AirPlane       @"\U0000E60D" // 飞机
#define IconFont_WechatPay      @"\U0000E60E" // 微信支付
#define IconFont_Station        @"\U0000E60F" // 驿站
#define IconFont_Unselected     @"\U0000E610" // 未选中
#define IconFont_Selected       @"\U0000E611" // 选中
#define IconFont_Home           @"\U0000E612" // 首页
#define IconFont_ChangeRole     @"\U0000E613" // 角色转换
#define IconFont_Location_2     @"\U0000E614" // 定位_2
#define IconFont_Car            @"\U0000E616" // 汽运
#define IconFont_Recharge       @"\U0000E617" // 充值
#define IconFont_Coupon         @"\U0000E618" // 优惠券
#define IconFont_Search         @"\U0000E619" // 搜索
#define IconFont_Setting        @"\U0000E625" // 设置
#define IconFont_Cancel         @"\U0000E627" // 取消
#define IconFont_Bill           @"\U0000E629" // 单据 全部
#define IconFont_Delete         @"\U0000E62B" // 删除
#define IconFont_Location       @"\U0000E62C" // 定位
#define IconFont_Wechat         @"\U0000E638" // 微信Logo
#define IconFont_NoData         @"\U0000E642" // 无数据
#define IconFont_Apply          @"\U0000E665" // 申请
#define IconFont_Play           @"\U0000E667" // 播放
#define IconFont_Bill_4         @"\U0000E669" // 单据_4 入港单
#define IconFont_Bill_3         @"\U0000E66A" // 单据_3 出港单
#define IconFont_Train          @"\U0000E674" // 火车
#define IconFont_Bill_5         @"\U0000E67F" // 单据_5 待付款
#define IconFont_Time           @"\U0000E6C2" // 时间
#define IconFont_QRCode         @"\U0000E6D2" // 二维码
#define IconFont_ServiceCall    @"\U0000E71C" // 客服
#define IconFont_AboutUs        @"\U0000E728" // 关于我们
#define IconFont_Message        @"\U0000E764" // 信息
#define IconFont_NotNull        @"\U0000E83D" // 必填

#pragma mark - Color Resource Macros

#define Color_Cell_Bg           kRGBColor(240,240,240)


#define Color_black_1           [UIColor blackColor]
#define Color_white_1           [UIColor whiteColor]
#define Color_gray_1            [UIColor colorWithHexString:@"#f3f3f3"] // 灰
#define Color_gray_2            [UIColor lightGrayColor]
#define Color_gray_3            [UIColor darkGrayColor]
#define Color_gray_4            [UIColor colorWithHexString:@"#708090"] // slatGray
#define Color_Clear             [UIColor clearColor]
#define Color_red_1             [UIColor colorWithHexString:@"#ee2c2c"] // 红
#define Color_red_2             [UIColor colorWithHexString:@"#ed3f14"] // 红
#define Color_green_1           [UIColor colorWithHexString:@"#19be6b"] // 绿
#define Color_green_wechat      [UIColor colorWithHexString:@"#04BE02"] // 微信绿
#define Color_blue_1            [UIColor colorWithHexString:@"#2db7f5"] // 淡蓝
#define Color_blue_2            [UIColor colorWithHexString:@"#778899"] // 蓝灰
#define Color_blue_3            [UIColor colorWithHexString:@"#f4f7fe"] // 蓝白
#define Color_yellow_1          [UIColor colorWithHexString:@"#f1b000"] // 橙黄


#pragma mark - Image Resource Macros

#define Image_Logo              @"logo"
#define Image_Account           @"icon_accout"
#define Image_Password          @"icon_password"


#pragma mark - String Resource Macros

#define Map_Key_Tencent         @"3MEBZ-MYJE4-ENMU2-DNNDM-3UXXZ-5CB4U" // 腾讯地图key

#define Ali_Push_SDK_Key        @"28311432" // 阿里推送 key
#define Ali_Push_SDK_Secret     @"2be891ccda0e27c7b209096bfdd03047" // 阿里推送 secret

#define Wechat_App_Id           @"wxdfa53b67908e1615" // 微信 appID
#define Wechat_App_Secret       @"a98f73a886541412e5db990dc3ea7919" // 微信 appSecret
#define Wechat_Universal_Links  @"https://market.taochonghui.com/apple-app-site-association/" // 注册到微信的Universal links

#define Service_Phone           @"4007778889" // 默认服务电话


#pragma mark - Url Resource Macros

#ifdef DEBUG
#define URL_BASE                @"http://192.168.3.111:6060"
//#define URL_BASE                @"https://www.taochonghui.com"
#else
#define URL_BASE                @"https://www.taochonghui.com"
#endif

#define URL_Register            @"/api/customer" // 注册
#define URL_LoginWithPhone      @"" // 手机号登录
#define URL_LoginWithId         @"/api/oAuth/unionId" // 微信id 登录

#define URL_GetPhoneCode        @"/business/VerificationCode" // 获取短信验证码

#define URL_Pet_Type            @"/api/petType" // 宠物类型
#define URL_StartCity           @"/api/transport/listStartCity" // 始发城市列表
#define URL_EndCity             @"/api/transport/listEndCity" // 终点城市列表
#define URL_StorePhoneByCityName @"/api/business/getPhoneByCityName" // 通过城市获取商家电话
#define URL_InsureRateByCityName @"/api/consign/insure" // 查询保价费率
#define URL_AbleTransportType   @"/api/transport/listTransportType" // 可用运输方式
#define URL_AblePetCageMax      @"/api/consign/cage/max" // 最大箱子重量
#define URL_PredictPrice        @"/api/order/getOrderPrice" // 获取预估价格
#define URL_InsertOrder         @"/api/order/insertOrder" // 创建订单
#define URL_GetOrderAmount      @"/api/order/price" // 获取订单价格
#define URL_GetTranportPayParamForWechat @"/api/weChat/pay/getOrderPayParam" // 获取微信运输单支付参数
#define URL_GetPremiumPayParamForWechat @"/api/weChat/pay/getOrderPremiumParam" // 获取微信补价单支付参数
#define URL_GetRechargePayParamForWechat    @"/api/weChat/pay/getRechargeParam" // 获取微信充值支付参数

#define URL_Staion_List         @"/api/business/listByPosition" // 获取周边商家

#define URL_StatonListByCity    @"/api/staff/listByProvinceAndCity" // 根据城市获取站点列表

#define URL_ApplyStaff          @"/api/staff/applyForStaff" // 员工注册
#define URL_ApplyStation        @"/business/insetBusiness" // 站点注册


#define Wechat_URL_GetAccessToken(APPID,SECRET,CODE) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID,SECRET,CODE] // 获取 access_token

#define Wechat_URL_GetWechatUserInfo(ACCESS_TOKEN,OPENID) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",ACCESS_TOKEN,OPENID]

#define Wechat_URL_RefreshAccessToken(APPID,REFRESH_TOKEN) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",APPID,REFRESH_TOKEN] // 刷新 access_token





#endif /* ResourceMacros_h */
