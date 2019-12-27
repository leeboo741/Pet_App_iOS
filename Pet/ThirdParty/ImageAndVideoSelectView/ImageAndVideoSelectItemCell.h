//
//  ImageAndVideoSelectItemCell.h
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSelectItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class ImageAndVideoSelectItemCell;
@protocol ImageAndVideoSelectItemCellDelegate <NSObject>

@optional
-(void)tapImageAndVideoSelectItemCell:(ImageAndVideoSelectItemCell *)cell;
-(void)deleteImageAndVideoSelectItemCell:(ImageAndVideoSelectItemCell *)cell;
@end

@interface ImageAndVideoSelectItemCell : UICollectionViewCell
@property (nonatomic, strong) id<MediaSelectItemProtocol> model;
@property (nonatomic, assign) BOOL ableDelete;
@property (nonatomic, weak) id<ImageAndVideoSelectItemCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
