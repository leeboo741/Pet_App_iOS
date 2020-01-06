//
//  MediaShowBox.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "MediaShowBox.h"
#import "MediaShowItem.h"
#import "PreviewMediaController.h"

static NSString * MediaShowItemIdentifier = @"MeidaShowItem";

@interface MediaShowBox () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign, readonly) NSInteger columnCount;
@property (nonatomic, assign, readonly) CGFloat itemHeight;
@end

@implementation MediaShowBox

-(instancetype)init{
    self = [super init];
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

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    [self addSubview:self.collectionView];
    self.data = @[];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - collectionview delegate and datasource
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(mediaShowBox:didSelectItemAtIndex:)]) {
        [_delegate mediaShowBox:self didSelectItemAtIndex:indexPath.row
         ];
    }
    UIViewController * currentVC = Util_GetCurrentVC;
    PreviewMediaController * previewMediaVC = [[PreviewMediaController alloc]init];
    previewMediaVC.dataSource = self.data;
    previewMediaVC.currentIndex = indexPath.row;
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:previewMediaVC animated:YES];
    } else {
        [currentVC presentViewController:previewMediaVC animated:YES completion:nil];
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaShowItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:MediaShowItemIdentifier forIndexPath:indexPath];
    item.model = self.data[indexPath.row];
    return item;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.collectionView.frame.size.width / self.columnCount;
    CGFloat height = self.itemHeight;
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - setters and getters

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = Color_white_1;
        [_collectionView registerClass:[MediaShowItem class] forCellWithReuseIdentifier:MediaShowItemIdentifier];
    }
    return _collectionView;
}


-(CGFloat)itemHeight{
    if (_dataSource && [_dataSource respondsToSelector:@selector(itemHeightForMediaShowBox:)]) {
        CGFloat itemHeight = [_dataSource itemHeightForMediaShowBox:self];
        if (itemHeight <= 0) {
            itemHeight = 130;
        }
        return itemHeight;
    } else {
        return 130;
    }
}

-(NSInteger)columnCount{
    if (_dataSource && [_dataSource respondsToSelector:@selector(itemColumnCountForMediaShowBox:)]) {
        NSInteger columnCount = [_dataSource itemColumnCountForMediaShowBox:self];
        if (columnCount <= 0) {
            columnCount = 1;
        }
        return columnCount;
    } else {
        return 4;
    }
}

-(void)setData:(NSArray<MediaShowItemModel *> *)data{
    _data = data;
    [self resetConstraints];
}

#pragma mark - private method

-(void)resetConstraints{
    NSInteger row = 0;
    NSInteger lastColumn = 0;
    row = self.data.count / self.columnCount;
    lastColumn = self.data.count % self.columnCount;
    if (lastColumn != 0) {
        row = row + 1;
    }
    CGFloat collectionViewHeight = row * self.itemHeight;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(collectionViewHeight);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


@end
