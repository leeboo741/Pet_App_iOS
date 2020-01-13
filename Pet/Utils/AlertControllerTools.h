//
//  AlertControllerTools.h
//  Pet
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 alertAction 点击回调
 
 @param controller 页面
 @param action 点击的action
 @param actionIndex 点击的action下标 当为-1时 为取消按钮
 */
typedef void(^AlertActionTapBlock)(UIAlertController * controller, UIAlertAction * action, NSInteger actionIndex);

@interface AlertControllerTools : NSObject
/**
 展示 actionSheet
 
 @param title 标题
 @param msg 信息
 @param items item标题集合
 @param showCancel 是否展示取消按钮
 @param tapBlock 点击item 回调
 */
+(void)showActionSheetWithTitle:(NSString * _Nullable)title msg:( NSString * _Nullable )msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock;

/**
 展示 alert
 
 @param title 标题
 @param msg 信息
 @param items item标题集合
 @param showCancel 是否展示取消按钮
 @param tapBlock 点击item 回调
 */
+(void)showAlertWithTitle:(NSString * _Nullable)title msg:(NSString * _Nullable)msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock ;

/**
 展示 带textfield 的alert
 
 @param placeholders textField 的placeholder 列表
 @param title 标题
 @param msg 信息
 @param items item标题集合
 @param showCancel 是否展示取消按钮
 @param tapBlock 点击item 回调
 */
+(void)showAlertWithTextFieldPlaceholders:(NSArray<NSString *>*)placeholders title:(NSString * _Nullable)title msg:(NSString * _Nullable)msg items:(NSArray<NSString *> *)items showCancel:(BOOL)showCancel actionTapBlock:(AlertActionTapBlock)tapBlock;
@end

NS_ASSUME_NONNULL_END
