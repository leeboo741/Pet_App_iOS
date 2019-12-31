//
//  HomeViewController.m
//  Pet
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "StationListViewController.h"
#import "TransportOrderViewController.h"
#import "PersonnelOrderViewController.h"

@interface HomeViewAction : NSObject<HomeActionProtocol>
@property (nonatomic, copy) NSString * iconName;
@property (nonatomic, copy) NSString * actionTitle;
-(instancetype)initWithIconName:(NSString* )iconName actionTitle:(NSString* )actionTitle;
@end
@implementation HomeViewAction
-(instancetype)initWithIconName:(NSString *)iconName actionTitle:(NSString *)actionTitle{
    self = [super init];
    if (self){
        self.iconName = iconName;
        self.actionTitle = actionTitle;
    }
    return self;
}
@end

@interface HomeViewController ()<HomeViewDelegate>
@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) NSArray<NSString *> *imagePathArray;
@property (nonatomic, strong) NSArray<HomeViewAction *> *homeActionArray;
@end

@implementation HomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeView];
    self.homeView.actionArray = self.homeActionArray;
    self.navigationItem.title = @"首页";
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.homeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - home view delegate
-(void)homeViewSelectBannerAtIndex:(NSInteger)index{
    
}
-(void)homeViewSelectActionAtIndex:(NSInteger)index{
    if (index == 0) {
        TransportOrderViewController * transportOrderVC = [[TransportOrderViewController alloc]init];
        [self.navigationController pushViewController:transportOrderVC animated:YES];
    } else if (index == 1) {
        StationListViewController * stationListView = [[StationListViewController alloc]init];
        [self.navigationController pushViewController:stationListView animated:YES];
    } else if (index == 2) {
        PersonnelOrderViewController * personnelOrderVC = [[PersonnelOrderViewController alloc]init];
        [self.navigationController pushViewController:personnelOrderVC animated:YES];
    } else if (index == 3) {
        [[UserManager shareUserManager] changeUserRole:[[UserManager shareUserManager] getUserRole]+1];
    }
}

#pragma mark - setters and getters
-(HomeView *)homeView{
    if (!_homeView) {
        _homeView = [[HomeView alloc]initWithFrame:self.view.frame];
        _homeView.imagePathArray = self.imagePathArray;
        _homeView.delegate = self;
    }
    return _homeView;
}

-(NSArray<NSString *> *)imagePathArray{
    if (!_imagePathArray) {
        _imagePathArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576732018554&di=f6355b47700bdb62b7381851e006cd06&imgtype=0&src=http%3A%2F%2Fimg.51ztzj.com%2Fupload%2Fimage%2F20130417%2F201304172007_670x419.jpg",
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576732013190&di=a566b0fff9b908ef63b10ad32e17e769&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Frushidao%2Fpics%2Fhv1%2F20%2F108%2F1744%2F113431160.jpg",
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576731997356&di=cef20e68ef3a8adf40bdb8ea6b4e5f29&imgtype=0&src=http%3A%2F%2Fb2-q.mafengwo.net%2Fs5%2FM00%2F91%2F06%2FwKgB3FH_RVuATULaAAH7UzpKp6043.jpeg"];
    }
    return _imagePathArray;
}

-(NSArray<HomeViewAction *> *)homeActionArray{
    if(!_homeActionArray) {
        HomeViewAction * action1 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"托运宠物"];
        HomeViewAction * action2 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"驿站"];
        HomeViewAction * action3 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"个人订单"];
        HomeViewAction * action4 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"托运宠物"];
        HomeViewAction * action5 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"托运宠物"];
        _homeActionArray = @[action1,action2,action3,action4,action5];
    }
    return _homeActionArray;
}

@end
