//
//  PrivacyPolicyView.h
//  EasyCRM
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PrivacyPolicyButtonType) {
    PrivacyPolicyButtonType_Disagree = 0,
    PrivacyPolicyButtonType_Agree,
    PrivacyPolicyButtonType_Cancel,
};

@protocol PrivacyPolicyViewDelegate <NSObject>

-(void)privacyPolicyViewTapButtonAction:(PrivacyPolicyButtonType) buttonType;

@end


@interface PrivacyPolicyView : UIView
@property (nonatomic, strong) IBOutlet UIView * view;
@property (nonatomic, weak)id<PrivacyPolicyViewDelegate>delegate;
+(void)popPrivacyPolicyView;
-(void)addPopViewToWindow;
@end

