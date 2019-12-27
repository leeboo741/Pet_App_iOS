//
//  MediaSelectBoxView.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSelectItemProtocol.h"
#import "MediaSelectItemView.h"

NS_ASSUME_NONNULL_BEGIN
@class MediaSelectBoxView;
@protocol MediaSelectBoxViewDelegate <NSObject>
@optional
-(void)mediaSelectBox:(MediaSelectBoxView *)box deleteData:(id<MediaSelectItemProtocol>)data atIndex:(NSInteger)index;
-(void)mediaSelectBox:(MediaSelectBoxView *)box reloadDataSource:(NSArray*)dataSource;
-(void)mediaSelectBox:(MediaSelectBoxView *)box changeHeight:(CGFloat)height;
@end

@interface MediaSelectBoxView : UIView
@property (nonatomic, strong) NSMutableArray<id<MediaSelectItemProtocol>> * dataSource;
@property (nonatomic, weak) id<MediaSelectBoxViewDelegate> delegate;

-(void)reloadItems;
@end

NS_ASSUME_NONNULL_END
