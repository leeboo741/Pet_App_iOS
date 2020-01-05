//
//  TestShowBoxCell.m
//  Pet
//
//  Created by lee on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "TestShowBoxCell.h"
#import "MediaShowBox.h"

@interface TestShowBoxCell ()
@property (weak, nonatomic) IBOutlet MediaShowBox *mediaShowBox;

@end

@implementation TestShowBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.mediaShowBox.data = dataSource;
}

@end
