//
//  ApplyCenterController.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyCenterController.h"
#import "ApplyCenterView.h"
#import "ApplyStaffController.h"
#import "ApplyStationController.h"

@interface ApplyCenterController () <ApplyCenterViewDelegate>
@property (nonatomic, strong) ApplyCenterView * applyCenterView;
@end

@implementation ApplyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"入驻申请";
    [self.view addSubview:self.applyCenterView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.applyCenterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - apply center view delegate
-(void)tapApplyCenterView:(ApplyCenterView *)view withType:(ApplyType)type{
    if (type == ApplyType_Station) {
        ApplyStationController * stationController = [[ApplyStationController alloc]init];
        [self.navigationController pushViewController:stationController animated:YES];
    } else if (type == ApplyType_Staff){
        ApplyStaffController * staffController = [[ApplyStaffController alloc]init];
        [self.navigationController pushViewController:staffController animated:YES];
    }
}

#pragma mark - setters and getters

-(ApplyCenterView *)applyCenterView{
    if (!_applyCenterView) {
        _applyCenterView = [[ApplyCenterView alloc]init];
        _applyCenterView.delegate = self;
    }
    return _applyCenterView;
}

@end
