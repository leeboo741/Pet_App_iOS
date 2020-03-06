//
//  CenterHeaderCell.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "CenterHeaderCell.h"
#import "UIButton+Badge.h"

@interface CenterHeaderCell ()
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *infoLineOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLineOneHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *infoLineTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLineTwoHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation CenterHeaderCell
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initView{
    self.avaterImageView.layer.cornerRadius = 50;
    self.avaterImageView.layer.masksToBounds = YES;
    self.roleLabel.layer.cornerRadius = 10;
    self.roleLabel.layer.masksToBounds = YES;
    [self.messageButton setImage:[UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Message, 32, Color_blue_2)] forState:UIControlStateNormal];
    self.messageButton.badgeMinSize = 4;
    self.messageButton.badgePadding = 2;
    [self.messageButton addTarget:self action:@selector(tapMessageButton) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBalance)];
    self.balanceLabel.userInteractionEnabled = YES;
    [self.balanceLabel addGestureRecognizer:tap];
}

#pragma mark - event target
-(void)tapMessageButton{
    if (_delegate && [_delegate respondsToSelector:@selector(tapMessageButtonAtHeaderCell:)]) {
        [_delegate tapMessageButtonAtHeaderCell:self];
    }
}

-(void)tapBalance{
    if (_delegate && [_delegate respondsToSelector:@selector(tapBalanceAtHeaderCell:)]) {
        [_delegate tapBalanceAtHeaderCell:self];
    }
}

#pragma mark - setters and getters
-(void)setUser:(UserEntity *)user {
    _user = user;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avaterImagePath] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.nameLabel.text = user.userName;
    self.phoneLabel.text = user.phone;
    switch (user.userRole) {
        case USER_ROLE_UNKOWN:
            break;
        case USER_ROLE_CUSTOMER:
            self.roleLabel.hidden = YES;
            self.roleLabel.text = @"客户";
            break;
        case USER_ROLE_SERVICE:
        case USER_ROLE_B_SERVICE:
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"客服";
            break;
        case USER_ROLE_DRIVER:
        case USER_ROLE_B_DRIVER:
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"司机";
            break;
        case USER_ROLE_MANAGER:
        case USER_ROLE_B_MANAGER:
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"管理员";
            break;
        case USER_ROLE_BUSINESS:
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"认证商家";
            break;
        default:
            break;
    }
}

-(void)setBalance:(CGFloat)balance{
    _balance = balance;
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2lf元",balance];
}

-(void)setHaveNewMessage:(BOOL)haveNewMessage {
    _haveNewMessage = haveNewMessage;
    if (haveNewMessage) {
        self.messageButton.badgeValue = @" ";
    } else {
        self.messageButton.badgeValue = @"";
    }
}

@end
