//
//  PreviewViewController.h
//  Pet
//
//  Created by mac on 2019/12/28.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *photos;                  ///< All photos  / 所有图片数组
@property (nonatomic, assign) NSInteger currentIndex;    
@end

NS_ASSUME_NONNULL_END
