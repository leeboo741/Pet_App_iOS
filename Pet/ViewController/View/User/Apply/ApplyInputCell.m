//
//  ApplyInputCell.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyInputCell.h"
@interface ApplyInputCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *cellInputTextField;

@end

@implementation ApplyInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.flagImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_NotNull, 15, Color_red_1)];
    self.cellInputTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldBeganEditing:atApplyInputCell:)]) {
        return [_delegate shouldBeganEditing:textField atApplyInputCell:self];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_delegate && [_delegate respondsToSelector:@selector(shouldChangeText:withTextField:atApplyInputCell:)]) {
        return [_delegate shouldChangeText:text withTextField:textField atApplyInputCell:self];
    }
    return YES;
}

-(void)setShowFlag:(BOOL)showFlag{
    self.flagImageView.hidden = !showFlag;
}

-(void)setCellTitle:(NSString *)cellTitle{
    self.cellTitleLabel.text = cellTitle;
}

-(void)setCellValue:(NSString *)cellValue{
    self.cellInputTextField.text = cellValue;
}

-(void)setCellPlaceholder:(NSString *)cellPlaceholder{
    self.cellInputTextField.placeholder = cellPlaceholder;
}

@end
