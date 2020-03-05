//
//  TimeCountButton.m
//  Pet
//
//  Created by mac on 2020/3/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "TimeCountButton.h"

@interface TimeCountButton ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, assign) BOOL isTimeCounting; //
@property (nonatomic, assign) NSInteger currentTimeCount;
@property (nonatomic) dispatch_source_t gcdTimer;
@end

@implementation TimeCountButton


@end
