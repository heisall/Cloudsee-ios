//
//  JVCMoreSettingModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    MoreSettingCellType_NO      =   0,//什么也没有的
    MoreSettingCellType_Btn     =   1,//按钮的
    MoreSettingCellType_Switch  =   2,//开关的
    MoreSettingCellType_index   =   3,//指示的
    
    MoreSettingCellType_AccountSwith =   4,//自定义的cell的swith事件


};

@interface JVCMoreSettingModel : NSObject
{
    
    NSString *iconImageName;    //应用的图标
    NSString *itemName;         //item的名称
    BOOL bNewState;             //是否显示新品 yes 显示  no不显示
    int bBtnState;             //是否显示bug yes btn  no正常cell
    BOOL bSwitchState;          //switch的状态
    
}

@property(nonatomic,retain) NSString *iconImageName;
@property(nonatomic,retain) NSString *itemName;

@property(nonatomic,assign) BOOL bNewState;
@property(nonatomic,assign) int bBtnState;
@property(nonatomic,assign) BOOL bSwitchState;
@end
