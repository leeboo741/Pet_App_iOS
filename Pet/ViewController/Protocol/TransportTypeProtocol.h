//
//  TransportTypeProtocol.h
//  Pet
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TransportTypeProtocol <NSObject>

@required
-(NSString*)normalIconName;
-(NSString*)normalTitle;
-(UIColor*)normalColor;

@optional
-(NSString*)selectIconName;
-(NSString*)selectTitle;
-(UIColor*)selectColor;

-(NSString*)disableIconName;
-(NSString*)disableTitle;
-(UIColor*)disableColor;

-(BOOL)typeIsDisable;
-(BOOL)typeIsSelected;

@end

NS_ASSUME_NONNULL_END
