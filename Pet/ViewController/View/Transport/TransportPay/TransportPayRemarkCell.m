//
//  TransportPayRemarkCell.m
//  Pet
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TransportPayRemarkCell.h"

@interface TransportPayRemarkCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UITextView *remarkInput;

@end

@implementation TransportPayRemarkCell

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarkInput.layer.cornerRadius = 10;
    self.remarkInput.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - textview delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_delegate && [_delegate respondsToSelector:@selector(transportPayRemarkCell:textView:changeText:)]) {
        return [_delegate transportPayRemarkCell:self textView:textView changeText:[textView.text stringByReplacingCharactersInRange:range withString:text]];
    }
    return YES;
}

#pragma mark - setters and getters
-(void)setRemark:(NSString *)remark{
    _remark = remark;
    self.remarkInput.text = remark;
}

@end
