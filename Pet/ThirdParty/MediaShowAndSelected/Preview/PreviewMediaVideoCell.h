//
//  PreviewMediaVideoCell.h
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaShowItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewMediaVideoCell : UICollectionViewCell
@property (nonatomic, strong) MediaShowItemModel * model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
- (void)pausePlayerAndShowNaviBar;
@end

NS_ASSUME_NONNULL_END
