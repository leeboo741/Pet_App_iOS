//
//  MediaSelectItemModel.h
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MediaSelectItemType) {
    MediaSelectItemType_IMG = 0,
    MediaSelectItemType_VIDEO,
    MediaSelectItemType_ADD,
    MediaSelectItemType_UNKOWN
};

@interface MediaSelectItemModel : NSObject
@property (nonatomic, assign) MediaSelectItemType type;
@property (nonatomic, strong) UIImage * coverImage;
@property (nonatomic, copy) NSString * coverImagePath;
@property (nonatomic, strong) PHAsset * data;

@property (nonatomic, assign) BOOL isUploaded; // 是否已上传
@end

NS_ASSUME_NONNULL_END
