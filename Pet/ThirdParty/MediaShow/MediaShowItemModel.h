//
//  MediaShowItemModel.h
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MediaType) {
    MediaType_Video = 0,
    MediaType_Image,
    MediaType_Unknow,
};

@interface MediaShowItemModel : NSObject
@property (nonatomic, copy) NSString * coverImagePath; // 封面图片路径
@property (nonatomic, copy) NSString * resourcePath; // 资源路径
@property (nonatomic, assign) MediaType mediaType; // 文件类型
@end

NS_ASSUME_NONNULL_END
