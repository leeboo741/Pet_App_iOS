//
//  UITabBarController+ChangeViewControllers.m
//  TestTabbar
//
//  Created by lee on 2019/12/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "UITabBarController+ChangeViewControllers.h"


@implementation UITabBarController (ChangeViewControllers)
-(void)replaceViewControllerAtIndex:(NSInteger)index withViewController:(UIViewController *)viewController{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: [self viewControllers]];
    if ([self unableOperateWithVCs:viewControllers andIndex:index]) {
        return;
    }
    [viewControllers replaceObjectAtIndex:index withObject:viewController];
    [self setViewControllers:viewControllers ];
}
-(void)removeViewControllerAtIndex:(NSInteger)index{
    NSMutableArray *viewControllers = [self getMutableViewControllers];
    if ([self unableOperateWithVCs:viewControllers andIndex:index]) {
        return;
    }
    [viewControllers removeObjectAtIndex:index];
    [self setViewControllers:viewControllers];
}
-(void)addNewViewController:(UIViewController *)viewController{
    NSMutableArray *viewControllers = [self getMutableViewControllers];
    [viewControllers addObject:viewController];
    [self setViewControllers:viewControllers];
}
-(void)insertViewControllerAtIndex:(NSInteger)index withViewController:(UIViewController *)viewController{
    NSMutableArray *viewControllers = [self getMutableViewControllers];
    if ([self unableOperateWithVCs:viewControllers andIndex:index]) {
        return;
    }
    [viewControllers insertObject:viewController atIndex:index];
    [self setViewControllers:viewControllers];
}
-(BOOL)unableOperateWithVCs:(NSArray *)viewControllers andIndex:(NSInteger)index{
    if (viewControllers == nil || viewControllers.count < (index+1)) {
        return YES;
    }
    return NO;
}
-(NSMutableArray *)getMutableViewControllers{
    return [NSMutableArray arrayWithArray:[self viewControllers]];
}
@end
