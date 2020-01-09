//
//  MessageItemCell.m
//  Pet
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "MessageItemCell.h"

@interface MessageItemCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@end

@implementation MessageItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.boxView.layer.cornerRadius = 10;
    self.boxView.layer.borderColor = Color_gray_2.CGColor;
    self.boxView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageTitle:(NSString *)messageTitle{
    _messageTitle = messageTitle;
    self.messageTitleLabel.text = messageTitle;
}

-(void)setMessageContent:(NSString *)messageContent{
    _messageContent = messageContent;
    self.messageContentLabel.text = messageContent;
}

-(void)setMessageTime:(NSString *)messageTime{
    _messageTime = messageTime;
    self.messageTimeLabel.text = messageTime;
}

@end
