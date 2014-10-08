//
//  JVCDeviceListDeviceVIew.m
//  JVCEditDevice
//  设备列表中单个设备视图操作按钮
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCDeviceListDeviceVIew.h"



@interface JVCDeviceListDeviceVIew (){

    UILabel *deviceNameLbl;
    UILabel *deviceOnLineStatusLbl;
    UILabel *deviceWifiStatusLbl;

}
@end

@implementation JVCDeviceListDeviceVIew

static const CGFloat kIconBorderWidth         = 3.6f;
static const CGFloat kIconWithRightSpacting   = 8.0f;
static const CGFloat kLableWithLeftSpacting   = 10.0f;
//设置设备名称
static const CGFloat kDeviceNameLableFontSize = 12.0f;
static const CGFloat kDeviceNameLableHeight   = kDeviceNameLableFontSize + 4.0f;

//设置状态标签
static const CGFloat kStatusLableFontSize     = 8.0f;
static const CGFloat kStatusLableFontHeight   = kStatusLableFontSize +4.0f;
static const int     kIconImageViewTagValue   = 108;

-(void)dealloc{
    
    [super dealloc];
}

/**
 *  设置设备列表的单个设备的图标
 *
 *  @param iconImage       图标
 *  @param borderColor     边框颜色
 */
-(void)initWithLayoutView:(UIImage *)iconImage borderColor:(UIColor *)borderColor {
    
    [iconImage retain];
    [borderColor retain];
    
    //初始化图标
    UIImageView *iconImageView           = [[UIImageView alloc] init];
    iconImageView.backgroundColor        = [UIColor clearColor];
    [[iconImageView layer] setCornerRadius:iconImage.size.width/2.0];
    iconImageView.layer.borderColor      = borderColor.CGColor;
    iconImageView.layer.borderWidth      = kIconBorderWidth;
    iconImageView.clipsToBounds          = YES;
    iconImageView.tag                    = kIconImageViewTagValue;
    iconImageView.image                  = iconImage;
    iconImageView.frame = CGRectMake(self.frame.size.width - iconImageView.image.size.width - kIconWithRightSpacting, (self.frame.size.height - iconImageView.image.size.height)/2.0, iconImageView.image.size.width, iconImageView.image.size.height);
    [self addSubview:iconImageView];
    
    [iconImage release];
    [borderColor release];
    
    [iconImageView release];
}

/**
 *  初始化标签视图
 *
 *  @param titleFontColor 标签的字体颜色
 */
-(void)initWithTitleView:(UIColor *)titleFontColor {
    
   
    UIImageView *iconImageView = [self IconImageViewWithTag];
    
    if (iconImageView) {
        
        //初始化设备名称的标签
        deviceNameLbl = [[UILabel alloc] init];
        deviceNameLbl.backgroundColor = [UIColor clearColor];
        deviceNameLbl.textColor    =  titleFontColor;
        deviceNameLbl.textAlignment = NSTextAlignmentLeft;
        deviceNameLbl.frame = CGRectMake(kLableWithLeftSpacting,iconImageView.frame.origin.y , 100.0, kDeviceNameLableHeight);
        deviceNameLbl.font  = [UIFont systemFontOfSize:kDeviceNameLableFontSize];
        [self addSubview:deviceNameLbl];
        [deviceNameLbl release];
        
        //初始化设备在线状态标签
        deviceOnLineStatusLbl                 = [[UILabel alloc] init];
        deviceOnLineStatusLbl.backgroundColor = [UIColor clearColor];
        deviceOnLineStatusLbl.textColor       = titleFontColor;
        deviceOnLineStatusLbl.textAlignment   = NSTextAlignmentLeft;
        deviceOnLineStatusLbl.frame           = CGRectMake(deviceNameLbl.frame.origin.x,iconImageView.frame.origin.y + iconImageView.frame.size.height - kStatusLableFontHeight, iconImageView.frame.origin.x/2.0, kStatusLableFontHeight);
        deviceOnLineStatusLbl.font            = [UIFont systemFontOfSize:kStatusLableFontSize];
        [self addSubview:deviceOnLineStatusLbl];
        [deviceOnLineStatusLbl release];
        
        //初始化设备在线状态标签
        deviceWifiStatusLbl                 = [[UILabel alloc] init];
        deviceWifiStatusLbl.backgroundColor = [UIColor clearColor];
        deviceWifiStatusLbl.textColor       = titleFontColor;
        deviceWifiStatusLbl.textAlignment   = NSTextAlignmentLeft;
        deviceWifiStatusLbl.frame           = CGRectMake(deviceOnLineStatusLbl.frame.origin.x + deviceOnLineStatusLbl.frame.size.width,iconImageView.frame.origin.y + iconImageView.frame.size.height - kStatusLableFontHeight, iconImageView.frame.origin.x/2.0, kStatusLableFontHeight);
        deviceWifiStatusLbl.font            = [UIFont systemFontOfSize:kStatusLableFontSize];
        [self addSubview:deviceWifiStatusLbl];
        [deviceWifiStatusLbl release];
    }
}

/**
 *  设置设备的名称、状态、WI-FI 信息
 *
 *  @param name         设备的名称
 *  @param onlineStatus 在线状态
 *  @param wifiStatus   wifi状态
 */
-(void)setAtObjectTitles:(NSString *)name onlineStatus:(NSString *)onlineStatus wifiStatus:(NSString *)wifiStatus {
    
    [name retain];
    [onlineStatus retain];
    [wifiStatus retain];
    
    deviceNameLbl.text         = name;
    deviceOnLineStatusLbl.text = onlineStatus;
    deviceWifiStatusLbl.text   = wifiStatus;
    
    [wifiStatus release];
    [onlineStatus release];
    [name release];
}

/**
 *  获取图标的ImageView
 *
 *  @return 图标的ImageView
 */
-(UIImageView *)IconImageViewWithTag {
    
    return (UIImageView *)[self viewWithTag:kIconImageViewTagValue];
}

@end
