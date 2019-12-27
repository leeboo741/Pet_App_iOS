//
//  TransportOrderValueAddCell.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TransportOrderValueAddCell;

@protocol TransportOrderValueAddCellDelegate <NSObject>

-(BOOL)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueInputShouldBeginEditing:(UITextField *)textField;
-(BOOL)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueinput:(UITextField *)textField afterChangeText:(NSString *)text;
-(void)valueAddCell:(TransportOrderValueAddCell *)cell serviceValueinputDidEndEditing:(UITextField *)textField;

-(void)valueAddCellTapHeadder:(TransportOrderValueAddCell *)cell;
-(void)valueAddCellTapContract:(TransportOrderValueAddCell *)cell;

@end

@interface TransportOrderValueAddCell : UITableViewCell

@property (nonatomic, assign) BOOL serviceEnableTap;
@property (nonatomic, assign) BOOL serviceIsSelected;
@property (nonatomic, copy) NSString * serviceName;
@property (nonatomic, copy) NSString * serviceDetail;
@property (nonatomic, copy) NSString * serviceContract;

@property (nonatomic, assign) BOOL showInputArea;
@property (nonatomic, copy) NSString * serviceValue;
@property (nonatomic, copy) NSString * serviceValuePlaceholder;

@property (nonatomic, assign) BOOL showInfoArea;
@property (nonatomic, copy) NSString * serviceInfo;

@property (nonatomic, weak) id<TransportOrderValueAddCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
