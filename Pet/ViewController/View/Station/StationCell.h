//
//  StationCell.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationCell : UITableViewCell
@property (nonatomic, copy) NSString * logoPath;
@property (nonatomic, copy) NSString * stationName;
@property (nonatomic, copy) NSString * businessTime;
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * address;
@end

NS_ASSUME_NONNULL_END
