//
//  Utils.m
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "LeeUtils.h"

@implementation LeeUtils
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
+(void)makePhoneCallWithPhoneNumber:(NSString *)phoneNumber{
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    NSString * phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

/**
 替换特殊字符
 
 @param sourceString 需要替换的字符
 */
+(NSString *)replaceSepcialChar:(NSString *)sourceString{
    NSString * string = [sourceString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]];
    return string;
}

/**
 恢复特殊字符
 
 @param sourceString 需要恢复特殊字符
 */
+(NSString *)recoverySpecialChar:(NSString *)sourceString{
    NSString * string = [sourceString stringByRemovingPercentEncoding];
    return string;
}
/**
 获取地址中的参数字典
 
 @param url 地址
 */
+(NSDictionary *)getUrlParamDict:(NSString *)url{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSArray * array = [url componentsSeparatedByString:@"?"];
    if (!Util_IsEmptyArray(array) && array.count == 2) {
        NSString * string = array[1];
        NSArray * subArray = [string componentsSeparatedByString:@"&"];
        for (NSString * subString in subArray) {
            NSArray * paramArray = [subString componentsSeparatedByString:@"="];
            [dict setObject:paramArray[1] forKey:paramArray[0]];
        }
    }
    return dict;
}
@end
