//
//  SiteOrderManager.m
//  Pet
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "SiteOrderManager.h"
@implementation InOrOutPortRequestParam
-(NSString *)staffNo{
    if (!_staffNo) {
        _staffNo = [[UserManager shareUserManager] getStaffNo];
    }
    return _staffNo;
}
-(NSString *)stationNo{
    if (!_stationNo) {
        _stationNo = [[UserManager shareUserManager] getStationNo];
    }
    return _stationNo;
}
-(NSString *)orderNo{
    return !_orderNo?@"":_orderNo;
}
-(NSMutableArray<NSString *> *)orderTypeArray{
    if (!_orderTypeArray) {
        _orderTypeArray = [NSMutableArray array];
    }
    return _orderTypeArray;
}
-(NSString *)startOrderTime{
    return !_startOrderTime?@"":_startOrderTime;
}
-(NSString *)endOrderTime{
    return !_endOrderTime?@"":_endOrderTime;
}
-(NSString *)startLeaveTime{
    return !_startLeaveTime?@"":_startLeaveTime;
}
-(NSString *)endLeaveTime{
    return !_endLeaveTime?@"":_endLeaveTime;
}
@end

@implementation UploadMediaResult
-(MediaType)mediaType{
    NSString * imageType = @"图片";
    if ([imageType isEqualToString:self.fileType]) {
        return MediaType_Image;
    } else {
        return MediaType_Video;
    }
}
@end

@implementation SiteOrderManager
SingleImplementation(SiteOrderManager);
/**
 获取站点订单
 
 @param param 参数
 @param success success
 @param fail fail
 */
-(void)getStationAllOrderByParam:(InOrOutPortRequestParam *)param
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"queryParamStr": [param mj_JSONString]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_OrderListAll paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSDictionary * dict = (NSDictionary *)data;
        NSArray<OrderEntity *> * array = [OrderEntity mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"data"]];
        if (success) {
            success(array);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}
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
                        fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"fileList": fileList
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_OrderConfirm paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET",@"HEAD",@"POST",@"PUT"]];
    [manager requestWithRequestModel:model];
}
/**
 添加临派信息
 
 @param tempDeliver 临派对象
 @param success success
 @param fail fail
 */
