//
//  OrderStepItem.h
//  Pet
//
//  Created by lee on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, StepItemType) {
    StepItemType_Top = 0,
    StepItemType_Middle,
    StepItemType_Bottom,
};

@interface OrderStepItem : UIView
@property (nonatomic, weak) IBOutlet UIView * view;
@property (nonatomic, assign) StepItemType type;
@property (nonatomic, copy) NSString * stepTitle;
@property (nonatomic, copy) NSString * stepTime;
@property (nonatomic, strong) NSArray * mediaList;
@property (nonatomic, assign) NSInteger stepIndex;
@end

NS_ASSUME_NONNULL_END
