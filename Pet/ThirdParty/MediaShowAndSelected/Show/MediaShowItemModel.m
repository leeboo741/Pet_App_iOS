//
//  MediaShowItemModel.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MediaShowItemModel.h"

@implementation MediaShowItemModel
-(NSString *)coverImagePath{
    if (!_coverImagePath) {
        if (self.mediaType == MediaType_Image) {
            _coverImagePath = self.resourcePath;
        }
    }
    return _coverImagePath;
}
-(MediaType)mediaType{
    if (self.resourcePath && [self.resourcePath containsString:@".jpg"]) {
        return MediaType_Image;
    } else if (self.resourcePath && [self.resourcePath containsString:@".mp4"]){
        return MediaType_Video;
    } else {
        return MediaType_Unknow;
    }
}
@end
