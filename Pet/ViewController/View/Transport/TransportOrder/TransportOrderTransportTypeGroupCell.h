//
//  TransportOrderTransportTypeGroupCell.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportTypeProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class TransportOrderTransportTypeGroupCell;
@protocol TransportOrderTransportTypeGroupCellDelegate <NSObject>

-(void)transportTypeGroupCell:(TransportOrderTransportTypeGroupCell*)cell didSelectTransportTypeAtIndex:(NSInteger)index;

@end

@interface TransportOrderTransportTypeGroupCell : UITableViewCell
@property (nonatomic, strong) NSArray<id<TransportTypeProtocol>> * transportTypeList;
@property (nonatomic, weak) id<TransportOrderTransportTypeGroupCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

