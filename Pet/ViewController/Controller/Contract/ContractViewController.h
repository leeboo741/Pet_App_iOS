//
//  ContractViewController.h
//  Pet
//
//  Created by mac on 2020/3/18.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ContractType) {
    ContractType_Image,
    ContractType_Text,
};
@interface ContractViewController : UIViewController
@property (nonatomic, assign) ContractType type;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * title;
@end

NS_ASSUME_NONNULL_END
