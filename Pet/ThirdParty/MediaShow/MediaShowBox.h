//
//  MediaShowBox.h
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaShowItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@class MediaShowBox;

@protocol MediaShowBoxDelegate <NSObject>
@optional
-(void)mediaShowBox:(MediaShowBox *)showBox didSelectItemAtIndex:(NSInteger)index;
@end

@protocol MediaShowBoxDataSource <NSObject>
@optional
-(NSInteger)itemColumnCountForMediaShowBox:(MediaShowBox *)showBox;
-(CGFloat)itemHeightForMediaShowBox:(MediaShowBox *)showBox;
@end

@interface MediaShowBox : UIView
@property (nonatomic, strong) NSArray<MediaShowItemModel *> * data;
@property (nonatomic, weak)id<MediaShowBoxDelegate>delegate;
@property (nonatomic, weak)id<MediaShowBoxDataSource>dataSource;
@end

NS_ASSUME_NONNULL_END
