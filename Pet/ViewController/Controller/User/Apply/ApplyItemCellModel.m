//
//  ApplyItemCellModel.m
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "ApplyItemCellModel.h"

@implementation ApplyItemCellModel
+(ApplyItemCellModel *)getCellModelWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value type:(ApplyItemCellType)type  showFlag:(BOOL)showFlag{
    ApplyItemCellModel * model = [[ApplyItemCellModel alloc]init];
    model.cellTitle = title;
    model.cellValue = value;
    model.cellPlaceholder = placeholder;
    model.showFlag = showFlag;
    model.type = type;
    return model;
}
@end
