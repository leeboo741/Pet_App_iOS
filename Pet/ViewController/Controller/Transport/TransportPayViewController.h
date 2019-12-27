//
//  TransportPayViewController.h
//  Pet
//
//  Created by mac on 2019/12/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TransportOrder;
@interface TransportPayViewController : UITableViewController
-(instancetype)initWithTransportOrder:(TransportOrder *)order;
@end

NS_ASSUME_NONNULL_END
