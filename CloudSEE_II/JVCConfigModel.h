//
//  JVCConfigModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum NETLINGTYPE{
    
    NETLINTYEPE_WIFI=0,//无线
    NETLINTYEPE_3G,//3g
    NETLINTYEPE_UNCERTAIN,//不确定
    NETLINTYEPE_NONET,//无网路
    
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
}
@property(nonatomic,assign)int _bISLocalLoginIn;

@property(nonatomic,assign)int _netLinkType;

@property(nonatomic,assign)int _iWatchType;

@property(nonatomic,assign)BOOL tempModelInsert;

@property(nonatomic,assign)int _bInitAccountSDKSuccess;
/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCConfigModel *)shareInstance;

@end
