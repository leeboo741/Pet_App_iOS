//
//  ApplyCenterView.h
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ApplyType) {
    ApplyType_Station = 0,
    ApplyType_Staff,
};

@class ApplyCenterView;
@protocol ApplyCenterViewDelegate <NSObject>

-(void)tapApplyCenterView:(ApplyCenterView*)view withType:(ApplyType)type;

@end

@interface ApplyCenterView : UIView
@property (nonatomic, weak) id<ApplyCenterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
