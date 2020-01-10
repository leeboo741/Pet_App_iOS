//
//  OrderStepItem.m
//  Pet
//
//  Created by lee on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "OrderStepItem.h"
#import "MediaShowBox.h"

@interface OrderStepItem ()<MediaShowBoxDataSource>
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *stepTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTimeLabel;
@property (weak, nonatomic) IBOutlet MediaShowBox *stepMediaShowBox;

@end

@implementation OrderStepItem

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

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDecoderView];
    }
    return self;
}

-(void)setUpDecoderView{
    [[NSBundle mainBundle] loadNibNamed:@"OrderStepItem" owner:self options:nil];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    self.countLabel.layer.cornerRadius = 20;
    self.countLabel.layer.borderColor = Color_blue_1.CGColor;
    self.countLabel.layer.borderWidth = 1;
    self.countLabel.textColor = Color_blue_1;
    self.countLabel.backgroundColor = Color_white_1;
    self.topLine.backgroundColor = Color_blue_1;
    self.bottomLine.backgroundColor = Color_blue_1;
    self.stepMediaShowBox.dataSource = self;
}

#pragma mark - media show box datasource
-(NSInteger)itemColumnCountForMediaShowBox:(MediaShowBox *)showBox{
    return 3;
}


#pragma mark - setters and getters

-(void)setType:(StepItemType)type{
    _type = type;
    switch (type) {
        case StepItemType_Top:
        {
            self.topLine.hidden = YES;
            self.bottomLine.hidden = NO;
        }
            break;
        case StepItemType_Bottom:
        {
            self.topLine.hidden = NO;
            self.bottomLine.hidden = YES;
        }
            break;
        default:
        {
            self.topLine.hidden = NO;
            self.bottomLine.hidden = NO;
        }
            break;
    }
}

-(void)setStepTitle:(NSString *)stepTitle{
    _stepTitle = stepTitle;
    self.stepTitleLabel.text = stepTitle;
}

-(void)setStepTime:(NSString *)stepTime{
    _stepTime = stepTime;
    self.stepTimeLabel.text = stepTime;
}

-(void)setMediaList:(NSArray *)mediaList{
    _mediaList = mediaList;
    if (mediaList == nil) mediaList = [NSArray array];
    NSMutableArray * dataArray = [NSMutableArray array];
    for (NSString * string in mediaList) {
        MediaShowItemModel * model = [[MediaShowItemModel alloc]init];
        model.resourcePath = string;
        [dataArray addObject:model];
    }
    self.stepMediaShowBox.data = dataArray;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)setStepIndex:(NSInteger)stepIndex{
    _stepIndex = stepIndex;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",stepIndex];
}
@end
