//
//  OrderManager.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderManager.h"
#import "TransportOrder.h"

@implementation PredictPriceModel
@end
@implementation CityModel
@end
@implementation InsureRateModel
@end

@interface OrderManager ()
@property (nonatomic, strong) NSArray * petTypes;

@property (nonatomic, strong) NSArray * startCitys;
@property (nonatomic, strong) NSArray * startCityIndexs;
@property (nonatomic, strong) NSMutableDictionary * endCityDict;
@property (nonatomic, strong) NSMutableDictionary * endCityIndexDict;

@property (nonatomic, strong) NSMutableDictionary * startCityServicePhoneDict;

@property (nonatomic, strong) NSMutableDictionary * startCityInsureRateDict;

@property (nonatomic, strong) NSMutableDictionary * ableTransportTypeDict;

@property (nonatomic, strong) NSMutableDictionary * petWeightDict;
@end

@implementation OrderManager
SingleImplementation(OrderManager);

#pragma mark - public method

-(void)getPredictPriceWithModel:(TransportOrder *)order
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail {
    NSDictionary * param = [self getDictFromOrder:order];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_PredictPrice paramers:param successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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

-(void)getMaxPetCageWeightWithStartCity:(NSString *)startCity
                                endCity:(NSString *)endCity
                          transportType:(OrderTransportType)type
                                success:(SuccessBlock)success
                                   fail:(FailBlock)fail{
    NSString * dictKey = [NSString stringWithFormat:@"%@-%@-%ld",startCity,endCity,type];
    NSNumber * maxPetWeight = [self.petWeightDict objectForKey:dictKey];
    if (!maxPetWeight) {
        __weak typeof(self) weakSelf = self;
        NSDictionary * paramers = @{
                                    @"startCity":startCity,
                                    @"endCity":endCity,
                                    @"transportType":@(type)
                                    };
        HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_AblePetCageMax paramers:paramers successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            [weakSelf.petWeightDict setObject:data forKey:dictKey];
            if (success) {
                success(data);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            if (fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    } else {
        if (success) {
            success(maxPetWeight);
        }
    }
}

-(void)getAbleTransportTypeWithStartCity:(NSString *)startCity
                                 endCity:(NSString *)endCity
                                 success:(SuccessBlock)success
                                    fail:(FailBlock)fail{
    NSString * dictKey = [NSString stringWithFormat:@"%@-%@",startCity,endCity];
    NSArray * ableResults = [self.ableTransportTypeDict objectForKey:dictKey];
    if (kArrayIsEmpty(ableResults)) {
        __weak typeof(self) weakSelf = self;
        NSDictionary * paramers = @{
                                    @"startCity": startCity,
                                    @"endCity": endCity
                                    };
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_AbleTransportType paramers:paramers successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            NSArray * result = data;
            [weakSelf.ableTransportTypeDict setObject:result forKey:dictKey];
            if (success) {
                success(result);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            if(fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    } else {
        if (success) {
            success(ableResults);
        }
    }
}

-(void)getInsureRateByStartCity:(NSString *)startCity
                        success:(SuccessBlock)success
                           fail:(FailBlock)fail{
    InsureRateModel * insureRate = [self.startCityInsureRateDict objectForKey:startCity];
    if (!insureRate) {
        __weak typeof(self) weakSelf = self;
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_InsureRateByCityName paramers:@{@"startCity":startCity} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            InsureRateModel * insureRateData = [InsureRateModel mj_objectWithKeyValues:data];
            [weakSelf.startCityInsureRateDict setObject:insureRateData forKey:startCity];
            if (success) {
                success(insureRateData);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            if(fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    } else {
        if (success) {
            success(insureRate);
        }
    }
}

-(void)getServicePhoneByStartCity:(NSString *)startCity
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail{
    NSString * servicePhone = [self.startCityServicePhoneDict objectForKey:startCity];
    if (kStringIsEmpty(servicePhone)) {
        __weak typeof(self) weakSelf = self;
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_StorePhoneByCityName paramers:@{@"cityName": startCity} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            [weakSelf.startCityServicePhoneDict setObject:data forKey:startCity];
            if (success) {
                success(data);
            }
        } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
            if(fail) {
                fail(code);
            }
        }];
        [[HttpManager shareHttpManager] requestWithRequestModel:model];
    } else {
        if (success) {
            success(servicePhone);
        }
    }
}

-(void)getStartCityWithKeyword:(NSString *)keyword
                       success:(GetCityDataReturnBlock)success
                          fail:(FailBlock)fail{
    if (kStringIsEmpty(keyword)) {
        if (!kArrayIsEmpty(self.startCitys)) {
            if (success) {
                success(self.startCitys, self.startCityIndexs);
            }
        } else {
            __weak typeof(self) weakSelf = self;
            HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_StartCity paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
                NSDictionary * dataDict = (NSDictionary *)data;
                NSArray * cityData = (NSArray *)[dataDict objectForKey:@"bodys"];
                [weakSelf handlerCityDataWithData:cityData
                       getCityDataReturnBlock:^(NSArray * _Nullable dataList, NSArray * _Nullable indexList) {
                    weakSelf.startCitys = dataList;
                    weakSelf.startCityIndexs = indexList;
                    if (success) {
                        success(dataList, indexList);
                    }
                }];
            } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
                if (fail) {
                    fail(code);
                }
            }];
            [[HttpManager shareHttpManager] requestWithRequestModel:model];
        }
    } else {
        [self getStartSearchDataWithKeyWord:keyword
                         getDataReturnBlock:success];
    }
}

-(void)getEndCityWithStartCity:(NSString *)startCity
                       keyword:(NSString *)keyword
                       success:(GetCityDataReturnBlock)success
                          fail:(FailBlock)fail{
    if (kStringIsEmpty(keyword)) {
        if ([self.endCityDict objectForKey:startCity]) {
            if (success) {
                success([self.endCityDict objectForKey:startCity], [self.endCityIndexDict objectForKey:startCity]);
            }
        } else {
            __weak typeof(self) weakSelf = self;
            HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_EndCity paramers:@{@"startCity":startCity} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
                NSDictionary * dataDict = (NSDictionary *)data;
                NSArray * cityData = (NSArray *)[dataDict objectForKey:@"bodys"];
                [weakSelf handlerCityDataWithData:cityData
                       getCityDataReturnBlock:^(NSArray * _Nullable dataList, NSArray * _Nullable indexList) {
                    [weakSelf.endCityDict setObject:dataList forKey:startCity];
                    [weakSelf.endCityIndexDict setObject:indexList forKey:startCity];
                    if (success) {
                        success(dataList, indexList);
                    }
                }];
            } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
                if (fail) {
                    fail(code);
                }
            }];
            [[HttpManager shareHttpManager] requestWithRequestModel:model];
        }
    } else {
        [self getEndSearchDataWithKeyword:keyword
                                startCity:startCity
                       getDataReturnBlock:success];
    }
    
}

