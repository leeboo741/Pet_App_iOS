//
//  ImageBoxTestCell.m
//  Pet
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageBoxTestCell.h"

@interface ImageBoxTestCell ()<MediaSelectBoxViewDelegate,MediaSelectBoxViewConfig>
@property (weak, nonatomic) IBOutlet MediaSelectBoxView *boxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign) CGFloat boxHeight;
@end

@implementation ImageBoxTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.boxView.delegate = self;
    self.boxView.config = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - image and video select boxview delegate and datasource
-(void)mediaSelectBox:(MediaSelectBoxView *)box didChangeDataSource:(NSArray<id<MediaSelectItemProtocol>> *)dataSource{
    if(_delegate && [_delegate respondsToSelector:@selector(imageBoxTestCell:changeData:)]) {
        [_delegate imageBoxTestCell:self changeData:dataSource];
    }
}

-(void)mediaSelectBox:(MediaSelectBoxView *)box didChangeHeight:(CGFloat)height{
    self.boxHeight = height;
    if(_delegate && [_delegate respondsToSelector:@selector(imageBoxTestCell:changeHeight:)]) {
        [_delegate imageBoxTestCell:self changeHeight:self.boxHeight+30];
    }
}

-(NSInteger)numberOfMediaSelectBoxColumn{
    if (_config && [_config respondsToSelector:@selector(numberOfMediaColumn)]) {
        return [_config numberOfMediaColumn];
    } else {
        return 3;
    }
}

-(CGFloat)heightOfMediaSelectBoxItem{
    return self.mediaItemHeight;
}

#pragma mark - setters and getters

-(CGFloat)mediaItemHeight{
    if (_config && [_config respondsToSelector:@selector(heightOfMediaItem)]) {
        return [_config heightOfMediaItem];
    } else {
        return 150;
    }
}

-(void)setDelegate:(id<ImageBoxTestCellDelegate>)delegate{
    _delegate = delegate;
    if(delegate && [delegate respondsToSelector:@selector(imageBoxTestCell:changeHeight:)]) {
        [delegate imageBoxTestCell:self changeHeight:self.boxHeight+30];
    }
}


@end
