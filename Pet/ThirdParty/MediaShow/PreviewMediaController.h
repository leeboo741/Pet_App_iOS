//
//  PreviewMediaController.h
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaShowItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewMediaController : UIViewController
@property (nonatomic, strong) NSArray<MediaShowItemModel *> * dataSource;
@property (nonatomic, assign) NSInteger currentIndex;
@end

NS_ASSUME_NONNULL_END
