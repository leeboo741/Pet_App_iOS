//
//  TimeCountButton.m
//  Pet
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "TimeCountButton.h"

@interface TimeCountButton ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@property (nonatomic, assign) BOOL isTimeCounting; 
@property (nonatomic, assign) NSInteger currentTimeCount;
@property (nonatomic) dispatch_source_t gcdTimer;
@end

static NSInteger Max_Time = 60;

@implementation TimeCountButton

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.isTimeCounting = NO;
    self.fontSize = 14;
    self.layer.cornerRadius = 8;
    self.layer.borderColor = Color_gray_1.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.greaterThanOrEqualTo(self).offset(10);
        make.top.greaterThanOrEqualTo(self).offset(5);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.timeLabel.mas_right).offset(8);
    }];
}

-(void)dealloc{
    [self stopCount];
}

#pragma mark - private method

-(void)tapAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapTimeCountButton:)]) {
        [self.delegate tapTimeCountButton:self];
    } else {
        [self startCount];
    }
}

#pragma mark - public method

/**
 开始计时
 */
-(void)startCount{
    if (self.isTimeCounting) {
        return;
    }
    self.isTimeCounting = YES;
    self.currentTimeCount = Max_Time;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(startCountWithTimeCountButton:)]) {
        [self.delegate startCountWithTimeCountButton:self];
    }
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
/**
 结束计时
 */
-(void)stopCount{
    if (self.isTimeCounting) {
        self.isTimeCounting = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopCountWithTimeCountButton:)]) {
            [self.delegate stopCountWithTimeCountButton:self];
        }
        // 终止定时器
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}

#pragma mark - setters and getters
-(TimeCountState)state{
    if (self.isTimeCounting) {
        return TimeCountState_Counting;
    }
    return TimeCountState_StopCounting;
}
-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.timeLabel.font = kFontSize(self.fontSize);
    self.contentLabel.font = kFontSize(self.fontSize);
}
-(void)setCurrentTimeCount:(NSInteger)currentTimeCount{
    _currentTimeCount = currentTimeCount;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld",currentTimeCount];
}
-(void)setIsTimeCounting:(BOOL)isTimeCounting{
    _isTimeCounting = isTimeCounting;
    if (isTimeCounting) {
        [self setBackgroundColor:Color_gray_1];
        self.contentLabel.text = @"秒后重新获取";
    } else {
        [self setBackgroundColor:Color_white_1];
        self.timeLabel.text = @"";
        self.contentLabel.text = @"获取验证码";
    }
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
    }
    return _contentView;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}
@end
