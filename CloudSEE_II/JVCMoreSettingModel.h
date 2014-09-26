//
//  JVCMoreSettingModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCMoreSettingModel : NSObject
{
    
    NSString *iconImageName;    //应用的图标
    
    NSString *itemName;         //item的名称
    
    BOOL bNewState;             //是否显示新品 yes 显示  no不显示
    
    BOOL bBtnState;             //是否显示bug yes btn  no正常cell

    
}

@property(nonatomic,retain) NSString *iconImageName;
@property(nonatomic,retain) NSString *itemName;

@property(nonatomic,assign) BOOL bNewState;
@property(nonatomic,assign) BOOL bBtnState;

@end
