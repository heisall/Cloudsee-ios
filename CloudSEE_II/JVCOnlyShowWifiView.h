//
//  JVCOnlyShowWifiView.h
//  CloudSEE_II
//  无线配置时，为无线连接状态无法配置无线，仅用于查看当前连接的信息
//  Created by chenzhenyang on 14-11-14.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVCOnlyShowWifiView;

typedef void (^JVCOnlyShowWifiViewDetailBlock)();

typedef void (^JVCOnlyShowWifiViewAPOpen)();

@interface JVCOnlyShowWifiView : UIView

@property (nonatomic,copy)JVCOnlyShowWifiViewDetailBlock onlyShowWifiViewDetailBlock;
@property (nonatomic,copy)JVCOnlyShowWifiViewAPOpen      onlyShowWifiViewAPOpen;

/**
 *  初始化SSID和密码的文本框 父类视图
 *
 *  @param frame    位置
 *  @param ssid     显示的SSID
 *  @param password 密码
 *
 *  @return 父类视图
 */
- (id)initWithFrame:(CGRect)frame withSSIDName:(NSString *)ssid withPassword:(NSString *)password;

@end
