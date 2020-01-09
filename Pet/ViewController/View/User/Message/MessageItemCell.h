//
//  MessageItemCell.h
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageItemCell : UITableViewCell
@property (nonatomic, copy) NSString * messageTitle;
@property (nonatomic, copy) NSString * messageContent;
@property (nonatomic, copy) NSString * messageTime;
@end

NS_ASSUME_NONNULL_END
