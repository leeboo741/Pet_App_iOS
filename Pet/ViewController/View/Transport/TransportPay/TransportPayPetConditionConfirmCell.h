//
//  TransportPayPetConditionConfirmCell.h
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TransportPayPetConditionConfirmCell;
@protocol TransportPayPetConditionConfirmCellDelegate <NSObject>

-(void)transportPayPetConditionConfirmCellTapConfirmButton:(TransportPayPetConditionConfirmCell *)cell;

@end

@interface TransportPayPetConditionConfirmCell : UITableViewCell
@property (nonatomic, copy) NSString * conditionText;
@property (nonatomic, assign) BOOL isConfirm;
@property (nonatomic, weak) id<TransportPayPetConditionConfirmCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
