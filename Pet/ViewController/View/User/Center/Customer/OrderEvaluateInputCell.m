//
//  OrderEvaluateInputCell.m
//  Pet
//
//  Created by mac on 2020/1/10.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderEvaluateInputCell.h"

@interface OrderEvaluateInputCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation OrderEvaluateInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.inputTextView.layer.cornerRadius = 10;
    self.inputTextView.layer.borderColor = Color_gray_2.CGColor;
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.text = @"";
    self.inputTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * textString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (_delegate && [_delegate respondsToSelector:@selector(inputText:atOrderEvaluateInputCell:)]) {
        [_delegate inputText:textString atOrderEvaluateInputCell:self];
    }
    return YES;
}

@end