-(void)addNewTempDeliver:(OrderTempDeliver *)tempDeliver
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail{
    NSDictionary * dict = [tempDeliver mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_AddNewTempDeliver paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 添加快递运输信息
 
 @param transportInfo 运输信息对象
 @param success success
 @param fail fail
 */
-(void)postTransportInfo:(OrderTransportInfo *)transportInfo
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail{
    NSDictionary * dict = [transportInfo mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_PostTransportInfo paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
                         fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"sn": kIntegerNumber(sn),
        @"orderType": orderType,
        @"fileList": [fileList mj_JSONObject]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_InOrOutPort paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST"]];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    [manager requestWithRequestModel:model];
}

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
                 fail:(FailBlock)fail{
    NSDictionary *dict = @{
        @"order": [order mj_JSONObject],
        @"staff": [[[UserManager shareUserManager] getStaff] mj_JSONObject],
        @"serviceFeeAmount": kFloatNumber(serviceFeeAmount),
        @"refundReason": refundReason
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_Refund paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
//    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST"]];
    [manager requestWithRequestModel:model];
}

/**
 新增备注
 
 @param orderRemark 订单备注
 @param success success
 @param fail fail
 */
-(void)addOrderRemark:(OrderRemarks *)orderRemark
              success:(SuccessBlock)success
                 fail:(FailBlock)fail{
    NSDictionary * dict = [orderRemark mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Site_AddOrderRemark paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 新增补价单
 
 @param orderPremium 补价单
 @param success success
 @param fail fail
 */
-(void)addOrderPremium:(OrderPremium *)orderPremium
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
    NSDictionary * dict = [orderPremium mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_POST Url:URL_Site_AddPremium paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 取消补价单
 
 @param billNo 补价单号
 @param success success
 @param fail fail
 */
-(void)cancelOrderPremiumWithBillNo:(NSString *)billNo
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_PUT Url:URL_Site_CancelPremium paramers:@{@"billNo":billNo} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
获取订单未支付补价单数量

@param orderNo 订单编号
@param success success
@param fail fail
*/
-(void)getUnpayPremiumCountWithOrderNo:(NSString *)orderNo
                               success:(SuccessBlock)success
                                  fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_GetUnpayPremiumCount paramers:@{@"orderNo":orderNo} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 模糊查询点单号
 
 @param orderNo 订单号
 @param success success
 @param fail fail
 */
-(void)getOrderNoByOrderNo:(NSString *)orderNo
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"staffNo": [[UserManager shareUserManager] getStaffNo]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Site_SearchOrder paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 获取出入港单
 
 @param param 请求参数
 @param success success
 @param fail fail
 */
-(void)getInOrOutPortOrderWithParam:(InOrOutPortRequestParam *)param
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"queryParamStr": [param mj_JSONString]
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_OrderListByOrderNo paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<OrderEntity *> * array = [OrderEntity mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(array);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

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
                              fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo":orderNo,
    };
    __weak typeof(self) weakSelf = self;
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_UPLOAD Url:URL_Site_UploadMediaFiles paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [UploadMediaResult mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success([weakSelf getMediaShowItemModelListFromUploadFileResultList:array]);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    model.constructBlock = ^(id<AFMultipartFormData>  _Nonnull formData) {
        for (MediaSelectItemModel * model in mediaList) {
            [weakSelf getMediaDataFromPHAsset:model.data complete:^(NSData *data, NSString *fileName, NSString * mimeType) {
                [formData appendPartWithFileData:data name:@"multipartFiles" fileName:fileName mimeType:mimeType];
            }];
        }
    };
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}


/**
 获取 要提交的文件地址列表
 
 @param waitCommitMediaList 上传文件结果列表
 @return 要提交的文件地址列表
 */
-(NSArray<NSString *>*)getCommitFileListFromWaitCommitMediaList:(NSArray<MediaShowItemModel*> *)waitCommitMediaList{
    NSMutableArray * array = [NSMutableArray array];
    for (MediaShowItemModel * model in waitCommitMediaList) {
        [array addObject:model.resourcePath];
    }
    return [NSArray arrayWithArray:array];
}
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
                         fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"stationNo": [[UserManager shareUserManager] getStationNo],
        @"state": [self getSiteOrderStateStringWithState:state],
        @"offset":kIntegerNumber(offset),
        @"limit":kIntegerNumber(limit)
    };
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_OrderListAllByState paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<OrderEntity *> * array = [OrderEntity mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(array);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 修改订单价格
 
 @param order 订单对象
 @param success success
 @param fail fail
 */
-(void)updateOrderPrice:(OrderEntity *)order
                success:(SuccessBlock)success
                   fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_PUT Url:URL_Site_UpdateOrderPrice paramers:[order mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
    [manager requestWithRequestModel:model];
}

/**
 获取站点所有下属员工
 
 @param success success
 @param fail fail
 */
-(void)getSiteAllSubStaffSuccess:(SuccessBlock)success
                            fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_Site_GetAllSubStaff([[UserManager shareUserManager ] getCustomerNo]) paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray * array = [StaffEntity mj_objectArrayWithKeyValuesArray:data];
        if (success) {
            success(array);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

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
                  fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"orderNo": orderNo,
        @"customerNo": [[UserManager shareUserManager] getCustomerNo],
        @"staffNoList": staffs
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_Site_Assignment paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    HttpManager * manager = [HttpManager shareHttpManager];
//    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST"]];
    [manager requestWithRequestModel:model];
}

/**
 获取站点订单状态 对应 字符串
 
 @param state 站点订单状态
 @return 对应字符串
 */
-(NSString *)getSiteOrderStateStringWithState:(SiteOrderState)state{
    switch (state) {
        case SiteOrderState_All:
            return @"全部";
        case SiteOrderState_ToPay:
            return @"待付款";
        case SiteOrderState_ToPack:
            return @"待揽件";
        case SiteOrderState_ToInport:
            return @"待入港";
        case SiteOrderState_Inport:
            return @"已入港";
        case SiteOrderState_ToOutport:
            return @"待出港";
        case SiteOrderState_Outport:
            return @"已出港";
        case SiteOrderState_ToArrived:
            return @"待到达";
        case SiteOrderState_Arrived:
            return @"已到达";
        case SiteOrderState_Delivering:
            return @"派送中";
        case SiteOrderState_ToSign:
            return @"待签收";
        case SiteOrderState_Completed:
            return @"已完成";
        case SiteOrderState_UnKnow:
            return @"未知";
    }
}


#pragma mark - private
/**
 获取站点订单状态
 
 @param stateString 状态对应字符串
 @return 站点订单状态
 */
-(SiteOrderState)getSiteOrderStateByString:(NSString *)stateString{
    if ([[self getSiteOrderStateStringWithState:SiteOrderState_All] isEqualToString:stateString]) {
        return SiteOrderState_All;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToPay] isEqualToString:stateString]) {
        return SiteOrderState_ToPay;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToPack] isEqualToString:stateString]) {
        return SiteOrderState_ToPack;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToInport] isEqualToString:stateString]) {
        return SiteOrderState_ToInport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Inport] isEqualToString:stateString]) {
        return SiteOrderState_Inport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToOutport] isEqualToString:stateString]) {
        return SiteOrderState_ToOutport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Outport] isEqualToString:stateString]) {
        return SiteOrderState_Outport;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToArrived] isEqualToString:stateString]) {
        return SiteOrderState_ToArrived;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Arrived] isEqualToString:stateString]) {
        return SiteOrderState_Arrived;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Delivering] isEqualToString:stateString]) {
        return SiteOrderState_Delivering;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_ToSign] isEqualToString:stateString]) {
        return SiteOrderState_ToSign;
    } else if ([[self getSiteOrderStateStringWithState:SiteOrderState_Completed] isEqualToString:stateString]) {
        return SiteOrderState_Completed;
    } else
        return SiteOrderState_UnKnow;
}
/**
 获取文件Data
 
 @param asset PHAsset
 @param result 回调
 */
