//
//  OrderInfoCell.h
//  Pet
//
//  Created by lee on 2020/1/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderInfoCell : UITableViewCell
@property (nonatomic, copy) NSString * infoTitle;
@property (nonatomic, copy) NSString * infoValue;
@property (nonatomic, copy) NSString * infoDetail;
@end

NS_ASSUME_NONNULL_END
