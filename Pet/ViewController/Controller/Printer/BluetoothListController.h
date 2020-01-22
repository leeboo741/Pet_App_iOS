//
//  BluetoothListController.h
//  Pet
//
//  Created by mac on 2020/1/22.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrinterConneterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BluetoothListController : UIViewController
@property(nonatomic, assign)ConnectDeviceState connectStateBlock;
@end

NS_ASSUME_NONNULL_END
