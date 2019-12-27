//
//  MediaSelectItemProtocol.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MediaSelectItemType) {
    MediaSelectItemType_IMG = 0,
    MediaSelectItemType_VIDEO,
    MediaSelectItemType_ADD,
    MediaSelectItemType_UNKOWN
};
@protocol MediaSelectItemProtocol <NSObject>
-(MediaSelectItemType)type; // 类型
-(UIImage *)coverImage; // 封面图片
-(NSString *)coverImagePath; // 封面图片路径
-(id)data; // 附带数据
@end

NS_ASSUME_NONNULL_END
