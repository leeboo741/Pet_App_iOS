//
//  InOrOutPortFilterController.h
//  Pet
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteOrderManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InOrOutPortFilter_Type) {
    InOrOutPortFilter_Type_Out,
    InOrOutPortFilter_Type_In,
    InOrOutPortFilter_Type_All,
};

typedef void(^InOrOutPortFilterRetrunBlock)(InOrOutPortRequestParam *param);

@interface InOrOutPortFilterController : UITableViewController
@property (nonatomic, strong) InOrOutPortRequestParam * param;
@property (nonatomic, assign) InOrOutPortFilter_Type filterType;
@property (nonatomic, copy) InOrOutPortFilterRetrunBlock returnBlock;
@end

NS_ASSUME_NONNULL_END
