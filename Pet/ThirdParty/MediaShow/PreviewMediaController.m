//
//  PreviewMediaController.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "PreviewMediaController.h"
#import "PreviewMediaImageCell.h"
#import "PreviewMediaVideoCell.h"
#import "PreviewMediaUnknowCell.h"

static NSString * ImageCellIdentifier = @"PreviewMediaImageCell";
static NSString * VideoCellIdentifier = @"PreviewMediaVideoCell";
static NSString * UnknowCellIdentifier = @"PreviewMediaUnknowCell";

@interface PreviewMediaController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, assign) CGFloat offsetItemCount;
@end

@implementation PreviewMediaController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = @[];
        self.currentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil]; 
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.frame.size.width + 20) * self.currentIndex, 0) animated:NO];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width + 20, self.view.frame.size.height);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.collectionView.frame = CGRectMake(-10, 0, self.view.frame.size.width + 20, self.view.frame.size.height);
    [self.collectionView setCollectionViewLayout:self.layout];
    if (self.offsetItemCount > 0) {
        CGFloat offsetX = self.offsetItemCount * self.layout.itemSize.width;
        [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
}

#pragma mark - setters and getters

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld / %ld",currentIndex+1, self.dataSource.count];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.dataSource.count * (self.view.frame.size.width + 20), 0);
        [_collectionView registerClass:[PreviewMediaImageCell class] forCellWithReuseIdentifier:ImageCellIdentifier];
        [_collectionView registerClass:[PreviewMediaVideoCell class] forCellWithReuseIdentifier:VideoCellIdentifier];
        [_collectionView registerClass:[PreviewMediaUnknowCell class] forCellWithReuseIdentifier:UnknowCellIdentifier];
    }
    return _collectionView;
}

-(UICollectionViewFlowLayout *)layout{
    if(!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _layout;
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.frame.size.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.frame.size.width + 20);
    
    if (currentIndex < self.dataSource.count && self.currentIndex != currentIndex) {
        self.currentIndex = currentIndex;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionView DataSource And Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaShowItemModel *model = self.dataSource[indexPath.item];
    __weak typeof(self) weakSelf = self;
    if (model.mediaType == MediaType_Image) {
        PreviewMediaImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.mediaType == MediaType_Video) {
        PreviewMediaVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (model.mediaType == MediaType_Unknow){
        PreviewMediaUnknowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:UnknowCellIdentifier forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PreviewMediaVideoCell class]]) {
        [(PreviewMediaVideoCell *)cell pausePlayerAndShowNaviBar];
    }
}

@end
