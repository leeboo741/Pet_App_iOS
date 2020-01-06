//
//  ApplyItemCellModel.h
//  Pet
//
//  Created by mac on 2020/1/6.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ApplyItemCellType) {
    ApplyItemCellType_Input = 0,
    ApplyItemCellType_TimeCount
};

@interface ApplyItemCellModel : NSObject
@property (nonatomic, copy) NSString * cellTitle;
@property (nonatomic, assign) BOOL showFlag;
@property (nonatomic, copy) NSString * cellValue;
@property (nonatomic, copy) NSString * cellPlaceholder;
@property (nonatomic, assign) ApplyItemCellType type;
+(ApplyItemCellModel *)getCellModelWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value type:(ApplyItemCellType)type showFlag:(BOOL)showFlag;
@end

NS_ASSUME_NONNULL_END
