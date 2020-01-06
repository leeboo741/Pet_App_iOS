//
//  MediaSelectBoxView.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSelectItemView.h"

NS_ASSUME_NONNULL_BEGIN
@class MediaSelectBoxView;
@protocol MediaSelectBoxViewDelegate <NSObject>
@optional
-(void)mediaSelectBoxView:(MediaSelectBoxView*)view dataSourceDidChanged:(NSArray<MediaSelectItemModel *> *)dataSource;
@end

@protocol MediaSelectBoxViewConfig <NSObject>
@optional
-(NSInteger)numberOfMediaSelectBoxColumn;
-(CGFloat)heightOfMediaSelectBoxItem;
@end

@interface MediaSelectBoxView : UIView
@property (nonatomic, strong) NSMutableArray<MediaSelectItemModel *> * dataSource;
@property (nonatomic, weak) id<MediaSelectBoxViewDelegate> delegate;
@property (nonatomic, weak) id<MediaSelectBoxViewConfig>config;
@property (nonatomic, assign) BOOL ableDelete;
@end

NS_ASSUME_NONNULL_END
