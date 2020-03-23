//
//  ApplyTimeCountCell.m
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyTimeCountCell.h"

static NSInteger Max_Time = 60;

@interface ApplyTimeCountCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UITextField *codeInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeCountButton;

@property (nonatomic, assign) BOOL isTimeCounting; // 倒计时中
@property (nonatomic, assign) NSInteger currentTimeCount;
@property (nonatomic) dispatch_source_t gcdTimer;
@end

@implementation ApplyTimeCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showFlag = YES;
    self.flagImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_NotNull, 15, Color_red_1)];
    self.codeInputTextField.delegate = self;
    self.timeCountButton.layer.cornerRadius = 8;
    self.timeCountButton.layer.borderColor = [UIColor colorWithHexString:@"F0F0F0"].CGColor;
    self.timeCountButton.layer.borderWidth = 1;
    [self.timeCountButton addTarget:self action:@selector(tapCountButton) forControlEvents:UIControlEventTouchUpInside];
    self.isTimeCounting = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    [self stopCount];
}
#pragma mark - private method

-(void)startCount{
    self.currentTimeCount = Max_Time;
    /** 创建定时器对象
     * para1: DISPATCH_SOURCE_TYPE_TIMER 为定时器类型
     * para2-3: 中间两个参数对定时器无用
     * para4: 最后为在什么调度队列中使用
     */
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    /** 设置定时器
     * para2: 任务开始时间
     * para3: 任务的间隔
     * para4: 可接受的误差时间，设置0即不允许出现误差
     * Tips: 单位均为纳秒
     */
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    /** 设置定时器任务
     * 可以通过block方式
     * 也可以通过C函数方式
     */
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_gcdTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentTimeCount = weakSelf.currentTimeCount - 1;
            if(weakSelf.currentTimeCount == 0) {
                [weakSelf stopCount];
            }
        });
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(_gcdTimer);
}

-(void)stopCount{
    if (self.isTimeCounting) {
        self.isTimeCounting = NO;
        // 终止定时器
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}

#pragma mark - textfield delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_delegate && [_delegate respondsToSelector:@selector(shouldChangeText:withTextField:atApplyTimeCountCell:)]) {
        return [_delegate shouldChangeText:text withTextField:textField atApplyTimeCountCell:self];
    }
    return YES;
}

#pragma mark - event action
-(void)tapCountButton{
    if (!self.isTimeCounting) {
        self.isTimeCounting = YES;
        [self startCount];
        if (_delegate && [_delegate respondsToSelector:@selector(tapTimeCountingAtApplyTimeCountCell:)]) {
            [_delegate tapTimeCountingAtApplyTimeCountCell:self];
        }
    }
}

#pragma mark - setters and getters
-(void)setCurrentTimeCount:(NSInteger)currentTimeCount{
    _currentTimeCount = currentTimeCount;
    [self.timeCountButton setTitle:[NSString stringWithFormat:@"%ld 秒后再次获取",currentTimeCount] forState:UIControlStateNormal];
}
-(void)setIsTimeCounting:(BOOL)isTimeCounting{
    _isTimeCounting = isTimeCounting;
    if (isTimeCounting) {
        [self.timeCountButton setBackgroundColor:Color_gray_1];
    } else {
        [self.timeCountButton setBackgroundColor:Color_white_1];
        [self.timeCountButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
-(void)setShowFlag:(BOOL)showFlag{
    self.flagImageView.hidden = !showFlag;
}

-(void)setCellValue:(NSString *)cellValue{
    self.codeInputTextField.text = cellValue;
}

-(void)setCellPlaceholder:(NSString *)cellPlaceholder{
    self.codeInputTextField.placeholder = cellPlaceholder;
}

@end
