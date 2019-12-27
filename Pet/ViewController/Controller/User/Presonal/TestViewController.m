//
//  TestViewController.m
//  Pet
//
//  Created by mac on 2019/12/27.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TestViewController.h"
#import "ImageAndVideoSelectBox.h"
#import "MediaSelectBoxView.h"

@interface TestViewController ()<MediaSelectBoxViewDelegate>
@property (nonatomic, strong)MediaSelectBoxView * box;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    [self.box mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"test self box frame:%@",NSStringFromCGRect(self.box.frame));
}

-(MediaSelectBoxView *)box{
    if (!_box) {
        _box = [[MediaSelectBoxView alloc]init];
        _box.delegate = self;
        [self.view addSubview:_box];
    }
    return _box;
}

@end
