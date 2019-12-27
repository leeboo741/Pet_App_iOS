//
//  ImageBoxTestCell.m
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageBoxTestCell.h"

@interface ImageBoxTestCell ()<MediaSelectBoxViewDelegate>
@property (weak, nonatomic) IBOutlet MediaSelectBoxView *boxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation ImageBoxTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.boxView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - image and video select boxview delegate
-(void)mediaSelectBox:(MediaSelectBoxView *)box reloadDataSource:(NSArray *)dataSource{
    
}
-(void)mediaSelectBox:(MediaSelectBoxView *)box deleteData:(id<MediaSelectItemProtocol>)data atIndex:(NSInteger)index{
    
}
-(void)mediaSelectBox:(MediaSelectBoxView *)box changeHeight:(CGFloat)height{
    self.boxView.frame = CGRectMake(self.boxView.frame.origin.x
                                    , self.boxView.frame.origin.y
                                    , self.boxView.frame.size.width, self.boxView.frame.size.height);
    [self layoutIfNeeded];

}


@end
