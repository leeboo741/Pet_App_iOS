//
//  OrderRemarkView.h
//  Pet
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderRemarkView : UIView
@property (nonatomic, strong) IBOutlet UIView * view;
@property (nonatomic, copy) NSString * customerRemark; // 客户备注
@property (nonatomic, copy) NSString * lastFollowUpTime; // 最后跟进时间
@property (nonatomic, copy) NSString * lastFollowUpContent; // 最后跟进内容
@end

NS_ASSUME_NONNULL_END
