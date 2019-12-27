//
//  TransportPayRemarkCell.h
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TransportPayRemarkCell;

@protocol TransportPayRemarkCellDelegate <NSObject>

-(BOOL)transportPayRemarkCell:(TransportPayRemarkCell *)cell textView:(UITextView *)textView changeText:(NSString *)text;

@end

@interface TransportPayRemarkCell : UITableViewCell
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, weak) id<TransportPayRemarkCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
