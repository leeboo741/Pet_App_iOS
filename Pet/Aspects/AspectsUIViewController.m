//
//  AspectsUIViewController.m
//  Pet
//
//  Created by mac on 2019/12/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "AspectsUIViewController.h"
#import <Aspects/Aspects.h>

@implementation AspectsUIViewController

+(void)aspect_viewDidLoad{
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        UIViewController * viewController = (UIViewController *)info.instance;
        MSLog(@"%@",NSStringFromClass([viewController class]));
    } error:nil];
}

@end
