//
//  MediaSelectItemModel.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaSelectItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediaSelectItemModel : NSObject <MediaSelectItemProtocol>
@property (nonatomic, assign) MediaSelectItemType type;
@property (nonatomic, strong) UIImage * coverImage;
@property (nonatomic, copy) NSString * coverImagePath;
@property (nonatomic, strong) id data;
@end

NS_ASSUME_NONNULL_END
