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
    [viewControllers replaceObjectAtIndex:index withObject:viewController];
    [self setViewControllers:viewControllers ];
}
-(void)removeViewControllerAtIndex:(NSInteger)index{
    NSMutableArray *viewControllers = [self getMutableViewControllers];
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
    [viewControllers insertObject:viewController atIndex:index];
    [self setViewControllers:viewControllers];
}
-(NSMutableArray *)getMutableViewControllers{
    return [NSMutableArray arrayWithArray:[self viewControllers]];
}
@end
