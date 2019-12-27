//
//  TransportTypeCell.h
//  Pet
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TransportTypeCell;
@protocol TransportTypeCellDelegate <NSObject>

-(void)transportTypeCellDidSelected:(TransportTypeCell*)cell;

@end

@interface TransportTypeCell : UICollectionViewCell
@property (nonatomic, copy) NSString * cellIconName;
@property (nonatomic, copy) NSString * cellTitle;
@property (nonatomic, strong) UIColor * cellColor;

@property (nonatomic, copy) NSString * cellSelectIconName;
@property (nonatomic, copy) NSString * cellSelectTitle;
@property (nonatomic, strong) UIColor * cellSelectColor;

@property (nonatomic, copy) NSString * cellDisableIconName;
@property (nonatomic, copy) NSString * cellDisableTitle;
@property (nonatomic, strong) UIColor * cellDisableColor;

@property (nonatomic, assign) BOOL typeIsSelected;
@property (nonatomic, assign) BOOL typeIsDisable;

@property (nonatomic, weak) id<TransportTypeCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
