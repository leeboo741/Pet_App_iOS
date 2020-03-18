//
//  PrivacyPolicyView.m
//  EasyCRM
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 YWKJ. All rights reserved.
//

#import "PrivacyPolicyView.h"

@interface PrivacyPolicyView()
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIImageView *cancelImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *disagreeButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleView;

@end

@implementation PrivacyPolicyView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}


-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"PrivacyPolicyView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    _cancelImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
    [_cancelView addGestureRecognizer:tap];
}
- (IBAction)disagreeAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(privacyPolicyViewTapButtonAction:)]) {
        [_delegate privacyPolicyViewTapButtonAction:PrivacyPolicyButtonType_Disagree];
    }
    [self dismissPopView];
}
- (IBAction)agreeAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(privacyPolicyViewTapButtonAction:)]) {
        [_delegate privacyPolicyViewTapButtonAction:PrivacyPolicyButtonType_Agree];
    }
    [self dismissPopView];
}
-(void)cancel{
    if (_delegate && [_delegate respondsToSelector:@selector(privacyPolicyViewTapButtonAction:)]) {
        [_delegate privacyPolicyViewTapButtonAction:PrivacyPolicyButtonType_Cancel];
    }
    [self dismissPopView];
}

-(void)dismissPopView{
    [UIView animateWithDuration:0.15
                     animations:^{
                         // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         self.bgView.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                              self.bgView.transform = CGAffineTransformScale(
                                                                                             CGAffineTransformIdentity, 0.001, 0.001);
                                          }
                                          completion:^(BOOL finished) {
                                              // 第三步： 移除
                                              [self removeFromSuperview];
                                          }];
                     }];
}

-(void)showPopView{
    // 第一步：将view宽高缩至无限小（点）
    self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                   CGFLOAT_MIN, CGFLOAT_MIN);
    [UIView animateWithDuration:0.25
                     animations:^{
                         // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                         self.bgView.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              // 第三步： 以动画的形式将view恢复至原始大小
                                              self.bgView.transform = CGAffineTransformIdentity;
                                          } completion:nil];
                     }];
}

-(void)addPopViewToWindow{
    UIWindow * window = kKeyWindow;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [window addSubview:self];
    [window bringSubviewToFront:self];
    [self showPopView];
}

-(void)addPopViewToWindowWithContent:(NSString *)content{
    UIWindow * window = kKeyWindow;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [window addSubview:self];
    [window bringSubviewToFront:self];
    self.contentTextView.text = content;
    [self showPopView];
}

-(void)addPopViewToWindowWithHtml:(NSString *)HtmlStr title:(NSString *)title{
    UIWindow * window = kKeyWindow;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [window addSubview:self];
    [window bringSubviewToFront:self];
    NSData *data = [HtmlStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                               options:options
                                                    documentAttributes:nil
                                                                 error:nil];
    self.contentTextView.attributedText = html;
    self.contentTitleView.text = title;
    [self showPopView];
}

+(void)popPrivacyPolicyView{
    PrivacyPolicyView * privacyPolicyView = [[PrivacyPolicyView alloc]init];
    [privacyPolicyView addPopViewToWindow];
}
+(void)popPrivacePolicyViewWithContent:(NSString *)content{
    PrivacyPolicyView * privacyPolicyView = [[PrivacyPolicyView alloc] init];
    [privacyPolicyView addPopViewToWindowWithContent:content];
}


@end
