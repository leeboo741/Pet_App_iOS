//
//  UITabBarController+ChangeViewControllers.h
//  TestTabbar
//
//  Created by lee on 2019/12/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (ChangeViewControllers)
/**
 *  将指定位置的子vc 替换成目标vc
 *  @param index 指定位置
 *  @param viewController 目标vc
 */
-(void)replaceViewControllerAtIndex:(NSInteger)index withViewController:(UIViewController *)viewController;
/**
 *  移除指定位置子vc
 *  @param index 指定位置
 */
-(void)removeViewControllerAtIndex:(NSInteger)index;
/**
 *  新增一个子vc
 *  @param viewController 要新增的子vc
 */
-(void)addNewViewController:(UIViewController *)viewController;
/**
 *  在指定位置插入一个子vc
 *  @param index 指定位置
 *  @param viewController 目标子vc
 */
-(void)insertViewControllerAtIndex:(NSInteger)index withViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
