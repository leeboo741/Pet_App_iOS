//
//  PaymentTypeCell.h
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Payment_Type_Code ) {
    Payment_Type_Code_Wechat,
};

@interface PaymentTypeModel : NSObject
@property (nonatomic, copy) NSString * typeName; // 类型名称
@property (nonatomic, copy) NSString * typeInfo; // 类型信息
@property (nonatomic, copy) NSString * typeIconName; // 类型logo
@property (nonatomic, assign) Payment_Type_Code typeCode; // 类型代码
@property (nonatomic, assign) BOOL isRecommend; // 是否推荐
@property (nonatomic, assign) BOOL isSelected; // 是否选中
@end

@interface PaymentTypeCell : UITableViewCell
@property (nonatomic, strong) PaymentTypeModel * model;
@end

NS_ASSUME_NONNULL_END
