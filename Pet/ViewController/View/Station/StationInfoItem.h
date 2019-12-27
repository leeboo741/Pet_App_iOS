//
//  StationInfoItem.h
//  Pet
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationInfoItem : UIView
@property (nonatomic, weak) IBOutlet UIView * view;
@property (nonatomic, copy) NSString* iconFontName;
@property (nonatomic, copy) NSString* titleName;
@property (nonatomic, copy) NSString* valueName;
@property (nonatomic, strong) NSNumber* iconSize;
@property (nonatomic, strong) NSNumber* titleSize;
@property (nonatomic, strong) NSNumber* valueSize;
@property (nonatomic, strong) UIColor* iconColor;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIColor* valueColor;
@end

NS_ASSUME_NONNULL_END
