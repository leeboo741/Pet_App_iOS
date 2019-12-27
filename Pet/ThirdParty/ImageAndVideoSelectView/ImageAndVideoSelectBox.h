//
//  ImageAndVideoSelectBox.h
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndVideoSelectItemCell.h"
#import "MediaSelectItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class ImageAndVideoSelectBox;
@protocol ImageAndVideoSelectBoxDelegate <NSObject>
@optional
-(void)imageAndVideoSelectBox:(ImageAndVideoSelectBox *)box deleteData:(id<MediaSelectItemProtocol>)data atIndex:(NSInteger)index;
-(void)imageAndVideoSelectBox:(ImageAndVideoSelectBox *)box reloadDataSource:(NSArray*)dataSource;

@end

@interface ImageAndVideoSelectBox : UIView
@property (nonatomic, strong) IBOutlet UIView * view;
@property (nonatomic, strong) NSMutableArray<id<MediaSelectItemProtocol>> * dataSource;
@property (nonatomic, weak) id<ImageAndVideoSelectBoxDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
