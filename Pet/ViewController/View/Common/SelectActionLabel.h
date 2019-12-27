//
//  selectActionLabel.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SelectActionLabel;
@protocol SelectActionLabelDelegate <NSObject>

-(void)selectActionLabelClickAction:(SelectActionLabel *)selectActionLabel;

@end

@interface SelectActionLabel : UILabel
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, copy) NSString * normalStr;
@property (nonatomic, strong) UIColor * placeholderColor;
@property (nonatomic, copy) NSString * placeholderStr;
@property (nonatomic, weak)id<SelectActionLabelDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
