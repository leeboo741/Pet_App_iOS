//
//  Utils.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(BOOL)isPhoneString:(NSString *)string;{
    NSString *phoneRegex1=@"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return [phoneTest1 evaluateWithObject:string];
}
+(BOOL)isNumberString:(NSString *)string {
    if (string.length == 0)
        return NO;
    NSString *regex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}
+(BOOL)isEmptyString:(NSString *)string{
    return string == nil || string.length <= 0;
}
+(BOOL)isEmptyArray:(NSArray *)array{
    return array == nil || array.count <= 0;
}
+(BOOL)isEmptyDict:(NSDictionary *)dict{
    return dict == nil || dict.allKeys.count <= 0;
}
+(UIViewController *)getCurrentViewController{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}
@end
