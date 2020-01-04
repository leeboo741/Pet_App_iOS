//
//  AssignmentsItemCell.m
//  Pet
//
//  Created by mac on 2020/1/4.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "AssignmentsItemCell.h"

@interface AssignmentsItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation AssignmentsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAssignmented:(BOOL)assignmented{
    _assignmented = assignmented;
    if (assignmented) {
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Selected, 32, Color_blue_1)];
    } else {
        self.iconImageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(IconFont_Unselected, 32, Color_blue_1)];
    }
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}


@end
