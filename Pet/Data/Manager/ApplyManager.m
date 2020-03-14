//
//  ApplyManager.m
//  Pet
//
//  Created by mac on 2020/1/17.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyManager.h"

@implementation ApplyStaffModel
-(NSString *)staffName{
    return !_staffName?@"":_staffName;
}
-(NSString *)customerNo{
    return !_customerNo?@"":_customerNo;
}
-(NSString *)phone{
    return !_phone?@"":_phone;
}
-(NSString *)verificationCode{
    return !_verificationCode?@"":_verificationCode;
}
-(StationEntity *)station{
    return !_station?[[StationEntity alloc]init]:_station;
}
@end
@implementation ApplyStationModel
@end

@interface ApplyManager ()

@end

@implementation ApplyManager
SingleImplementation(ApplyManager);

/**
 请求注册 员工
 
 @param applyStaffModel 员工申请
 @param success success
 @param fail fail
 */
-(void)requestStaffApply:(ApplyStaffModel *)applyStaffModel
                 success:(SuccessBlock)success
                    fail:(FailBlock)fail{
    NSDictionary *dict =[applyStaffModel mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStaff paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",applyStaffModel.jsessionId];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

/**
 申请成为商家
 
 @param applyStationModel 商家申请
 @param success success
 @param fail fail
 */
-(void)requestStationApply:(ApplyStationModel *)applyStationModel
                   success:(SuccessBlock)success
                      fail:(FailBlock)fail{
    NSDictionary * dict = [applyStationModel mj_JSONObject];
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_POST Url:URL_ApplyStation paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            success(data);
        }
    } failBlock:^(NSInteger code, NSString * _Nonnull errorMsg) {
        if (fail) {
            fail(code);
        }
    }];
    NSString * sessionStr = [NSString stringWithFormat:@"JSESSIONID=%@",applyStationModel.jsessionId];
    [model.header setObject:sessionStr forKey:HEADER_KEY_COOKIES];
    [[HttpManager shareHttpManager] requestWithRequestModel:model];
}

#pragma mark - 审批
/**
 获取待审批的员工列表
 
 @param customerNo  用户编号
 @param success success
 @param fail fail
 */
-(void)getUnauditedStaffListByCustomerNo:(NSString *)customerNo
                                 success:(SuccessBlock)success
                                    fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"phone":customerNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Apply_Staff_UnauditedList paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<ApplyStaffModel *> *array = [ApplyStaffModel mj_objectArrayWithKeyValuesArray:data];
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
 获取待审批的商家列表
 
 @param customerNo  用户编号
 @param success success
 @param fail fail
 */
-(void)getUnauditedBusinessListByCustomerNo:(NSString *)customerNo
                                    success:(SuccessBlock)success
                                       fail:(FailBlock)fail{
    NSDictionary * dict = @{
        @"customerNo":customerNo
    };
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_GET Url:URL_Apply_Business_UnauditedList paramers:dict successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        NSArray<ApplyStationModel *> *array = [ApplyStationModel mj_objectArrayWithKeyValuesArray:data];
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
 拒绝员工审核
 
 @param staff 员工对象
 @param success success
 @param fail fail
 */
-(void)rejectStaff:(ApplyStaffModel *)staff
           success:(SuccessBlock)success
              fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Apply_Staff_Reject paramers:[staff mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 通过员工申请
 
 @param staff 员工对象
 @param success success
 @param fail fail
 */
-(void)approveStaff:(ApplyStaffModel *)staff
            success:(SuccessBlock)success
               fail:(FailBlock)fail{
    HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Apply_Staff_Apply paramers:[staff mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 拒绝商家申请
 
 @param business 商家对象
 @param success success
 @param fail fail
 */
-(void)rejectBusiness:(ApplyStationModel *)business
              success:(SuccessBlock)success
                 fail:(FailBlock)fail{
     HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Apply_Business_Reject paramers:[business mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
 通过商家申请
 
 @param business 商家对象
 @param success success
 @param fail fail
 */
-(void)approveBusiness:(ApplyStationModel *)business
               success:(SuccessBlock)success
                  fail:(FailBlock)fail{
      HttpRequestModel * model = [[HttpRequestModel alloc]initWithType:HttpRequestMethodType_PUT Url:URL_Apply_Business_Apply paramers:[business mj_JSONObject] successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
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
@end