-(void)getPetTypeSuccess:(SuccessBlock)success
                    fail:(FailBlock)fail{
    if (self.petTypes) {
        if (success) {
            success(self.petTypes);
        }
    } else {
        __weak typeof(self) weakSelf = self;
        HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Pet_Type paramers:nil successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
            weakSelf.petTypes = (NSArray *)data;
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
}

/**
 生成订单
 
 @param transportOrder 订单
 @param success 成功回调
 @param fail 失败回调
 */
-(void)createOrderWithOrderEntity:(TransportOrder *)transportOrder
                          success:(SuccessBlock)success
                             fail:(FailBlock)fail{
    NSDictionary * dict = [self getDictFromOrder:transportOrder];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_InsertOrder paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 获取订单金额
 
 @param orderNo 订单编号
 @param success 成功回调
 @param fail 失败回调
 */
-(void)getOrderAmountWithOrderNo:(NSString *)orderNo
                         success:(SuccessBlock)success
                            fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc] initWithType:HttpRequestMethodType_GET Url:URL_GetOrderAmount paramers:@{@"orderNo":orderNo} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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

#pragma mark - private method

-(NSDictionary *)getDictFromOrder:(TransportOrder *)order{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSString * startCity = kStringIsEmpty(order.startCity)?@"":order.startCity;
    [dict setObject:startCity forKey:@"startCity"];
    NSString * endCity = kStringIsEmpty(order.endCity)?@"":order.endCity;
    [dict setObject:endCity forKey:@"endCity"];
    NSString * outTime = kStringIsEmpty(order.outTime)?@"":order.outTime;
    [dict setObject:outTime forKey:@"leaveDate"];
    NSString * petCount = kStringIsEmpty(order.petCount)?@"":order.petCount;
    [dict setObject:petCount forKey:@"num"];
    NSString * petType = kStringIsEmpty(order.petType)?@"":order.petType;
    [dict setObject:petType forKey:@"petType"];
    NSString * petBreed = kStringIsEmpty(order.petBreed)?@"":order.petBreed;
    [dict setObject:petBreed forKey:@"petClassify"];
    NSString * petWeight = kStringIsEmpty(order.petWeight)?@"":order.petWeight;
    [dict setObject:petWeight forKey:@"weight"];
    NSString * petTypeId = kStringIsEmpty(order.transportType.typeId)?@"":order.transportType.typeId;
    [dict setObject:petTypeId forKey:@"transportType"];
    [dict setObject:kIntNumber((int)order.buyPetCage) forKey:@"buyPetCage"];
    NSString * receiptAddress = kStringIsEmpty(order.receiptAddress)?@"":order.receiptAddress;
    [dict setObject:receiptAddress forKey:@"receiptAddress"];
    [dict setObject:kDoubleNumber(order.receiptLongitude) forKey:@"receiptLongitude"];
    [dict setObject:kDoubleNumber(order.receiptLatitude) forKey:@"receiptLatitude"];
    NSString * sendAddress = kStringIsEmpty(order.sendAddress)?@"": order.sendAddress;
    [dict setObject:sendAddress forKey:@"sendAddress"];
    [dict setObject:kDoubleNumber(order.sendLongitude) forKey:@"sendLongitude"];
    [dict setObject:kDoubleNumber(order.sendLatitude) forKey:@"sendLatitude"];
    [dict setObject:kDoubleNumber(order.petAmount) forKey:@"petAmount"];
    NSString * senderName = kStringIsEmpty(order.senderName)?@"":order.senderName;
    [dict setObject:senderName forKey:@"senderName"];
    NSString * senderPhone = kStringIsEmpty(order.senderPhone)?@"":order.senderPhone;
    [dict setObject:senderPhone forKey:@"senderPhone"];
    NSString * receiverName = kStringIsEmpty(order.receiverName)?@"":order.receiverName;
    [dict setObject:receiverName forKey:@"receiverName"];
    NSString * receiverPhone = kStringIsEmpty(order.receiverPhone)?@"":order.receiverPhone;
    [dict setObject:receiverPhone forKey:@"receiverPhone"];
    NSString * customerNo = kStringIsEmpty(order.customerNo)?@"":order.customerNo;
    [dict setObject:customerNo forKey:@"customerNo"];
    NSString * remark = kStringIsEmpty(order.remark)?@"":order.remark;
    [dict setObject:remark forKey:@"remarks"];
    [dict setObject:kIntNumber((int)order.giveFood) forKey:@"giveFood"];
    [dict setObject:kIntNumber((int)order.guarantee) forKey:@"guarantee"];
    NSString * petAge = kStringIsEmpty(order.petAge)?@"":order.petAge;
    [dict setObject:petAge forKey:@"petAge"];
    [dict setObject:@"" forKey:@"shareOpenId"];
    [dict setObject:@"" forKey:@"sendDistance"];
    return dict;
}

/**
 整理服务器返回数据
 
 @param data 服务器返回数据
 @param getDataReturnBlock 获取数据回调
 */
-(void)handlerCityDataWithData:(NSArray *)data
        getCityDataReturnBlock:(GetCityDataReturnBlock)getDataReturnBlock{
    // 解出城市数据
    NSArray * cityList = [CityModel mj_objectArrayWithKeyValuesArray:data];
    // 整理完成收城市数据容器
    NSMutableArray * cityBodyArray = [NSMutableArray array];
    NSMutableArray * cityIndexArray = [NSMutableArray array];
    // 无法归类的数据容器
    NSMutableArray * unknowCityList = [NSMutableArray array];
    // 遍历
    for (CityModel * model in cityList) {
        // 如果 城市对象 全拼 长度等于1  为首字母数据 创建子容器 并 在索引列表中添加数据
        // 如果 长度大于1 为城市数据 在容器中找到最后一条子容器 并添加数据
        // 如果 长度不大于1 未知数据 放入未知数据容器 遍历完成后 放入容器
        if (model.cityPinYin.length == 1) {
            [cityBodyArray addObject:[NSMutableArray array]];
            [cityIndexArray addObject:model.cityName];
        } else if (model.cityPinYin.length > 1) {
            NSMutableArray * array = cityBodyArray.lastObject;
            [array addObject:model];
        } else {
            [unknowCityList addObject:model];
        }
    }
    if (unknowCityList.count > 0) {
        [cityBodyArray addObject:unknowCityList];
        [cityIndexArray addObject:@"#"];
    }
    if (getDataReturnBlock) {
        getDataReturnBlock(cityBodyArray, cityIndexArray);
    }
}

/**
 搜索
 
 @param keyword 关键字
 @param dataSource 数据源
 */
-(void)getSearchResultWithKeyword:(NSString *)keyword
                       dataSource:(NSArray *)dataSource
                       indexArray:(NSArray *)indexArray
               getDataReturnBlock:(GetCityDataReturnBlock)returnBlock{
    if (kStringIsEmpty(keyword) || kArrayIsEmpty(dataSource)) {
        if (returnBlock) {
            returnBlock(dataSource, indexArray);
        }
    }
    NSMutableArray * searchArray = [NSMutableArray array];
    NSMutableArray * searchIndexArray = [NSMutableArray array];
    NSString * lowerKeyword = [keyword lowercaseString];
    
    for (NSInteger i = 0; i < indexArray.count; i++) {
        NSString * index = indexArray[i];
        NSArray * subArray  = dataSource[i];
        NSMutableArray * searchSubArray = [NSMutableArray array];
        for (CityModel * model in subArray) {
            // 城市名称 城市全拼 城市首拼 是否包含关键字
            // 包含则加入结果容器中
            if ([model.cityName containsString:keyword]
                || [model.cityPinYin containsString:lowerKeyword]
                || [model.cityPY containsString:lowerKeyword]) {
                [searchSubArray addObject:model];
                continue;
            }
        }
        if (!kArrayIsEmpty(searchSubArray)) {
            [searchArray addObject:searchSubArray];
            [searchIndexArray addObject:index];
        }
    }
    
    if (returnBlock) {
        returnBlock(searchArray, searchIndexArray);
    }
}

/**
 搜索起始城市
 
 @param keyword 关键字
 */
-(void)getStartSearchDataWithKeyWord:(NSString *)keyword
                  getDataReturnBlock:(GetCityDataReturnBlock)returnBlock{
    [self getSearchResultWithKeyword:keyword dataSource:self.startCitys indexArray:self.startCityIndexs getDataReturnBlock:returnBlock];
}

/**
 搜索目的城市
 
 @param keyword 关键字
 @param startCity 开始城市
 */
-(void)getEndSearchDataWithKeyword:(NSString *)keyword
                         startCity:(NSString *)startCity
                getDataReturnBlock:(GetCityDataReturnBlock)returnBlock{
    [self getSearchResultWithKeyword:keyword dataSource:[self.endCityDict objectForKey:startCity] indexArray:[self.endCityIndexDict objectForKey:startCity] getDataReturnBlock:returnBlock];
}

#pragma mark - setters and getters

-(NSMutableDictionary *)endCityDict{
    if (!_endCityDict) {
        _endCityDict = [NSMutableDictionary dictionary];
    }
    return _endCityDict;
}

-(NSMutableDictionary *)endCityIndexDict{
    if (!_endCityIndexDict) {
        _endCityIndexDict = [NSMutableDictionary dictionary];
    }
    return _endCityIndexDict;
}

-(NSMutableDictionary *)startCityServicePhoneDict{
    if (!_startCityServicePhoneDict) {
        _startCityServicePhoneDict = [NSMutableDictionary dictionary];
    }
    return _startCityServicePhoneDict;
}

-(NSMutableDictionary *)startCityInsureRateDict{
    if (!_startCityInsureRateDict) {
        _startCityInsureRateDict = [NSMutableDictionary dictionary];
    }
    return _startCityInsureRateDict;
}

-(NSMutableDictionary *)ableTransportTypeDict{
    if (!_ableTransportTypeDict) {
        _ableTransportTypeDict = [NSMutableDictionary dictionary];
    }
    return _ableTransportTypeDict;
}

-(NSMutableDictionary *)petWeightDict{
    if (!_petWeightDict) {
        _petWeightDict = [NSMutableDictionary dictionary];
    }
    return _petWeightDict;
}
@end
