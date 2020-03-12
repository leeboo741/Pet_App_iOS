//
//  HomeView.h
//  Pet
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeActionProtocol <NSObject>

-(NSString *)iconName;
-(NSString *)actionTitle;

@end

@protocol HomeViewDelegate <NSObject>

-(void)homeViewSelectBannerAtIndex:(NSInteger)index;
-(void)homeViewSelectActionAtIndex:(NSInteger)index;
-(void)homeViewConfirmSearhWithText:(NSString *)searchWord;

@end

@interface HomeView : UIView
@property (nonatomic, strong) NSArray<NSString *> *imagePathArray;
@property (nonatomic, strong) NSArray<id<HomeActionProtocol>> *actionArray;
@property (nonatomic, weak)id<HomeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
