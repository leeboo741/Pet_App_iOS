//
//  TimeCountButton.h
//  Pet
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TimeCountState) {
    TimeCountState_Counting = 0,
    TimeCountState_StopCounting = 1,
};

@class TimeCountButton;
@protocol TimeCountButtonDelegate <NSObject>
@optional
-(void)tapTimeCountButton:(TimeCountButton *)timeCountButton;
-(void)startCountWithTimeCountButton:(TimeCountButton *)timeCountButton;
-(void)stopCountWithTimeCountButton:(TimeCountButton *)timeCountButton;
@end

@interface TimeCountButton : UIView
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, weak) id<TimeCountButtonDelegate> delegate;
@property (nonatomic, assign) TimeCountState state;
/**
 开始计时
 */
-(void)startCount;

/**
 结束计时
 */
-(void)stopCount;
@end

NS_ASSUME_NONNULL_END
