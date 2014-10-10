//
//  JVCDeviceListDeviceVIew.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseRgbBackgroundColorView.h"


@interface JVCDeviceListDeviceVIew : JVCBaseRgbBackgroundColorView 

/**
 *  设置设备列表的单个设备的图标
 *
 *  @param iconImage       图标
 *  @param titleFontColor  标签的字体颜色
 *  @param borderColor     边框颜色
 */
-(void)initWithLayoutView:(UIImage *)iconImage titleFontColor:(UIColor *)titleFontColor borderColor:(UIColor *)borderColor;

/**
 *  设置设备的名称、状态、WI-FI 信息
 *
 *  @param name         设备的名称
 *  @param onlineStatus 在线状态
 *  @param wifiStatus   wifi状态
 */
-(void)setAtObjectTitles:(NSString *)name onlineStatus:(NSString *)onlineStatus wifiStatus:(NSString *)wifiStatus;
@end
