//
//  CenterHeaderCell.h
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CenterHeaderCell;
@protocol CenterheaderCellDelegate <NSObject>

-(void)tapMessageButtonAtHeaderCell:(CenterHeaderCell *)cell;
-(void)tapBalanceAtHeaderCell:(CenterHeaderCell *)cell;

@end
@interface CenterHeaderCell : UITableViewCell
@property (nonatomic, strong) UserEntity * user;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) BOOL haveNewMessage;
@property (nonatomic, weak) id<CenterheaderCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
