//
//  ApprovalStationCell.m
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApprovalStationCell.h"
#import "OrderOperateBoxView.h"

@interface ApprovalStationCell ()<OrderOperateBoxViewDelegate>
@property (nonatomic, strong) NSMutableArray<OrderOperateButtonModel *> *operateButtonModelArray;
@property (weak, nonatomic) IBOutlet OrderOperateBoxView *operateBoxView;
@property (weak, nonatomic) IBOutlet UILabel *stroeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ApprovalStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.operateBoxView.delegate = self;
    [self insertButtonModelWithTitle:@"批准" style:OrderOperateButtonStyle_Green type:OrderOperateButtonType_Approval];
    [self insertButtonModelWithTitle:@"驳回" style:OrderOperateButtonStyle_Red type:OrderOperateButtonType_Reject];
    self.operateBoxView.buttonModelArray = self.operateButtonModelArray;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - operate box view delegate

-(void)onClickButtonWithModel:(OrderOperateButtonModel *)model atOrderOperateBoxView:(OrderOperateBoxView *)view{
    MSLog(@"%ld",model.index);
    if (_delegate && [_delegate respondsToSelector:@selector(tapOperateButtonWithType:atApprovalStationCell:)]) {
        [_delegate tapOperateButtonWithType:model.type atApprovalStationCell:self];
    }
}

#pragma mark - setters and getters

-(NSMutableArray<OrderOperateButtonModel *> *)operateButtonModelArray{
    if (!_operateButtonModelArray) {
        _operateButtonModelArray = [NSMutableArray array];
    }
    return _operateButtonModelArray;
}

-(void)setStationName:(NSString *)stationName{
    _stationName = stationName;
    self.stroeNameLabel.text = stationName;
}
-(void)setBusinessTime:(NSString *)businessTime{
    _businessTime = businessTime;
    self.businessTimeLabel.text = businessTime;
}
-(void)setPhone:(NSString *)phone{
    _phone = phone;
    self.contactNameLabel.text = phone;
}
-(void)setAddress:(NSString *)address{
    _address = address;
    self.addressLabel.text = address;
}
-(void)setDescribes:(NSString *)describes{
    _describes = describes;
    self.descriptionLabel.text = describes;
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
