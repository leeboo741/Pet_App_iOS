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
#define IconFont_Logout         @"\U0000E66B" // 登出
#define IconFont_Train          @"\U0000E674" // 火车
#define IconFont_Bill_5         @"\U0000E67F" // 单据_5 待付款
#define IconFont_Time           @"\U0000E6C2" // 时间
#define IconFont_QRCode         @"\U0000E6D2" // 二维码
#define IconFont_ServiceCall    @"\U0000E71C" // 客服
#define IconFont_AboutUs        @"\U0000E728" // 关于我们
#define IconFont_Message        @"\U0000E764" // 信息
#define IconFont_NotNull        @"\U0000E83D" // 必填

#define IconFont_Home_Shuoming      @"\U0000E615" // 首页 下单说明
#define IconFont_Home_Jichongwu     @"\U0000E632" // 首页 寄宠物
#define IconFont_Home_Chongwudian   @"\U0000E6E3" // 首页 宠物店
#define IconFont_Home_Dingdan       @"\U0000E61A" // 首页 我的订单
#define IconFont_Home_Fujin         @"\U0000E723" // 首页 周边
#define IconFont_Home_Zhuizong      @"\U0000E68D" // 首页 订单跟踪

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

#define APP_TYPE                @"iOS" // app类型


#pragma mark - Url Resource Macros

#ifdef DEBUG
//#define URL_BASE                @"http://192.168.3.111:6060"
//#define URL_BASE                @"http://192.168.3.111:7070"
//#define URL_BASE                @"https://www.taochonghui.com"
#define URL_BASE                @"https://huji820.picp.vip"
#else
#define URL_BASE                @"https://www.taochonghui.com"
#endif
/**
 用户相关
 */
#define URL_Register            @"/api/customer" // 注册|完成
#define URL_LoginWithPhone      @"/api/oAuth/phone" // 手机号登录|完成
#define URL_LoginWithId         @"/api/oAuth/unionId" // 微信id 登录|完成

/**
 通用接口
 */
#define URL_GetPhoneCode        @"/business/VerificationCode" // 获取短信验证码|完成

/**
 下单相关
 */
#define URL_Pet_Type                @"/api/petType" // 宠物类型|完成
#define URL_StartCity               @"/api/transport/listStartCity" // 始发城市列表|完成
#define URL_EndCity                 @"/api/transport/listEndCity" // 终点城市列表
#define URL_StorePhoneByCityName    @"/api/business/getPhoneByCityName" // 通过城市获取商家电话|完成
#define URL_InsureRateByCityName    @"/api/consign/insure" // 查询保价费率|完成
#define URL_AbleTransportType       @"/api/transport/listTransportType" // 可用运输方式|完成
#define URL_AblePetCageMax          @"/api/consign/cage/max" // 最大箱子重量|完成
#define URL_PredictPrice            @"/api/order/getOrderPrice" // 获取预估价格|完成
#define URL_InsertOrder             @"/api/order/insertOrder" // 创建订单|完成
#define URL_GetOrderAmount          @"/api/order/price" // 获取订单价格|完成

/**
 支付相关
 */
#define URL_GetTranportPayParamForWechat    @"/api/weChat/pay/getOrderPayParam" // 获取微信运输单支付参数|完成
#define URL_GetPremiumPayParamForWechat     @"/api/weChat/pay/getOrderPremiumParam" // 获取微信补价单支付参数
#define URL_GetRechargePayParamForWechat    @"/api/weChat/pay/getRechargeParam" // 获取微信充值支付参数

/**
 订单相关
 */
#define URL_Order_Detail    @"/api/order/orderDetail" // 获取订单详情

/**
 客户订单相关
 */
#define URL_Customer_GetOrderListByStatus   @"/api/order/listOrderList" // 根据订单类型查询客户订单列表
#define URL_Customer_EditOrderContacts      @"/api/order/update/contacts" // 编辑订单联系人
#define URL_Customer_OrderConfirm           @"/api/order/confirmOrder" // 确认收货 POST
#define URL_Customer_OrderAbleConfirm       @"/api/order/check/order" // 是否有收货权限 GET
#define URL_Customer_OrderCancel            @"/api/order/cancelOrder" // 取消订单 PUT
#define URL_Customer_SearchOrder            @"/api/consign/order-no/customer" // 模糊搜索订单号 GET 未完成
#define URL_Customer_EvaluateOrder          @"/api/order/evaluate" // 订单评价 POST
#define URL_Customer_Balance                @"/api/balance" // 查询用户余额

