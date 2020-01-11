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
#define IconFont_Station        @"\U0000E60F" // 驿站
#define IconFont_Unselected     @"\U0000E610" // 未选中
#define IconFont_Selected       @"\U0000E611" // 选中
#define IconFont_Home           @"\U0000E612" // 首页
#define IconFont_ChangeRole     @"\U0000E613" // 角色转换
#define IconFont_Location_2     @"\U0000E614" // 定位_2
#define IconFont_Car            @"\U0000E616" // 汽运
#define IconFont_Recharge       @"\U0000E617" // 充值
#define IconFont_Coupon         @"\U0000E618" // 优惠券
#define IconFont_Setting        @"\U0000E625" // 设置
#define IconFont_Cancel         @"\U0000E627" // 取消
#define IconFont_Bill           @"\U0000E629" // 单据 全部
#define IconFont_Delete         @"\U0000E62B" // 删除
#define IconFont_Location       @"\U0000E62C" // 定位
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
#define Color_blue_1            [UIColor colorWithHexString:@"#2db7f5"] // 淡蓝
#define Color_blue_2            [UIColor colorWithHexString:@"#778899"] // 蓝灰
#define Color_blue_3            [UIColor colorWithHexString:@"#f4f7fe"] // 蓝白
#define Color_yellow_1          [UIColor colorWithHexString:@"#f1b000"] // 橙黄


#pragma mark - Image Resource Macros

#define Image_Logo              @"logo"
#define Image_Account           @"icon_accout"
#define Image_Password          @"icon_password"


#pragma mark - String Resource Macros

#define Map_Key_Tencent         @"3MEBZ-MYJE4-ENMU2-DNNDM-3UXXZ-5CB4U"


#pragma mark - Url Resource Macros

#ifdef DEBUG
#define HTTP_BASE_URL           @"http://192.168.3.111:6060"
#else
#define HTTP_BASE_URL           @"https://www.taochonghui.com"
#endif


#endif /* ResourceMacros_h */
