//
//  ImageBoxTestCell.h
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndVideoSelectBox.h"
#import "MediaSelectBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@class ImageBoxTestCell;

@protocol ImageBoxTestCellDelegate <NSObject>

@optional
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell changeData:(NSArray *)dataSource;
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell changeHeight:(CGFloat)height;
@end

@protocol ImageBoxTestCellConfig <NSObject>

-(NSInteger)numberOfMediaColumn;
-(CGFloat)heightOfMediaItem;

@end


@interface ImageBoxTestCell : UITableViewCell
@property (nonatomic, weak) id<ImageBoxTestCellDelegate> delegate;
@property (nonatomic, weak) id<ImageBoxTestCellConfig> config;
@property (nonatomic, assign, readonly) CGFloat mediaItemHeight;
@end

NS_ASSUME_NONNULL_END
