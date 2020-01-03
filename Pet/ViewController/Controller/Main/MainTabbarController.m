//
//  MainTabbarController.m
//  Pet
//
//  Created by mac on 2019/12/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "MainTabbarController.h"
#import "HomeViewController.h"
#import "TransportOrderViewController.h"
#import "StationListViewController.h"
#import "CustomerCenterController.h"
#import "StationCenterController.h"
#import "SiteCenterController.h"
#import "UITabbarController+ChangeViewControllers.h"

@interface MainTabbarController ()
@property (nonatomic, strong) NSArray * viewDataSource;
@end

@implementation MainTabbarController

SingleImplementation(MainTabbarController)

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initTabbar];
        [[GlobalDataManager shareGlobalDataManager] setData:self withKey:GLOBAL_DATA_KEY_MAINTABBAR];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UserManager shareUserManager]registerUserManagerNotificationWithObserver:self notificationName:USER_CHANGE_NOTIFICATION_NAME action:@selector(changeUser:)];
    [[UserManager shareUserManager]registerUserManagerNotificationWithObserver:self notificationName:USER_ROLE_CHANGE_NOTIFICATION_NAME action:@selector(changeRole:)];
}

-(void)dealloc{
    [[UserManager shareUserManager]removeObserverForUserManager:self notificationName:USER_CHANGE_NOTIFICATION_NAME];
    [[UserManager shareUserManager]removeObserverForUserManager:self notificationName:USER_ROLE_CHANGE_NOTIFICATION_NAME];
}

#pragma mark - notification

-(void)changeUser:(id)notificationObj{
    
}

-(void)changeRole:(NSNotification *)notificationObj{
    USER_ROLE role = [[notificationObj.userInfo objectForKey:@"data"] integerValue];
    UINavigationController * navi = [self getNaviControllerWithViewController:[self getCenterViewControllerWithUserRole:role]];
    
    [self setTabbarItemInfoWithViewController:navi title:@"中心" iconFontName:IconFont_Pet];
    [self replaceViewControllerAtIndex:2 withViewController:navi];
}

#pragma mark - private method

-(void)initTabbar{
    self.viewControllers = self.viewDataSource;
}

-(void)setTabbarItemInfoWithViewController:(UIViewController *)viewController title:(NSString *)title iconFontName:(NSString *)iconFontName{
    viewController.title = title;
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage iconWithInfo:TBCityIconInfoMake(iconFontName, 40, Color_gray_2)];
    viewController.tabBarItem.selectedImage = [UIImage iconWithInfo:TBCityIconInfoMake(iconFontName, 40, Color_blue_1)];
}

-(UINavigationController *)getNaviControllerWithViewController:(UIViewController*)viewController{
    UINavigationController * naviController = [[UINavigationController alloc]initWithRootViewController:viewController];
    return naviController;
}

-(UIViewController *)getCenterViewControllerWithUserRole:(USER_ROLE)role{
    UIViewController * centerViewController;
    if (role == USER_ROLE_CUSTOMER) {
        centerViewController = [[CustomerCenterController alloc]init];
    } else if (role == USER_ROLE_BUSINESS) {
        centerViewController = [[StationCenterController alloc]init];
    } else if (role == USER_ROLE_MANAGER || role == USER_ROLE_SERVICE || role == USER_ROLE_DRIVER) {
        centerViewController = [[SiteCenterController alloc]init];
    } else {
        centerViewController = [[UIViewController alloc]init];
    }
    return centerViewController;
}


#pragma mark - setters and getters
-(NSArray *)viewDataSource{
    if (!_viewDataSource) {
        HomeViewController * homeViewController = [[HomeViewController alloc]init];
        UINavigationController * homeNavi = [self getNaviControllerWithViewController:homeViewController];
        [self setTabbarItemInfoWithViewController:homeNavi title:@"首页" iconFontName:IconFont_Home];
        
        StationListViewController * stationListVC = [[StationListViewController alloc]init];
        UINavigationController * stationNavi = [self getNaviControllerWithViewController:stationListVC];
        [self setTabbarItemInfoWithViewController:stationNavi title:@"驿站" iconFontName:IconFont_Station];
        
        UIViewController * centerViewController = [self getCenterViewControllerWithUserRole:[[UserManager shareUserManager] getUserRole]];
        UINavigationController * centerNavi = [self getNaviControllerWithViewController:centerViewController];
        [self setTabbarItemInfoWithViewController:centerNavi title:@"中心" iconFontName:IconFont_Pet];
        
        _viewDataSource = @[homeNavi, stationNavi, centerNavi];
    }
    return _viewDataSource;
}

@end
