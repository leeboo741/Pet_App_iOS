//
//  HomeView.m
//  Pet
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HomeView.h"
#import "MainBannerView.h"
#import "HomeActionCell.h"

static NSString * homeActionCellIdentifier = @"HomeActionCellIdentifier";
static CGFloat Banner_Height = 200; // banner 高度
static CGFloat Action_Height = 500; // action content 高度
static CGFloat Splice_Height = 20; // 间距
static NSInteger Action_Show_Row = 3; // action 显示行数
static NSInteger Action_Show_Column = 2; // action 显示列数
static CGFloat Action_Content_Width_Multiplied = 0.9; // action content 宽度 系数

@interface HomeView () <BannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) MainBannerView * bannerView;
@property (nonatomic, strong) UICollectionView * actionContentView;
@end

@implementation HomeView

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = kRGBColor(250, 250, 250);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.bannerView];
        [self.contentView addSubview:self.actionContentView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - bannerview delegate
-(void)bannerView:(MainBannerView *)bannerView didSelectImageView:(NSInteger)index withURL:(NSString *)imageURL{
    if (_delegate && [_delegate respondsToSelector:@selector(homeViewSelectBannerAtIndex:)]) {
        [_delegate homeViewSelectBannerAtIndex:index];
    }
}

#pragma mark - collectionview delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeActionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeActionCellIdentifier forIndexPath:indexPath];
    id<HomeActionProtocol> homeActionModel = self.actionArray[indexPath.row];
    cell.iconName = [homeActionModel iconName];
    cell.actionTitle = [homeActionModel actionTitle];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.actionArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(homeViewSelectActionAtIndex:)]){
        [_delegate homeViewSelectActionAtIndex:indexPath.row];
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((self.actionContentView.frame.size.width / Action_Show_Column)-0.5 ,(self.actionContentView.frame.size.height - Action_Show_Row - 1) / Action_Show_Row);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - event action


#pragma mark - setters and getters

-(UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.frame];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(self.frame.size.width, Banner_Height + Splice_Height * (Action_Show_Row - 1) + Action_Height);
    }
    return _contentView;
}

-(MainBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[MainBannerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, Banner_Height) scrollDirection:BannerViewScrollDirection_Landscape images:self.imagePathArray];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

-(UICollectionView *)actionContentView{
    if(!_actionContentView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
         // 设置滚动条方向
         layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _actionContentView = [[UICollectionView alloc]initWithFrame:CGRectMake((self.frame.size.width*((1-Action_Content_Width_Multiplied)/2)), Banner_Height + Splice_Height, self.frame.size.width*Action_Content_Width_Multiplied, Action_Height) collectionViewLayout:layout];
        [_actionContentView registerClass:[HomeActionCell class] forCellWithReuseIdentifier:homeActionCellIdentifier];
        _actionContentView.layer.cornerRadius = 10;
        _actionContentView.layer.shadowOffset = CGSizeMake(5, 5);
        _actionContentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _actionContentView.layer.shadowOpacity = 0.3;
        _actionContentView.layer.masksToBounds = YES;
        _actionContentView.delegate = self;
        _actionContentView.dataSource = self;
        _actionContentView.showsVerticalScrollIndicator = NO;
        _actionContentView.showsHorizontalScrollIndicator = NO;
        _actionContentView.backgroundColor = kRGBColor(233, 233, 233);
    }
    return _actionContentView;
}

-(void)setImagePathArray:(NSArray<NSString *> *)imagePathArray{
    _imagePathArray = imagePathArray;
    [self.bannerView reloadBannerWithURLs:imagePathArray];
}

-(void)setActionArray:(NSArray<id<HomeActionProtocol>> *)actionArray{
    _actionArray = actionArray;
    [self.actionContentView reloadData];
    
}

@end
