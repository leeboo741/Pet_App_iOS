//
//  CenterActionCell.m
//  Pet
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "CenterActionCell.h"

static CGFloat Row_Height = 90;
static NSInteger Column_Count = 5;

@interface CenterActionCell ()
@property (weak, nonatomic) IBOutlet UIView *actionContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionContentViewHeightConstrant;

@property (nonatomic, strong) NSMutableArray<CenterActionItem *> *itemsArray;
@end

@implementation CenterActionCell

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self resetConstrants];
}

#pragma mark - private method

-(void)resetConstrants{
    // 循环约束
    for (int index = 0; index < self.itemsArray.count; index ++) {
        // 获取当前 item
        CenterActionItem * item = self.itemsArray[index];
        // 计算当前 item 所在行和列
        NSInteger column = index % Column_Count;
        NSInteger row = index / Column_Count;
        // 当为最后一个 item 时 要相对于 self.bottom 约束
        // 当为第一个 item 时 相对于 self.left self.top 约束
        // 当为第一列 item 时 移动列 还要移动行，相对于上一行第一列约束， 即相对于 show_column 个数量之前的 item 约束
        // 除以上两种情况 在同一行 向后移位， item 相对于前一个 item.right item.top 约束
        if (index != self.itemsArray.count - 1) {
            if (row == 0 && column == 0) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                    make.left.equalTo(self);
                    make.height.mas_equalTo(Row_Height);
                    make.width.mas_equalTo(self.frame.size.width / Column_Count);
                }];
            } else {
                CenterActionItem * targetItem;
                if (column == 0) {
                    targetItem = self.itemsArray[index - Column_Count];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem);
                        make.top.equalTo(targetItem.mas_bottom);
                        make.width.height.equalTo(targetItem);
                    }];
                } else {
                    targetItem = self.itemsArray[index - 1];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem.mas_right);
                        make.top.equalTo(targetItem);
                        make.width.height.equalTo(targetItem);
                    }];
                }
                
            }
        } else {
            if (row == 0 && column == 0) {
                [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self);
                    make.height.mas_equalTo(Row_Height);
                    make.width.mas_equalTo(self.frame.size.width / Column_Count);
                    make.bottom.equalTo(self);
                }];
            } else {
                CenterActionItem * targetItem;
                if (column == 0) {
                    targetItem = self.itemsArray[index - Column_Count];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem);
                        make.top.equalTo(targetItem.mas_bottom);
                        make.width.height.equalTo(targetItem);
                        make.bottom.equalTo(self);
                    }];
                } else {
                    targetItem = self.itemsArray[index - 1];
                    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(targetItem.mas_right);
                        make.top.equalTo(targetItem);
                        make.width.height.equalTo(targetItem);
                        make.bottom.equalTo(self);
                    }];
                }
            }
        }
    }
}
-(void)resetActionItems{
    for (CenterActionItem * item in self.itemsArray) {
        [item removeFromSuperview];
    }
    [self.itemsArray removeAllObjects];
    for (CenterActionItemModel * model in self.modelArray) {
        CenterActionItem * item = [[CenterActionItem alloc]init];
        item.model = model;
        [self.itemsArray addObject:item];
        [self addSubview:item];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - setters and getters
-(void)setModelArray:(NSArray<CenterActionItemModel *> *)modelArray{
    _modelArray = modelArray;
    NSInteger rowCount = modelArray.count / Column_Count;
    NSInteger lastColumn = modelArray.count % Column_Count;
    if (lastColumn != 0) {
        rowCount = rowCount + 1;
    }
    self.actionContentViewHeightConstrant.constant = rowCount * Row_Height;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self resetActionItems];
}

- (NSMutableArray<CenterActionItem *> *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

@end
