//
//  SegmentedSelectView.h
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SegmentedItemStyle) {
    SegmentedItemStyle_Border = 0,
    SegmentedItemStyle_Border_2,
    SegmentedItemStyle_Full,
    SegmentedItemStyle_Full_2,
    SegmentedItemStyle_Bottom,
};

@interface SegmentedSelectItemModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * iconfontName;
@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, assign) BOOL itemIsSelected;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, assign) SegmentedItemStyle style;
@end

@interface SegmentedSelectItem : UIView
@property (nonatomic, strong) SegmentedSelectItemModel * model;
-(void)selectItem:(BOOL)selectItem;
@end

@class SegmentedSelectView;
@protocol SegmentedSelectViewDelegate <NSObject>
-(void)segmentedSelectView:(SegmentedSelectView *)view selectIndex:(NSInteger)index;
@end

@interface SegmentedSelectView : UIView
@property (nonatomic, strong) NSArray<SegmentedSelectItemModel *>* modelArray;
@property (nonatomic, weak) id<SegmentedSelectViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
