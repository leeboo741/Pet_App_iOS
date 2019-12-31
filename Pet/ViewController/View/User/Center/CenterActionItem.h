//
//  CenterActionItem.h
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CenterActionItemModel : NSObject
@property (nonatomic, copy) NSString * actionName;
@property (nonatomic, copy) NSString * actionIconName;
@end

@interface CenterActionItem : UIView
@property (nonatomic, strong) CenterActionItemModel * model;
@end

NS_ASSUME_NONNULL_END
