//
//  JVCRGBHelper.m
//  JVCEditDevice
//  颜色助手类 主要作用是获取指定颜色的RGB值对象
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCRGBHelper.h"
#import "JVCRGBModel.h"
#import "JVCRGBColorMacro.h"


@interface JVCRGBHelper () {
    
    NSMutableDictionary *mdicRgbModelList;
}

@end

@implementation JVCRGBHelper

/**
 *  初始化颜色的辅助类
 *
 *  @return 颜色助手类对象
 */
-(id)init {
    
    if (self = [super init]) {
        
        mdicRgbModelList = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        [self initEditDeviceViewRgbColors];
        [self initDeviceListViewRgbColors];
        
    }

    return self;
}

/**
 *  初始化设备编辑界面的RGB集合
 */
-(void)initEditDeviceViewRgbColors{
    
    JVCRGBModel *green   = [[JVCRGBModel alloc] init];  //绿色
    green.r = 106.0f;
    green.g = 184.0f;
    green.b = 64.0f;
    
    JVCRGBModel *skyBlue = [[JVCRGBModel alloc] init];  //天蓝色
    skyBlue.r = 16.0f;
    skyBlue.g = 196.0f;
    skyBlue.b = 217.0f;
    
    JVCRGBModel *orange = [[JVCRGBModel alloc] init]; //橙色
    orange.r = 240.0f;
    orange.g = 137.0f;
    orange.b = 47.0f;
    
    JVCRGBModel *deepRed = [[JVCRGBModel alloc] init]; //深红
    deepRed.r = 232.0f;
    deepRed.g = 75.0f;
    deepRed.b = 80.0f;
    
    JVCRGBModel *yellow  = [[JVCRGBModel alloc] init];  //黄色
    yellow.r = 245.0f;
    yellow.g = 193.0f;
    yellow.b = 50.0f;
    
    
    JVCRGBModel *purple  = [[JVCRGBModel alloc] init]; //紫红
    purple.r = 153.0f;
    purple.g = 66.0f;
    purple.b = 138.0f;
    
    JVCRGBModel *editDeviceButtonFont  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    editDeviceButtonFont.r = 255.0f;
    editDeviceButtonFont.g = 254.0f;
    editDeviceButtonFont.b = 251.0f;
    

    
    [mdicRgbModelList setObject:orange  forKey:kJVCRGBColorMacroOrange];
    [mdicRgbModelList setObject:yellow  forKey:kJVCRGBColorMacroYellow];
    [mdicRgbModelList setObject:skyBlue forKey:kJVCRGBColorMacroSkyBlue];
    [mdicRgbModelList setObject:purple  forKey:kJVCRGBColorMacroPurple];
    [mdicRgbModelList setObject:deepRed forKey:kJVCRGBColorMacroDeepRed];
    [mdicRgbModelList setObject:green   forKey:kJVCRGBColorMacroGreen];
    [mdicRgbModelList setObject:editDeviceButtonFont forKey:kJVCRGBColorMacroEditDeviceButtonFont];
    
    [orange release];
    [yellow release];
    [skyBlue release];
    [purple release];
    [deepRed release];
    [green release];
}

/**
 *  初始化设备列表界面的RGB集合
 */
-(void)initDeviceListViewRgbColors{
    
    JVCRGBModel *white  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    white.r = 255.0f;
    white.g = 255.0f;
    white.b = 255.0f;
    
    [mdicRgbModelList setObject:white forKey:kJVCRGBColorMacroWhite];
    
    [white release];
}

/**
 *  根据key返回RGB对象
 *
 *  @param strkeyName 对象的键值
 *
 *  @return RGB对象
 */
-(id)objectForKeyName:(NSString const *)strkeyName{
    
    return [mdicRgbModelList objectForKey:strkeyName];
}


/**
 *  释放颜色助手类对象
 */
-(void)dealloc{

    [super dealloc];
}


@end
