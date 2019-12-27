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
-(void)imageBoxTestCellTapAdd:(ImageBoxTestCell *)cell;
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell tapImageAtIndex:(NSInteger)index data:(id<MediaSelectItemProtocol>)data;
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell deleteAtIndex:(NSInteger)index data:(id<MediaSelectItemProtocol>)data;
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell reloadData:(NSArray *)dataSource;
-(void)imageBoxTestCell:(ImageBoxTestCell *)cell chengeHeight:(CGFloat)height;
@end

@interface ImageBoxTestCell : UITableViewCell
@property (nonatomic, weak) id<ImageBoxTestCellDelegate> delegate;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
