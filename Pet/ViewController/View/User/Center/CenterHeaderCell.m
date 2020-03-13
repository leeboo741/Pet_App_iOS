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
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLabel;
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
    self.showBalance = YES;
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
    self.roleLabel.hidden = YES;
    if (user.currentRole == CURRENT_USER_ROLE_CUSTOMER) {
        self.roleLabel.hidden = NO;
        self.roleLabel.text = @"个人用户";
    } else if (user.currentRole == CURRENT_USER_ROLE_BUSINESS) {
        if ([[UserManager shareUserManager] isBusiness]) {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"认证商家";
        } else {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"普通商家";
        }
    } else if (user.currentRole == CURRENT_USER_ROLE_STAFF) {
        if ([[UserManager shareUserManager] isManager]) {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"管理员";
        } else if ([[UserManager shareUserManager] isDriver]) {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"司机";
        } else if ([[UserManager shareUserManager] isService]) {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"客服";
        } else {
            self.roleLabel.hidden = NO;
            self.roleLabel.text = @"员工";
        }
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

-(void)setShowBalance:(BOOL)showBalance{
    _showBalance = showBalance;
    if (showBalance) {
        self.balanceLabel.hidden = NO;
        self.balanceTitleLabel.hidden = NO;
    } else {
        self.balanceLabel.hidden = YES;
        self.balanceTitleLabel.hidden = YES;
    }
}

@end
