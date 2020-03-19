//
//  MediaShowItemModel.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MediaShowItemModel.h"

@implementation MediaShowItemModel
-(instancetype)init{
    if (self = [super init]) {
        self.mediaType = MediaType_Unknow;
    }
    return self;
}
-(NSString *)coverImagePath{
    if (!_coverImagePath) {
        if (self.mediaType == MediaType_Image) {
            _coverImagePath = self.resourcePath;
        }
    }
    return _coverImagePath;
}
-(MediaType)mediaType{
    if (_mediaType == MediaType_Unknow) {
        if (self.resourcePath) {
            NSString * resource = [self.resourcePath lowercaseString];
            if ([resource containsString:@".jpg"]
            || [resource containsString:@".png"]
            || [resource containsString:@".jpeg"]) {
                return MediaType_Image;
            } else if ([resource containsString:@".mp4"]
                       || [resource containsString:@".mov"]) {
                return MediaType_Video;
            } else {
                return MediaType_Unknow;
            }
        }
        return MediaType_Unknow;
    }
    return _mediaType;
}
@end
