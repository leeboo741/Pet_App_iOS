//
//  TransportPayPersonnelCell.m
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportPayPersonnelCell.h"

@interface TransportPayPersonnelCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *senderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *senderPhoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *recevierTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiverNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiverPhoneTextField;
@end


@implementation TransportPayPersonnelCell

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.senderNameTextField.delegate = self;
    self.senderNameTextField.textAlignment = NSTextAlignmentCenter;
    
    self.senderPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.senderPhoneTextField.delegate = self;
    self.senderPhoneTextField.textAlignment = NSTextAlignmentCenter;
    [self bringSubviewToFront:self.senderPhoneTextField];
    
    self.receiverNameTextField.delegate = self;
    self.receiverNameTextField.textAlignment = NSTextAlignmentCenter;
    
    self.receiverPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.receiverPhoneTextField.delegate = self;
    self.receiverPhoneTextField.textAlignment = NSTextAlignmentCenter;
    [self bringSubviewToFront:self.receiverPhoneTextField];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * textStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self getTextFieldType:textField] == TransportPayPersonnelCell_TextFieldType_ReceiverPhone
        || [self getTextFieldType:textField] == TransportPayPersonnelCell_TextFieldType_SenderPhone) {
        [self checkSafePhoneInput:textField text:textStr];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(transportPayPersonnelCell:changeText:textFieldType:)]) {
        return [_delegate transportPayPersonnelCell:self changeText:textStr textFieldType:[self getTextFieldType:textField]];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(transportPayPersonnelCell:didEndEditingTextFieldType:)]){
        [_delegate transportPayPersonnelCell:self didEndEditingTextFieldType:[self getTextFieldType:textField]];
    }
}

#pragma mark - private method
-(void)checkSafePhoneInput:(UITextField *)textField text:(NSString *)text{
    if (Util_IsPhoneString(text) || [text isEqualToString:@""]) {
        textField.layer.borderColor = Color_Clear.CGColor;
        textField.layer.borderWidth = 0;
        textField.layer.cornerRadius = 8;
        textField.layer.masksToBounds = YES;
    } else {
        textField.layer.borderColor = Color_red_1.CGColor;
        textField.layer.borderWidth = 2;
        textField.layer.cornerRadius = 8;
        textField.layer.masksToBounds = YES;
    }
}
-(TransportPayPersonnelCell_TextFieldType)getTextFieldType:(UITextField *)textField{
    TransportPayPersonnelCell_TextFieldType type;
    if (textField == self.senderNameTextField) {
        type = TransportPayPersonnelCell_TextFieldType_SenderName;
    } else if (textField == self.senderPhoneTextField) {
        type = TransportPayPersonnelCell_TextFieldType_SenderPhone;
    } else if (textField == self.receiverNameTextField) {
        type = TransportPayPersonnelCell_TextFieldType_ReceiverName;
    } else {
        type = TransportPayPersonnelCell_TextFieldType_ReceiverPhone;
    }
    return type;
}

#pragma mark - setters and getters
-(void)setSenderName:(NSString *)senderName {
    _senderName = senderName;
    self.senderNameTextField.text = senderName;
}

-(void)setSenderPhone:(NSString *)senderPhone {
    _senderPhone = senderPhone;
    self.senderPhoneTextField.text = senderPhone;
}

-(void)setReceiverName:(NSString *)receiverName {
    _receiverName = receiverName;
    self.receiverNameTextField.text = receiverName;
}

-(void)setReceiverPhone:(NSString *)receiverPhone {
    _receiverPhone = receiverPhone;
    self.receiverPhoneTextField.text = receiverPhone;
}
@end
