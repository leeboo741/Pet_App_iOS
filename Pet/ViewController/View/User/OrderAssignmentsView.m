//
//  OrderAssignmentsView.m
//  Pet
//
//  Created by mac on 2020/1/3.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "OrderAssignmentsView.h"

@interface OrderAssignmentsView ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@end

@implementation OrderAssignmentsView

#pragma mark - life cycle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"hidden"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"hidden"]) {
        self.titleLabel.hidden = self.hidden;
        self.contentLabel.hidden = self.hidden;
        [self resetContraints];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)resetContraints{
    if (self.hidden) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.1);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(0.1);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(12);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.right.equalTo(self.titleLabel);
            make.bottom.equalTo(self);
        }];
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - setters and getters
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"分配人员：";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.text = @"暂未分配";
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(void)setAssignmentsList:(NSArray *)assignmentsList{
    NSString * contentStr = @"";
    if (kArrayIsEmpty(assignmentsList)) {
        self.contentLabel.text = @"暂未分配";
        return;
    }
    for (id item in assignmentsList) {
        if ([item isKindOfClass:[NSString class]]) {
            if (kStringIsEmpty(contentStr)) {
                contentStr = (NSString *)item;
            } else {
                contentStr = [NSString stringWithFormat:@"%@,%@",contentStr,(NSString *)item];
            }
        }
    }
    self.contentLabel.text = contentStr;
}

-(void)setAssignmentsStr:(NSString *)assignmentsStr{
    if (kStringIsEmpty(assignmentsStr)) {
        self.contentLabel.text = @"暂未分配";
    } else {
        self.contentLabel.text = assignmentsStr;
    }
}



@end
