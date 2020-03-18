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
#import "ContractViewController.h"

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
            ContractViewController * contractVC = [[ContractViewController alloc]init];
            contractVC.title = @"下单说明";
            contractVC.source = @"https://img.taochonghui.com/weapp/selfHelp.jpg";
            contractVC.type = ContractType_Image;
            [self.navigationController pushViewController:contractVC animated:YES];
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
        _imagePathArray = @[@"https://img.taochonghui.com/weapp/banner01.jpg",
                            @"https://img.taochonghui.com/weapp/banner02.jpg"];
    }
    return _imagePathArray;
}

-(NSArray<HomeViewAction *> *)homeActionArray{
    if(!_homeActionArray) {
        HomeViewAction * action = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Shuoming actionTitle:@"下单说明"];
        HomeViewAction * action1 = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Jichongwu actionTitle:@"寄宠物"];
        HomeViewAction * action2 = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Chongwudian actionTitle:@"宠物店"];
        HomeViewAction * action3 = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Dingdan actionTitle:@"我的订单"];
        HomeViewAction * action4 = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Fujin actionTitle:@"附近网点"];
        HomeViewAction * action5 = [[HomeViewAction alloc]initWithIconName:IconFont_Home_Zhuizong actionTitle:@"订单跟踪"];
        _homeActionArray = @[action,action1,action2,action3,action4,action5];
    }
    return _homeActionArray;
}

@end
