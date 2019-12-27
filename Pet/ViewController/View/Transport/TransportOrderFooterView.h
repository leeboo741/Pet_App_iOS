//
//  TransportOrderFooterView.h
//  Pet
//
//  Created by mac on 2019/12/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TransportOrderFooterView_Type) {
    TransportOrderFooterView_Type_Order = 0,
    TransportOrderFooterView_Type_Pay,
    TransportOrderFooterView_Type_Commit,
};

@protocol TransportOrderFooterViewDelegate <NSObject>

-(void)transportOrderFooterTapOrder;
-(void)transportOrderFooterTapCall;

@end

@interface TransportOrderFooterView : UIView
@property (nonatomic, copy) NSString * price;
@property (nonatomic, weak) id<TransportOrderFooterViewDelegate> delegate;
@property (nonatomic, assign) TransportOrderFooterView_Type type;
@end

NS_ASSUME_NONNULL_END
