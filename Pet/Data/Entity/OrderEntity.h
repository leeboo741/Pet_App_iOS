//
//  OrderEntity.h
//  Pet
//
//  Created by lee on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderEntity : NSObject
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, strong) NSArray * waitUploadMediaList;
@end

NS_ASSUME_NONNULL_END
