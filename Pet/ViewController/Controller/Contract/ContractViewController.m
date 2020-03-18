//
//  ContractViewController.m
//  Pet
//
//  Created by mac on 2020/3/18.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ContractViewController.h"

@interface ContractViewController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UITextView * textView;
@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.title;
    // Do any additional setup after loading the view.
    if (self.type == ContractType_Image) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:self.scrollView];
        self.imageView = [[UIImageView alloc]init];
        [self.scrollView addSubview:self.imageView];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.source] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat scale = self.view.frame.size.width / image.size.width;
            self.imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height* scale);
            self.scrollView.contentSize = CGSizeMake(image.size.width* scale, image.size.height* scale);
        }];
    } else {
        self.textView = [[UITextView alloc]initWithFrame:self.view.frame];
        self.textView.editable = NO;
        [self.view addSubview:self.textView];
        self.textView.text = self.source;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:20],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    }
}

@end
