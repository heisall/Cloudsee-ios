//
//  JVCNetworkSettingViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@class JVCNetworkSettingViewController;

typedef void (^JVCNetworkSettingBackBlock)();

typedef void (^JVCNetworkSettingSetWiredConnectTypeBlock)(int nDHCP,NSString *strIp,NSString *strSubnetMask,NSString *strDefaultGateway,NSString *strDns);

typedef void (^JVCNetworkSettingSetWifiConnectTypeBlock)(NSString *strSSIDName ,NSString *strSSIDPassWord ,NSString *strWifiAuth,NSString *strWifiEncryp);

/**
 *  获取设备的无线热点
 */
typedef void (^JVCNetworkSettingGetSSIDListBlock)();

@interface JVCNetworkSettingViewController : JVCBaseWithGeneralViewController <UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    
    NSMutableDictionary *mdDeviceNetworkInfo;
}

@property (nonatomic,retain) NSMutableDictionary                       *mdDeviceNetworkInfo;
@property (nonatomic,copy)   JVCNetworkSettingSetWiredConnectTypeBlock  networkSettingSetWiredConnectTypeBlock;
@property (nonatomic,copy)   JVCNetworkSettingBackBlock                 networkSettingBackBlock;
@property (nonatomic,copy)   JVCNetworkSettingGetSSIDListBlock          networkSettingGetSSIDListBlock;
@property (nonatomic,copy)   JVCNetworkSettingSetWifiConnectTypeBlock   networkSettingSetWifiConnectTypeBlock;

/**
 *  刷新无线设备的热点信息
 *
 *  @param ssidListData ssid 数组
 */
-(void)refreshSSIDListData:(NSMutableArray *)ssidListData;

@end
