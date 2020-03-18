//
//  SiteOrderManager.h
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpManager.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SiteOrderState) {
    SiteOrderState_ToPay, // 待付款
    SiteOrderState_ToPack, // 待揽件
    SiteOrderState_ToInport, // 待入港
    SiteOrderState_Inport, // 已入港
    SiteOrderState_ToOutport, // 待出港
    SiteOrderState_Outport, // 已出港
    SiteOrderState_ToArrived, // 待到达
    SiteOrderState_Arrived, // 已到达
    SiteOrderState_Delivering, // 派送中
    SiteOrderState_ToSign, // 待签收
    SiteOrderState_Completed, // 已完成
    SiteOrderState_All, // 全部
    SiteOrderState_UnKnow, // 未知
};

@interface InOrOutPortRequestParam : NSObject
@property (nonatomic, copy) NSString * staffNo;
@property (nonatomic, copy) NSString * stationNo;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, strong) NSMutableArray<NSString *>* orderTypeArray;
@property (nonatomic, copy) NSString * startOrderTime;
@property (nonatomic, copy) NSString * endOrderTime;
@property (nonatomic, copy) NSString * startLeaveTime;
@property (nonatomic, copy) NSString * endLeaveTime;

@property (nonatomic, strong) NSNumber * offset;
@property (nonatomic, strong) NSNumber * limit;
@end

@interface UploadMediaResult : NSObject
@property (nonatomic, assign) MediaType mediaType;
@property (nonatomic, copy) NSString * fileType;
@property (nonatomic, copy) NSString * uploadTime;
@property (nonatomic, copy) NSString * uploadDate;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * viewAddress;
@property (nonatomic, copy) NSString * fileAddress;
@end

@interface SiteOrderManager : NSObject
SingleInterface(SiteOrderManager);

/**
 获取站点订单
 
 @param param 参数
 @param success success
 @param fail fail
 */
-(void)getStationAllOrderByParam:(InOrOutPortRequestParam *)param
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail;

/**
 签收订单
 
 @param orderNo 订单编号
 @param fileList 文件地址列表
 @param success success
 @param fail fail
 */
-(void)confirmOrderByOrderNo:(NSString *)orderNo
                    fileList:(NSArray<NSString *> *)fileList
                     success:(SuccessBlock)success
                        fail:(FailBlock)fail;

/**
 添加临派信息
 
 @param tempDeliver 临派对象
 @param success success
 @param fail fail
 */
-(void)addNewTempDeliver:(OrderTempDeliver *)tempDeliver
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;

/**
 添加快递运输信息
 
 @param transportInfo 运输信息对象
 @param success success
 @param fail fail
 */
-(void)postTransportInfo:(OrderTransportInfo *)transportInfo
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail;

/**
 订单出入港
 
 @param orderNo 订单编号
 @param sn 订单序列
 @param orderType 订单状态
 @param fileList 文件列表
 @param success success
 @param fail fail 
 */
-(void)inOrOutPortWithOrderNo:(NSString *)orderNo
                           sn:(NSInteger)sn
                    orderType:(NSString *)orderType
                     fileList:(NSArray<NSString *> *)fileList
                     success:(SuccessBlock)success
                        fail:(FailBlock)fail;

/**
 发起退款
 
 @param order 订单
 @param serviceFeeAmount 扣减服务费用
 @param refundReason 退款原因
 @param success success
 @param fail fail
 */
-(void)addOrderRefund:(OrderEntity *)order
     serviceFeeAmount:(CGFloat)serviceFeeAmount
         refundReason:(NSString *)refundReason
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;

/**
 新增备注
 
 @param orderRemark 订单备注
 @param success success
 @param fail fail
 */
-(void)addOrderRemark:(OrderRemarks *)orderRemark
              success:(SuccessBlock)success
                 fail:(FailBlock)fail;

/**
 新增补价单
 
 @param orderPremium 补价单
 @param success success
 @param fail fail
 */
-(void)addOrderPremium:(OrderPremium *)orderPremium
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;

/**
 取消补价单
 
 @param billNo 补价单号
 @param success success
 @param fail fail
 */
-(void)cancelOrderPremiumWithBillNo:(NSString *)billNo
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

/**
 获取订单未支付补价单数量
 
 @param orderNo 订单编号
 @param success success
 @param fail fail
 */
-(void)getUnpayPremiumCountWithOrderNo:(NSString *)orderNo
                               success:(SuccessBlock)success
                                  fail:(FailBlock)fail;

/**
 模糊查询点单号
 
 @param orderNo 订单号
 @param success success
 @param fail fail
 */
-(void)getOrderNoByOrderNo:(NSString *)orderNo
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail;

/**
 获取对应状态 站点所有订单
 
 @param state 站点订单状态
 @param offset 下标
 @param limit 铲毒
 @param success success
 @param fail fail
 */
-(void)getSiteAllOrderByState:(SiteOrderState)state
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                      success:(SuccessBlock)success
                         fail:(FailBlock)fail;

/**
 获取出入港单
 
 @param param 请求参数
 @param success success
 @param fail fail
 */
-(void)getInOrOutPortOrderWithParam:(InOrOutPortRequestParam *)param
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

/**
 上传文件
 
 @param orderNo 订单编号
 @param mediaList 等待上传文件列表
 @param success success
 @param fail fail
 */
-(void)uploadMediaFilesWithOrderNo:(NSString *)orderNo
                  mediaUrlPathList:(NSArray<MediaSelectItemModel *> *)mediaList
                           success:(SuccessBlock)success
                              fail:(FailBlock)fail;

/**
 修改订单价格
 
 @param order 订单对象
 @param success success
 @param fail fail
 */
-(void)updateOrderPrice:(OrderEntity *)order
                success:(SuccessBlock)success
                   fail:(FailBlock)fail;

/**
 获取站点所有下属员工
 
 @param success success
 @param fail fail
 */
-(void)getSiteAllSubStaffSuccess:(SuccessBlock)success
                            fail:(FailBlock)fail;

/**
 分配订单
 
 @param orderNo 订单编号
 @param staffs 员工编号列表
 @param success success
 @param fail fail
 */
-(void)assignmentOrder:(NSString *)orderNo
              toStaffs:(NSArray<NSNumber *>*)staffs
               success:(SuccessBlock)success
                  fail:(FailBlock)fail;

/**
 获取 要提交的文件地址列表
 
 @param waitCommitMediaList 上传文件结果列表
 @return 要提交的文件地址列表
 */
-(NSArray<NSString *>*)getCommitFileListFromWaitCommitMediaList:(NSArray<MediaShowItemModel*> *)waitCommitMediaList;

/**
 获取站点订单状态 对应 字符串
 
 @param state 站点订单状态
 @return 对应字符串
 */
-(NSString *)getSiteOrderStateStringWithState:(SiteOrderState)state;

/**
 获取站点订单状态
 
 @param stateString 状态对应字符串
 @return 站点订单状态
 */
-(SiteOrderState)getSiteOrderStateByString:(NSString *)stateString;
@end

NS_ASSUME_NONNULL_END
