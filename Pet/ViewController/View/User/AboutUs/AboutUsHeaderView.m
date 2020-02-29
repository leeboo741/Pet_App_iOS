//
//  AboutUsHeaderView.m
//  Pet
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AboutUsHeaderView.h"

@interface AboutUsHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUsHeaderView
#pragma mark - life cycle

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
    [[NSBundle mainBundle] loadNibNamed:@"AboutUsHeaderView" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.versionLabel.text = [NSString stringWithFormat:@"For iphone version:%@",kAppVersion];
}



@end
