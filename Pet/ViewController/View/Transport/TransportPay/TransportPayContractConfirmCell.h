//
//  TransportPayContractConfirmCell.h
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TransportPayContractConfirmCell;
@protocol TransportPayContractConfirmCellDelegate <NSObject>

-(void)transportPayContractConfirmCellTapConfirm:(TransportPayContractConfirmCell *)cell;

@end

@interface TransportPayContractConfirmCell : UITableViewCell
@property (nonatomic, assign) BOOL isConfirm;
@property (nonatomic, weak) id<TransportPayContractConfirmCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
