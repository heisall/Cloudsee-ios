//
//  JVCApConfigDeviceViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@protocol JVCApConfigDeviceViewControllerDelegate <NSObject>

/**
 *  获取设备的WIFI信息
 */
-(void)refreshWifiListInfo;

/**
 *  断开AP配置的连接
 */
-(void)disconnectAPSettingConnect;

/**
 *  开始配置
 *
 *  @param strWifiEnc      wifi的加密方式
 *  @param strWifiAuth     wifi的认证方式
 *  @param strWifiSSid     配置WIFI的SSID名称
 *  @param strWifiPassWord 配置WIFi的密码
 */
-(void)runApSetting:(NSString *)strWifiEnc strWifiAuth:(NSString *)strWifiAuth strWifiSSid:(NSString *)strWifiSSid strWifiPassWord:(NSString *)strWifiPassWord;

@end


@interface JVCApConfigDeviceViewController : JVCBaseWithGeneralViewController {

    id<JVCApConfigDeviceViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id<JVCApConfigDeviceViewControllerDelegate> delegate;

/**
 *  关闭获取无线设备列表信息的超时判断
 */
- (void)stopGetWifiListTimer;

/**
 *  刷新无线列表信息
 *
 *  @param wifiListData 无线列表信息
 */
-(void)refreshWifiViewShowInfo:(NSMutableArray*)wifiListData;

@end
