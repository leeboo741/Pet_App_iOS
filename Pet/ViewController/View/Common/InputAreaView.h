//
//  InputAreaView.h
//  Pet
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InputAreaView;

@protocol InputAreaViewDelegate <NSObject>

-(void)inputAreaViewInputAction:(NSString *)text atInputArea:(InputAreaView *)inputAreaView;

@end

@interface InputAreaView : UIView
@property (nonatomic, copy) NSString * iconImageName;
@property (nonatomic, copy) NSString * placeholder;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, weak) id<InputAreaViewDelegate> delegate;
@property (nonatomic, assign) BOOL hideIcon;
@property (nonatomic, assign) NSTextAlignment inputAlignment;
@property (nonatomic, assign) UIKeyboardType inputKeyboardType;
@end

NS_ASSUME_NONNULL_END
