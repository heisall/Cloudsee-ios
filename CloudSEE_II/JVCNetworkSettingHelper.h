//
//  JVCNetworkSettingHelper.h
//  CloudSEE_II
//  网络设置业务接口
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCConnectCallBackHelper.h"

@class JVCNetworkSettingHelper;


/**
 *  获取网络参数出错的回调
 *
 *  @param networkInfo 网络配置的信息
 */
typedef void (^JVCNetworkSettingErrorBlock)(int errorType);

/**
 *  获取设备连接信息的回调
 *
 *  @param networkInfo 网络配置的信息
 */
typedef void (^JVCNetworkSettingConnectResultBlock)(int connectResultType);

/**
 *  获取设备网络参数的回调
 *
 *  @param networkInfo 网络配置的信息
 */
typedef void (^JVCNetworkSettingGetNetworkInfoBlock)(NSMutableDictionary *networkInfo);

/**
 *  获取设备无线热点信息
 *
 *  @param SSIDList 设备收到的热点列表
 */
typedef void (^JVCNetworkSettingResultSSIDListBlock)(NSMutableArray *SSIDList);


@protocol JVCNetworkSettingHelperDeleagte <NSObject>

@required
/**
 *  连接的回调函数
 *
 *  @param connectResultType 连接信息的回调函数
 */
-(void)JVCNetworkSettingConnectResult:(int)connectResultType;

@end


@interface JVCNetworkSettingHelper : JVCConnectCallBackHelper<ystNetWorkHelpTextDataDelegate>{

    id<JVCNetworkSettingHelperDeleagte> networkSettingHelperDeleagte;

}

@property (nonatomic,assign) id<JVCNetworkSettingHelperDeleagte> networkSettingHelperDeleagte;

enum ErrorType{
    
    ErrorTypeReject     = 0,
    ErrorTypeNotSupport = 1,
};

@property(nonatomic,copy) JVCNetworkSettingErrorBlock          networkSettingErrorBlock;
@property(nonatomic,copy) JVCNetworkSettingGetNetworkInfoBlock networkSettingGetNetworkInfoBlock;
@property(nonatomic,copy) JVCNetworkSettingConnectResultBlock  networkSettingConnectResultBlock;
@property(nonatomic,copy) JVCNetworkSettingResultSSIDListBlock networkSettingResultSSIDListBlock;


/**
 *  设置有线连接（自动和手动切换）
 *
 *  @param nDHCP             是否自动获取
 *  @param strIp             ip地址
 *  @param strSubnetMask     子网掩码
 *  @param strDefaultGateway 默认网关
 *  @param strDns            域名
 */
-(void)setWiredConnectType:(int)nDHCP withIpAddress:(NSString *)strIp withSubnetMask:(NSString *)strSubnetMask withDefaultGateway:(NSString *)strDefaultGateway withDns:(NSString *)strDns;

/**
 *  配置设备的无线网络(老的配置方式)
 *
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param strWifiAuth     热点的认证方式
 *  @param strWifiEncryp   热点的加密方式
 */
-(void)setWifiConnectType:(NSString *)strSSIDName withSSIDPassWord:(NSString *)strSSIDPassWord withWifiAuth:(NSString *)strWifiAuth withWifiEncrypt:(NSString *)strWifiEncryp;

/**
 *  获取设备的WIFI信息
 */
-(void)refreshWifiListInfo;

/**
 *  打开设备的AP
 */
-(void)openDeviceWithAp;

@end
