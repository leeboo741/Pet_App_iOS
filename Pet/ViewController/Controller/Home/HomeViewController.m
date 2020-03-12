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
#import "TestShowBoxViewController.h"
#import "CustomerOrderManager.h"
#import "SiteOrderManager.h"
#import "OrderDetailController.h"

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
-(void)handlerSearchResut:(NSString *)result{
    if (kStringIsEmpty(result)) {
        [MBProgressHUD showErrorMessage:@"没有查到相关单据"];
        return;
    } else {
        OrderDetailController * orderDetailVC = [[OrderDetailController alloc]init];
        orderDetailVC.orderNo = result;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}
-(void)homeViewConfirmSearhWithText:(NSString *)searchWord{
    __weak typeof(self) weakSelf = self;
    if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_CUSTOMER) {
        [[CustomerOrderManager shareCustomerOrderManager] getOrderNoByOrderNo:searchWord success:^(id  _Nonnull data) {
            [weakSelf handlerSearchResut:data];
        } fail:^(NSInteger code) {
            
        }];
    } else if ([[UserManager shareUserManager] getCurrentUserRole] == CURRENT_USER_ROLE_STAFF) {
        [[SiteOrderManager shareSiteOrderManager] getOrderNoByOrderNo:searchWord success:^(id  _Nonnull data) {
            [weakSelf handlerSearchResut:data];
        } fail:^(NSInteger code) {
            
        }];
    } else {
        [weakSelf handlerSearchResut:nil];
    }
}
-(void)homeViewSelectBannerAtIndex:(NSInteger)index{
    
}
-(void)homeViewSelectActionAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            TransportOrderViewController * transportOrderVC = [[TransportOrderViewController alloc]init];
            [self.navigationController pushViewController:transportOrderVC animated:YES];
        }
            break;
        case 2:
        {
            [[MainTabbarController shareMainTabbarController] setSelectedIndex:1];
        }
            break;
        case 3:
        {
            [[MainTabbarController shareMainTabbarController] setSelectedIndex:2];
        }
            break;
        case 4:
        {
            [[MainTabbarController shareMainTabbarController] setSelectedIndex:1];
        }
            break;
        case 5:
        {
            [[MainTabbarController shareMainTabbarController] setSelectedIndex:2];
        }
            break;
        default:
            break;
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
        HomeViewAction * action = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"下单说明"];
        HomeViewAction * action1 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"寄宠物"];
        HomeViewAction * action2 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"宠物店"];
        HomeViewAction * action3 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"我的订单"];
        HomeViewAction * action4 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"附近网点"];
        HomeViewAction * action5 = [[HomeViewAction alloc]initWithIconName:@"" actionTitle:@"订单跟踪"];
        _homeActionArray = @[action,action1,action2,action3,action4,action5];
    }
    return _homeActionArray;
}

@end
