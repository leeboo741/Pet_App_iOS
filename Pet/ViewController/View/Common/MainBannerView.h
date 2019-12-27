//
//  MainBannerView.h
//  BossModule
//
//  Created by YWKJ on 2019/12/18.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BannerViewScrollDirection)
{
    /// 水平滚动
    BannerViewScrollDirection_Landscape,
    /// 垂直滚动
    BannerViewScrollDirection_Portait
};

///Page Control 位置
typedef NS_ENUM(NSInteger, BannerViewPageStyle)
{
    BannerViewPageStyle_None,
    BannerViewPageStyle_Left,
    BannerViewPageStyle_Right,
    BannerViewPageStyle_Middle
};

@protocol BannerViewDelegate;

@interface MainBannerView : UIView
//@property (nonatomic, strong) NSArray *imageTitleArray;
// 存放所有需要滚动的图片URL NSString
@property (nonatomic, strong) NSArray *imagesArray;
// scrollView滚动的方向
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;
// 每条显示时间
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;
@property (nonatomic, weak) id <BannerViewDelegate> delegate;

///请使用该函数初始化
/**
 初始化

 @param frame frame
 @param direction 方向
 @param images 图片地址
 @return bannerView
 */
- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images;

///重新设置 imageUrls
- (void)reloadBannerWithURLs:(NSArray *)imageUrls;
///设置 Banner 圆角显示
- (void)setSquare:(NSInteger)asquare;
///设置 Banner 样式，默认PageControl居中
- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle;

///开起自动滚动 ， 默认不开始自动滚动，请手动开启
- (void)startRolling;
- (void)stopRolling;
@end

@protocol BannerViewDelegate <NSObject>

@optional
///点击图片
- (void)bannerView:(MainBannerView *)bannerView didSelectImageView:(NSInteger)index withURL:(NSString *)imageURL;

@end
