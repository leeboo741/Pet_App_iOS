//
//  MainBannerView.m
//  BossModule
//
//  Created by YWKJ on 2019/12/18.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import "MainBannerView.h"
#import "UIImageView+WebCache.h"

#define Banner_StartTag     1000
#define Banner_RollingDelayTime 2.5

@interface MainBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL enableRolling;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger curPageIndex;

@property (nonatomic, assign) BannerViewPageStyle pageSytle;

- (void)refreshScrollView;

- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;
@end

@implementation MainBannerView
- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //****************** Property *********
        self.imagesArray = [[NSArray alloc] initWithArray:images];
        self.scrollDirection = direction;
        self.totalPage = self.imagesArray.count;
        self.curPageIndex = 0;
        self.pageSytle = BannerViewPageStyle_Middle;
        _rollingDelayTime = Banner_RollingDelayTime;
        //****************** Scroll View *********
        self.scrollView.scrollEnabled = self.totalPage != 1;
        // 在水平方向滚动
        if(self.scrollDirection == BannerViewScrollDirection_Landscape)
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3,
                                                     self.scrollView.frame.size.height);
        }
        // 在垂直方向滚动
        else if(self.scrollDirection == BannerViewScrollDirection_Portait)
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                     self.scrollView.frame.size.height * 3);
        }
        [self addSubview:self.scrollView];
        //向 Scroll View 添加 Image View
        for (NSInteger i = 0; i < 3; i++)
        {
            UIView * view = [[UIView alloc] initWithFrame:self.scrollView.bounds];
            view.tag = Banner_StartTag + i;
            // 水平滚动
            if(self.scrollDirection == BannerViewScrollDirection_Landscape)
            {
                view.frame = CGRectOffset(view.frame, self.scrollView.frame.size.width * i, 0);
            }
            // 垂直滚动
            else if(self.scrollDirection == BannerViewScrollDirection_Portait)
            {
                view.frame = CGRectOffset(view.frame, 0, self.scrollView.frame.size.height * i);
            }
            
            [self.scrollView addSubview:view];

            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.tag = Banner_StartTag * 2 + i;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            
            [view addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            
//            UILabel * label = [[UILabel alloc] init];
//            label.backgroundColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:0.3];
//            label.tag = Banner_StartTag * 3 + i;
//            [view addSubview:label];
//
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(self);
//                make.bottom.equalTo(self);
//                make.height.mas_equalTo(20);
//            }];
            
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
//            imageView.userInteractionEnabled = YES;
//            imageView.contentMode = UIViewContentModeScaleToFill;
//            imageView.tag = Banner_StartTag+i;
//
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//            [imageView addGestureRecognizer:singleTap];
//
//            // 水平滚动
//            if(self.scrollDirection == BannerViewScrollDirection_Landscape)
//            {
//                imageView.frame = CGRectOffset(imageView.frame, self.scrollView.frame.size.width * i, 0);
//            }
//            // 垂直滚动
//            else if(self.scrollDirection == BannerViewScrollDirection_Portait)
//            {
//                imageView.frame = CGRectOffset(imageView.frame, 0, self.scrollView.frame.size.height * i);
//            }
//
//            [self.scrollView addSubview:imageView];
        }
//        [self addSubview:self.scrollView];
        
        //****************** Page Control *********
        [self setPageControlStyle:BannerViewPageStyle_Middle];
        self.pageControl.numberOfPages = self.totalPage;
        self.pageControl.currentPage = self.curPageIndex;
        [self addSubview:self.pageControl];
        
        [self refreshScrollView];
    }
    
    return self;
}

- (void)reloadBannerWithURLs:(NSArray *)imageUrls{
    self.imagesArray = [[NSArray alloc] initWithArray:imageUrls];
    self.totalPage = self.imagesArray.count;
    self.curPageIndex = 0;
    
    self.pageControl.numberOfPages = self.totalPage;
    self.pageControl.currentPage = self.curPageIndex;
    
    self.scrollView.scrollEnabled = self.totalPage != 1;
    
    [self refreshScrollView];
}

- (void)setSquare:(NSInteger)asquare{
    if (self.scrollView)
    {
        self.scrollView.layer.cornerRadius = asquare;
        if (asquare == 0)
        {
            self.scrollView.layer.masksToBounds = NO;
        }
        else
        {
            self.scrollView.layer.masksToBounds = YES;
        }
    }
}

- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle{
    _pageSytle = pageStyle;
    if (pageStyle == BannerViewPageStyle_Left)
    {
        [self.pageControl setFrame:CGRectMake(5, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageStyle == BannerViewPageStyle_Right)
    {
        [self.pageControl setFrame:CGRectMake(self.bounds.size.width-5-60, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageStyle == BannerViewPageStyle_Middle)
    {
        [self.pageControl setFrame:CGRectMake((self.bounds.size.width-60)/2, self.bounds.size.height-15, 60, 15)];
    }
    else if (pageStyle == BannerViewPageStyle_None)
    {
        [self.pageControl setHidden:YES];
    }
}
-(void)setImagesArray:(NSArray *)imagesArray{
    _imagesArray = imagesArray;
    if (kArrayIsEmpty(imagesArray) || imagesArray.count <= 1) {
        [self.pageControl setHidden:YES];
    }else{
        if (_pageSytle != BannerViewPageStyle_None){
            [self.pageControl setHidden:NO];
        }
    }
}
#pragma mark Rolling
- (void)startRolling{
    if (self.imagesArray.count <= 1) {
        self.enableRolling = NO;
        return;
    }
    
    [self stopRolling];
    self.enableRolling = YES;
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
    
}
- (void)stopRolling{
    self.enableRolling = NO;
    //取消已加入的延迟线程
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (void)rollingScrollAction
{
    [UIView animateWithDuration:0.25 animations:^{
        // 水平滚动
        if(self.scrollDirection == BannerViewScrollDirection_Landscape)
        {
            self.scrollView.contentOffset = CGPointMake(1.99*self.scrollView.frame.size.width, 0);
        }
        // 垂直滚动
        else if(self.scrollDirection == BannerViewScrollDirection_Portait)
        {
            self.scrollView.contentOffset = CGPointMake(0, 1.99*self.scrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self.curPageIndex = [self getPageIndex:self.curPageIndex+1];
        [self refreshScrollView];
        
        if (self.enableRolling)
        {
            [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
        }
    }];
}

#pragma mark - Event
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (kArrayIsEmpty(self.imagesArray)) return;
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectImageView:withURL:)])
    {
        [self.delegate bannerView:self didSelectImageView:self.curPageIndex withURL:[self.imagesArray objectAtIndex:self.curPageIndex]];
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    //取消已加入的延迟线程
    if (self.enableRolling)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }
    
    // 水平滚动
    if(self.scrollDirection == BannerViewScrollDirection_Landscape)
    {
        // 往下翻一张
        if (x >= 2 * self.scrollView.frame.size.width)
        {
            self.curPageIndex = [self getPageIndex:self.curPageIndex+1];
            [self refreshScrollView];
        }
        
        if (x <= 0)
        {
            self.curPageIndex = [self getPageIndex:self.curPageIndex-1];
            [self refreshScrollView];
        }
    }
    // 垂直滚动
    else if(self.scrollDirection == BannerViewScrollDirection_Portait)
    {
        // 往下翻一张
        if (y >= 2 * self.scrollView.frame.size.height)
        {
            self.curPageIndex = [self getPageIndex:self.curPageIndex+1];
            [self refreshScrollView];
        }
        
        if (y <= 0)
        {
            self.curPageIndex = [self getPageIndex:self.curPageIndex-1];
            [self refreshScrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    // 水平滚动
    if (self.scrollDirection == BannerViewScrollDirection_Landscape)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (self.scrollDirection == BannerViewScrollDirection_Portait)
    {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
    
    if (self.enableRolling)
    {
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
    }
}


#pragma mark - Private Method
- (NSInteger)getPageIndex:(NSInteger)index{
    if (index<0){
        index = self.totalPage - 1;
    }
    if (index == self.totalPage)
    {
        index = 0;
    }
    return index;
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex{
    
    NSInteger preIndex = [self getPageIndex:self.curPageIndex-1];
    NSInteger nextIndex = [self getPageIndex:self.curPageIndex+1];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    
    if (self.imagesArray.count > preIndex) {
        [images addObject:self.imagesArray[preIndex]];
    }
    if (self.imagesArray.count > self.curPageIndex) {
        [images addObject:self.imagesArray[self.curPageIndex]];
    }
    if (self.imagesArray.count > nextIndex) {
        [images addObject:self.imagesArray[nextIndex]];
    }
    return images;
}

- (void)refreshScrollView{
    NSArray *curImageUrls = [self getDisplayImagesWithPageIndex:self.curPageIndex];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        UIView * view = (UIView *)[self.scrollView viewWithTag:Banner_StartTag + i];
        
        UIImageView * imageView = (UIImageView *)[view viewWithTag:Banner_StartTag * 2 + i];
        
//        UILabel * label = (UILabel *)[view viewWithTag:Banner_StartTag * 3 + i];
//        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:Banner_StartTag+i];
        NSString *url = curImageUrls.count > i ? curImageUrls[i] : nil;
        if (imageView && [imageView isKindOfClass:[UIImageView class]] && url)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"logo"]];
        }
    }
    
    // 水平滚动
    if (self.scrollDirection == BannerViewScrollDirection_Landscape)
    {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    // 垂直滚动
    else if (self.scrollDirection == BannerViewScrollDirection_Portait)
    {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
    
    self.pageControl.currentPage = self.curPageIndex;
    [self startRolling];
}


#pragma mark - Init Property
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectNull];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FF9D44"];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

@end
