//
//  StarSelectView.h
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class StarSelectView;
@protocol StarSelectViewDelegate <NSObject>

-(void)tapStarAtStarSelectView:(StarSelectView *)view withLevel:(NSInteger)level;

@end

@interface StarSelectView : UIView
@property (nonatomic, weak) IBOutlet UIView * view;
@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, weak) id<StarSelectViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
