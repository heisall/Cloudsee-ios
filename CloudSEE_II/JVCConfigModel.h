//
//  JVCConfigModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>


static const  NSString *deviceBrowseModelType   = @"deviceBrowseModel";//设备浏览模式

enum NETLINGTYPE{
    
    NETLINTYEPE_WIFI_init = -1,
    NETLINTYEPE_WIFI      = 0,//无线
    NETLINTYEPE_3G        = 1 ,//3g
    NETLINTYEPE_UNCERTAIN = 2,//不确定
    NETLINTYEPE_NONET     = 3,//无网路
    
};

enum TYPELOGINTYPE
{
    TYPELOGINTYPE_ACCOUNT=1,//账号登录
    TYPELOGINTYPE_LOCAL=0,//非账号登录
};

enum ACCOUNTTYPEWATCH
{
    TYPE_DEVICE_NORMAL=0,//正常
    TYPE_DEVICE_ALL_ONLINE=1,//设备全在线
};

typedef NS_ENUM(int , TYPEINITSDK)
{
    TYPEINITSDK_DEFAULT = -1,//默认值
    TYPEINITSDK_SUCCESS = 0,//成功
    TYPEINITSDK_ERROR = 1,//失败
    TYPEINITSDK_SETERROR = 2,//配置域名（或IP）失败

};

typedef NS_ENUM(int , DeviceBrowseModel)
{
    DeviceBrowseModel_Single    = 0,//单设备
    DeviceBrowseModel_Mutal     = 1,//多设备
};

@interface JVCConfigModel : NSObject
{
    /**
     *  是否本地登录  1：账号登录（本地登录以及演示点登录）  其他：账号登录
     */
    int _bISLocalLoginIn;
    
    /**
     *  网络链接类型  1:3g
     */
    int _netLinkType;
    
    /**
     *  观看模式
     */
    int _iWatchType;
    
    /**
     *  是否为临时数据插入  yes:临时数据插入
     */
    BOOL tempModelInsert;
    
    /**
     *  初始化账号sdk是否正确  0:全部成功 1:注册Sdk失败  2:配置域名（或IP）失败
     */
    int  _bInitAccountSDKSuccess;
    
    /**
     *  是否有新版本
     */
    BOOL _bNewVersion;
    
    /**
     *  防护开关的状态
     */
    BOOL bSwitchSafe;
    
    /**
     *  声波配置是否开始广播的标志：YES:广播
     */
    BOOL isLanSearchDevices;
    
    int  iDeviceBrowseModel;//设备浏览模式
    BOOL isChina;           //YES:中国
    int  nCaptureMode;      //抓拍的模式
    BOOL isEnableAPModel;   //是否启用STA切换AP功能
}

/**
 程序的抓拍方式
 */
enum JVCConfigModelCaptureModeType{

    JVCConfigModelCaptureModeTypeDecoder = 0,  //解码抓拍
    JVCConfigModelCaptureModeTypeDevice  = 1,  //设备抓拍（主要应用于惠通设备，闪光灯抓拍）
};

@property(nonatomic,assign) int _bISLocalLoginIn;
@property(nonatomic,assign) int _netLinkType;
@property(nonatomic,assign) int _iWatchType;
@property(nonatomic,assign) BOOL tempModelInsert;
@property(nonatomic,assign) int _bInitAccountSDKSuccess;
@property(nonatomic,assign) BOOL _bNewVersion;
@property(nonatomic,assign) BOOL bSwitchSafe;
@property(nonatomic,assign) BOOL isLanSearchDevices;
@property(nonatomic,assign) int  iDeviceBrowseModel;
@property(nonatomic,assign) BOOL isChina;
@property(nonatomic,assign) int  nCaptureMode;
@property(nonatomic,assign) BOOL isEnableAPModel;

/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCConfigModel *)shareInstance;



@end
