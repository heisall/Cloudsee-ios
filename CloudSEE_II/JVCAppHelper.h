//
//  JVCAppHelper.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAppHelper : NSObject

/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCAppHelper *)shareJVCAppHelper;

/**
 *  获取指定索引View在矩阵视图中的位置
 *
 *  @param SuperViewWidth 父视图的宽
 *  @param viewCGRect     子视图的坐标
 *  @param nColumnCount   一列几个元素
 *  @param viewIndex      矩阵中的索引 （从1开始）
 */
-(void)viewInThePositionOfTheSuperView:(CGFloat)SuperViewWidth viewCGRect:(CGRect &)viewCGRect  nColumnCount:(int)nColumnCount viewIndex:(int)viewIndex;

/**
 *  复制View的函数
 *
 *  @param templateView 模板View
 *
 *  @return 复制出的View
 */
-(UIView *)duplicate:(UIView *)templateView;


/**
 *  获取当前Wifi的SSid （需要引入#import <SystemConfiguration/CaptiveNetwork.h>）
 *
 *  @return 当前手机连接的热点
 */
-(NSString *)currentPhoneConnectWithWifiSSID;

/**
 *  判断当前连接的设备的无线网络是否是家用设备的无线热点
 *
 *  @return YES：是 NO:否
 */
-(BOOL)currentPhoneConnectWithWifiSSIDIsHomeIPC;

@end
