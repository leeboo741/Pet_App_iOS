//
//  WithdrawalView.h
//  Pet
//
//  Created by mac on 2020/1/7.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WithdrawalView;
@protocol WithdrawalViewDelegate <NSObject>

-(void)tapWithdrawalButtonAtWithdrawalView:(WithdrawalView *)view;
-(void)tapWithdrawalFlowButtonAtWithdrawalView:(WithdrawalView *)view;

-(BOOL)textShouldBeginEditing:(UITextField *)textField atWithdrawalView:(WithdrawalView *)view;
-(BOOL)textShouldChange:(UITextField *)textField text:(NSString *)text atWithdrawalView:(WithdrawalView *)view;
-(void)textDidEndEditing:(UITextField *)textField atWithdrawalView:(WithdrawalView *)view;
@end

@interface WithdrawalView : UIView
@property (nonatomic, weak) IBOutlet UIView * view;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * ableWithdrawal;
@property (nonatomic, copy) NSString * disableWithdrawal;
@property (nonatomic, weak) id<WithdrawalViewDelegate>delegate;
-(void)clearWithdrawlInput;
@end

NS_ASSUME_NONNULL_END
