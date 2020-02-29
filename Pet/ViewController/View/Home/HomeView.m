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
static CGFloat Action_Height = 360; // action content 高度
static CGFloat Action_Title_Height = 60; // action title 高度
static CGFloat Action_Search_Height = 60; // action 搜索框 高度100
static CGFloat Splice_Height = 20; // 间距
static NSInteger Action_Show_Row = 3; // action 显示行数
static NSInteger Action_Show_Column = 2; // action 显示列数
static CGFloat Action_Content_Width_Multiplied = 0.9; // action content 宽度 系数

@interface HomeView () <BannerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) MainBannerView * bannerView;
@property (nonatomic, strong) UICollectionView * actionContentView;
@property (nonatomic, strong) UIView * actionBoxView;
@property (nonatomic, strong) UIView * actionTitleView;
@property (nonatomic, strong) UIView * actionSearchView;
@property (nonatomic, strong) UITextField * searchTextField;
@end

@implementation HomeView

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = kRGBColor(250, 250, 250);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.bannerView];
        [self.contentView addSubview:self.actionBoxView];
        [self.actionBoxView addSubview:self.actionTitleView];
        [self.actionBoxView addSubview:self.actionSearchView];
        [self.actionBoxView addSubview:self.actionContentView];
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

#pragma mark - text feild delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    MSLog(@"点击确定搜索");
    return  YES;
}

#pragma mark - setters and getters

-(UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.frame];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(self.frame.size.width, Banner_Height + Splice_Height * 2 + Action_Height + Action_Search_Height + Action_Title_Height);
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

-(UIView *)actionBoxView{
    if (!_actionBoxView) {
        _actionBoxView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width * (1-Action_Content_Width_Multiplied) / 2), Banner_Height + Splice_Height, self.frame.size.width * Action_Content_Width_Multiplied, Action_Height + Action_Search_Height + Action_Title_Height)];
        _actionBoxView.layer.cornerRadius = 8;
        _actionBoxView.layer.masksToBounds = NO;
        _actionBoxView.layer.cornerRadius = 10;
        _actionBoxView.layer.shadowOffset = CGSizeMake(5,5);
        _actionBoxView.layer.shadowColor = [UIColor blackColor].CGColor;
        _actionBoxView.layer.shadowOpacity = 0.1;
        _actionBoxView.backgroundColor = Color_white_1;
    }
    return _actionBoxView;
}

-(UIView *)actionTitleView{
    if (!_actionTitleView) {
        _actionTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.actionBoxView.frame.size.width, Action_Title_Height)];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, _actionTitleView.frame.size.height * 0.25, 4, _actionTitleView.frame.size.height * 0.5)];
        view.backgroundColor = Color_red_1;
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = YES;
        [_actionTitleView addSubview:view];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(24, 5, _actionTitleView.frame.size.width - 30, _actionTitleView.frame.size.height - 10)];
        label.text = @"业务导航";
        label.textColor = Color_gray_2;
        label.font = kFontSize(18);
        [_actionTitleView addSubview:label];
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _actionTitleView.frame.size.height - 1, _actionTitleView.frame.size.width, 1)];
        view2.backgroundColor = kRGBColor(250, 250, 250);
        [_actionTitleView addSubview:view2];
    }
    return _actionTitleView;
}

-(UIView *)actionSearchView{
    if (!_actionSearchView) {
        _actionSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, Action_Title_Height, self.actionBoxView.frame.size.width, Action_Search_Height)];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15, _actionSearchView.frame.size.height * 0.1, _actionSearchView.frame.size.width - 30, _actionSearchView.frame.size.height * 0.8)];
        view.backgroundColor = kRGBColor(250, 250, 250);
        view.layer.cornerRadius = view.frame.size.height / 2;
        view.layer.masksToBounds = YES;
        [_actionSearchView addSubview:view];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, (view.frame.size.height - 28)/2, 28, 28)];
        imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Search, 28, Color_gray_2)];
        [view addSubview:imageView];
        
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, view.frame.size.height * 0.1, view.frame.size.width - 55, view.frame.size.height * 0.8)];
        _searchTextField.delegate = self;
        _searchTextField.textColor = Color_gray_2;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.placeholder = @"查找订单";
        [view addSubview:_searchTextField];
        
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _actionSearchView.frame.size.height - 1, _actionSearchView.frame.size.width, 1)];
        view2.backgroundColor = kRGBColor(250, 250, 250);
        [_actionSearchView addSubview:view2];
    }
    return _actionSearchView;
}

-(UICollectionView *)actionContentView{
    if(!_actionContentView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
         // 设置滚动条方向
         layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _actionContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Action_Title_Height + Action_Search_Height, self.actionBoxView.frame.size.width, Action_Height) collectionViewLayout:layout];
        [_actionContentView registerClass:[HomeActionCell class] forCellWithReuseIdentifier:homeActionCellIdentifier];
        _actionContentView.delegate = self;
        _actionContentView.dataSource = self;
        _actionContentView.showsVerticalScrollIndicator = NO;
        _actionContentView.showsHorizontalScrollIndicator = NO;
        _actionContentView.backgroundColor = kRGBColor(250, 250, 250);
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
