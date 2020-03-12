//
//  OrderRemarkInputCell.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderRemarkInputCell.h"

@interface OrderRemarkInputCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *remarkInputTextField;
@end

@implementation OrderRemarkInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarkInputTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!kStringIsEmpty(textField.text)) {
        if (_delegate && [_delegate respondsToSelector:@selector(remarkInputShouldReturnAtCell:text:)]) {
            [_delegate remarkInputShouldReturnAtCell:self text:textField.text];
        }
    }
    return YES;
}
-(void)clearInput{
    self.remarkInputTextField.text = nil;
}
@end