/**
 员工相关
 */
#define URL_Site_AddOrderRemark         @"/api/order/remarks" // 添加订单备注 POST
#define URL_Site_AddPremium             @"/api/order/premium" // 新增补价单 POST
#define URL_Site_CancelPremium          @"/api/order/premium/cancel" // 取消补价单 PUT
#define URL_Site_GetUnpayPremiumCount   @"/api/order/premium/count/unpaid" // 获取未支付的补价单数量
#define URL_Site_SearchOrder            @"/api/consign/order-no/staff" // 模糊搜索订单号
#define URL_Site_RebateFlow             @"/api/rebate/station/flow" // 站点返利流水
#define URL_Site_WithdrawFlow           @"/api/withdraw/station/flow" // 站点提现流水
#define URL_Site_Withdraw               @"/api/withdraw/station" // 站点提现
#define URL_Site_BalanceBuffer          @"/api/balance/buffer/station" // 站点可用金额和冻结金额
#define URL_Site_OrderListAllByState    @"/api/order/list/station" // 站点所有订单
#define URL_Site_UpdateOrderPrice       @"/api/order/update/price" // 修改订单价格
#define URL_Site_OrderListByOrderNo     @"/api/consign/port/listByLikeOrderNo" // 查询出入港单
#define URL_Site_OrderListAll           @"/api/consign/port/list/Complete" // 站点所有订单
#define URL_Site_UploadMediaFiles       @"/api/consign/orderState/uploadMediaFiles" // 上传图片和视频
#define URL_Site_GetAllSubStaff(CustomerNo) [NSString stringWithFormat:@"/api/staff/%@",CustomerNo]  // 查询站点员工
#define URL_Site_Assignment             @"/api/order/assignment/" // 订单分配
#define URL_Site_Refund                 @"/api/order/refund" // 订单退款
#define URL_Site_InOrOutPort            @"/api/consign/orderState/inOrOutPort" // 订单出入港
#define URL_Site_PostTransportInfo      @"/api/order/transport" // 添加快递信息
#define URL_Site_AddNewTempDeliver      @"/api/order/deliver" // 添加临派信息
#define URL_Site_OrderConfirm           @"/api/order/confirmOrder" // 签收

/**
 商家相关
 */
#define URL_Station_List            @"/api/business/listByPosition" // 获取周边商家|完成
#define URL_Station_RebateFlow      @"/api/rebate/business/flow" // 商家返利流水
#define URL_Station_WithdrawFlow    @"/api/withdraw/business/flow" // 商家提现流水
#define URL_Station_Withdraw        @"/api/withdraw/business" // 商家提现
#define URL_Station_BalanceBuffer   @"/api/balance/buffer/business" // 商家可用金额和冻结金额

/**
 申请相关
 */
#define URL_ApplyStaff                      @"/api/staff/applyForStaff" // 员工注册 |完成
#define URL_ApplyStation                    @"/business/insetBusiness" // 站点注册 |完成
#define URL_StatonListByCity                @"/api/staff/listByProvinceAndCity" // 根据城市获取站点列表|完成
#define URL_Apply_Staff_UnauditedList       @"/api/staff/listUnauditedStaff" // 员工申请列表
#define URL_Apply_Staff_Reject              @"/api/staff/reject" // 驳回员工申请
#define URL_Apply_Staff_Apply               @"/api/staff/review" // 通过员工申请
#define URL_Apply_Business_UnauditedList    @"/api/business/listAllUnauditedBusiness" // 商家申请列表
#define URL_Apply_Business_Reject           @"/api/business/reject" // 驳回商家申请
#define URL_Apply_Business_Apply            @"/api/business/review" // 通过商家申请

/**
 消息相关
 */
#define URL_Message_GetMessageList      @"/api/message/customer" // 获取 站内信列表
#define URL_Message_GetNewMessageList   @"/api/message/push/" // 获取 最新站内信

/**
 微信接口
 */
#define Wechat_URL_GetAccessToken(APPID,SECRET,CODE) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID,SECRET,CODE] // 获取 access_token

#define Wechat_URL_GetWechatUserInfo(ACCESS_TOKEN,OPENID) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",ACCESS_TOKEN,OPENID]

#define Wechat_URL_RefreshAccessToken(APPID,REFRESH_TOKEN) [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",APPID,REFRESH_TOKEN] // 刷新 access_token

#endif /* ResourceMacros_h */
