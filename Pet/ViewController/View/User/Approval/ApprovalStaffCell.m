//
//  ApprovalStaffCell.m
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApprovalStaffCell.h"
#import "OrderOperateBoxView.h"

@interface ApprovalStaffCell ()<OrderOperateBoxViewDelegate>
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *operationBoxView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;

@end

@implementation ApprovalStaffCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.operationBoxView.delegate = self;
    [self insertButtonModelWithTitle:@"批准" style:OrderOperateButtonStyle_Green type:OrderOperateButtonType_Approval];
    [self insertButtonModelWithTitle:@"驳回" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Reject];
    self.operationBoxView.buttonModelArray = self.operateButtonModelArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - operate box view delegate

-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view{
    MSLog(@"%ld",model.index);
    if (_delegate && [_delegate respondsToSelector:@selector(tapOperateButtonWithType:atApprovalStaffCell:)]) {
        [_delegate tapOperateButtonWithType:model.type atApprovalStaffCell:self];
    }
}

#pragma mark - setters and getters

-(NSMutableArray<OrderOperateButtonModel *> *)operateButtonModelArray{
    if (!_operateButtonModelArray) {
        _operateButtonModelArray = [NSMutableArray array];
    }
    return _operateButtonModelArray;
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

-(void)setPhone:(NSString *)phone{
    _phone = phone;
    self.phoneLabel.text = phone;
}

#pragma mark - private method

-(void)insertButtonModelWithTitle:(NSString *)title style:(OrderOperateButtonStyle)style type:(OrderOperateButtonType)type{
    OrderOperateButtonModel * model = [[OrderOperateButtonModel alloc]init];
    model.title = title;
    model.style = style;
    model.type = type;
    [self.operateButtonModelArray addObject:model];
}

@end
