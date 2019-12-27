//
//  MediaSelectItemView.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSelectItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class MediaSelectItemView;
@protocol MediaSelectItemDelegate <NSObject>
@optional
-(void)tapMediaSelectItem:(MediaSelectItemView *)item;
-(void)deleteMediaSelectItem:(MediaSelectItemView *)item;
@end

@interface MediaSelectItemView : UIView
@property (nonatomic, strong) id<MediaSelectItemProtocol> model;
@property (nonatomic, assign) BOOL ableDelete;
@property (nonatomic, weak) id<MediaSelectItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
