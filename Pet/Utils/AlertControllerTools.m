//
//  AlertControllerTools.m
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "AlertControllerTools.h"

@implementation AlertControllerTools
+(void)showActionSheetWithTitle:(NSString * _Nullable)title msg:( NSString * _Nullable )msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger index = 0; index < items.count; index ++) {
        NSString * item = items[index];
        UIAlertAction * itemAction = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, index);
            }
        }];
        [alertController addAction:itemAction];
    }
    if (showCancel) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, -1);
            }
        }];
        [alertController addAction:cancelAction];
    }
    UIViewController * currentVC = Util_GetCurrentVC;
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString * _Nullable)title msg:(NSString * _Nullable)msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    for (NSInteger index = 0; index < items.count; index++) {
        NSString * item = items[index];
        UIAlertAction * itemAction = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, index);
            }
        }];
        [alertController addAction:itemAction];
    }
    if (showCancel) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, -1);
            }
        }];
        [alertController addAction:cancelAction];
    }
    UIViewController * currentVC = Util_GetCurrentVC;
    [currentVC presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlertWithTextFieldPlaceholders:(NSArray<NSString *>*)placeholders title:(NSString * _Nullable)title msg:(NSString * _Nullable)msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    for (NSString * placeholder in placeholders) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
        }];
    }
    for (NSInteger index = 0; index < items.count; index++) {
        NSString * item = items[index];
        UIAlertAction * itemAction = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, index);
            }
        }];
        [alertController addAction:itemAction];
    }
    if (showCancel) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (tapBlock) {
                tapBlock(alertController, action, -1);
            }
        }];
        [alertController addAction:cancelAction];
    }
    UIViewController * currentVC = Util_GetCurrentVC;
    [currentVC presentViewController:alertController animated:YES completion:nil];
}
@end
