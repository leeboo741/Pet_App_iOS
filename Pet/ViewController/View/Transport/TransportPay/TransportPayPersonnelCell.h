//
//  TransportPayPersonnelCell.h
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TransportPayPersonnelCell_TextFieldType) {
    TransportPayPersonnelCell_TextFieldType_SenderName = 0,
    TransportPayPersonnelCell_TextFieldType_SenderPhone,
    TransportPayPersonnelCell_TextFieldType_ReceiverName,
    TransportPayPersonnelCell_TextFieldType_ReceiverPhone,
};

@class TransportPayPersonnelCell;

@protocol TransportPayPersonnelCellDelegate <NSObject>

@required
-(BOOL)transportPayPersonnelCell:(TransportPayPersonnelCell *)cell changeText:(NSString *)text textFieldType:(TransportPayPersonnelCell_TextFieldType)type;
@optional
-(void)transportPayPersonnelCell:(TransportPayPersonnelCell *)cell didEndEditingTextFieldType:(TransportPayPersonnelCell_TextFieldType)type;

@end

@interface TransportPayPersonnelCell : UITableViewCell
@property (nonatomic, copy) NSString * senderName;
@property (nonatomic, copy) NSString * senderPhone;
@property (nonatomic, copy) NSString * receiverName;
@property (nonatomic, copy) NSString * receiverPhone;
@property (nonatomic, weak) id<TransportPayPersonnelCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
