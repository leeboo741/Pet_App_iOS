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
-(void)mediaSelectBox:(MediaSelectBoxView *)box didChangeDataSource:(NSArray<MediaSelectItemModel *> *)dataSource;
-(void)mediaSelectBox:(MediaSelectBoxView *)box didChangeHeight:(CGFloat)height;
@end

@protocol MediaSelectBoxViewConfig <NSObject>
-(NSInteger)numberOfMediaSelectBoxColumn;
-(CGFloat)heightOfMediaSelectBoxItem;
@end

@interface MediaSelectBoxView : UIView
@property (nonatomic, strong) NSMutableArray<MediaSelectItemModel *> * dataSource;
@property (nonatomic, weak) id<MediaSelectBoxViewDelegate> delegate;
@property (nonatomic, weak) id<MediaSelectBoxViewConfig>config;

-(void)reloadItems;
@end

NS_ASSUME_NONNULL_END