-(void)getMediaDataFromPHAsset:(PHAsset *)asset complete:(void(^)(NSData* data, NSString *fileName, NSString * mimeType))result {
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [self getImageFromPHAsset:asset complete:result];
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        [self getVideoFromPHAsset:asset complete:result];
    }
}

/**
 获取图片文件Data
 
 @param asset PHAsset
 @param result 回调
 */
-(void)getImageFromPHAsset:(PHAsset * )asset complete:(void(^)(NSData* data, NSString *fileName, NSString * mimeType))result {
    __block NSData * data;
    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES; [[PHImageManager defaultManager] requestImageDataForAsset: asset options: options resultHandler: ^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
            data = [NSData dataWithData: imageData];
        }];
    }
    if (result) {
        if (data.length <= 0) {
            result(nil, nil, @"image/png");
        } else {
            result(data, resource.originalFilename, @"image/png");
        }
    }
}
/**
获取视频文件Data

@param asset PHAsset
@param result 回调
*/
-(void)getVideoFromPHAsset:(PHAsset * )asset complete:(void(^)(NSData* data, NSString *fileName, NSString * mimeType))result {
    NSArray * assetResources = [PHAssetResource assetResourcesForAsset: asset];
    PHAssetResource * resource;
    for (PHAssetResource * assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo || assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString * fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions * options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        NSString * PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
        [[NSFileManager defaultManager] removeItemAtPath: PATH_MOVIE_FILE error: nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource: resource toFile: [NSURL fileURLWithPath: PATH_MOVIE_FILE] options: nil completionHandler: ^(NSError * _Nullable error) {
            if (error) {
                result(nil, nil, @"mov");
            } else {
                NSData * data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath: PATH_MOVIE_FILE]];
                result(data, fileName, @"mov");
            }
            [[NSFileManager defaultManager] removeItemAtPath: PATH_MOVIE_FILE error: nil];
        }];
    } else {
        result(nil, nil, @"mov");
    }
}
/**
 获取 mediaShowItemModel
 
 @param uploadFileResultList 上传文件结果列表
 @return MediaShowItemModel列表
 */
-(NSArray<MediaShowItemModel *> *)getMediaShowItemModelListFromUploadFileResultList:(NSArray<UploadMediaResult *>*)uploadFileResultList{
    NSMutableArray * array = [NSMutableArray array];
    for (UploadMediaResult * result in uploadFileResultList) {
        MediaShowItemModel * model = [[MediaShowItemModel alloc]init];
        model.mediaType = result.mediaType;
        model.resourcePath = result.fileAddress;
        [array addObject:model];
    }
    return [NSArray arrayWithArray:array];
}
@end
