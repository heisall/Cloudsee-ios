//
//  JVCDeviceModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceModel.h"
#import "JVCDeviceMacro.h"

@implementation JVCDeviceModel

@synthesize  userName,passWord,ip,port,nickName,yunShiTongNum;

@synthesize linkType,onLineState,hasWifi,useWifi,isCustomLinkModel;

@synthesize domainName;
@synthesize bIpOrDomainAdd;
@synthesize isDeviceSwitchAlarm;
@synthesize isDeviceType;
@synthesize bDeviceServiceOnlineState;
@synthesize deviceType,deviceModelInt;
@synthesize deviceVersion;
@synthesize deviceUpdateType;

- (void)dealloc
{
    [deviceUpdateType release];
    deviceUpdateType = nil;
    
    [deviceVersion release];
    deviceVersion = nil;
    
    [userName release];
    userName = nil;
    
    [passWord release];
    passWord = nil;
    
    [ip release];
    ip = nil;
    
    [port release];
    port = nil;
    
    [nickName release];
    nickName = nil;
    
    [super dealloc];
}

/**
 *  初始化
 *
 *  @param info 数组信息
 *
 *  @return 初始化好的数据
 */
-(id)initWithDictionary:(NSDictionary *)info {
    
    self = [super init];
    
    if (self !=nil) {
        
        self.userName            = [info objectForKey:DEVICE_JSON_DVUSERNAME];
        self.passWord            = [info objectForKey:DEVICE_JSON_DVPASSWORD];
        self.yunShiTongNum       = [info objectForKey:DEVICE_JSON_DGUID];
        self.hasWifi             = [[info objectForKey:DEVICE_JSON_WIFI] intValue];
        self.nickName            = [info objectForKey:DEVICE_JSON_NICKNAME];
        self.linkType            = [[info objectForKey:DEVICE_JSON_LINKTYPE] intValue];
        self.ip                  = [info objectForKey:DEVICE_JSON_IP];
        
        self.deviceType            = [[info objectForKey:DEVICE_JSON_TYPE] intValue];
        self.deviceModelInt      = [[info objectForKey:DEVICE_JSON_SUB_TYPE_INT] intValue];
        self.deviceVersion       = [info objectForKey:DEVICE_JSON_SOFT_VERSION];
        self.deviceUpdateType       = [info objectForKey:DEVICE_JSON_SUB_TYPE];

        
        self.port                = [NSString stringWithFormat:@"%@",[info objectForKey:DEVICE_JSON_PORT]];
        self.isDeviceType        =[[info objectForKey:DEVICE_JSON_TYPE] intValue] == kJVCDeviceModelDeviceType_HomeIPC ? YES : NO;
        self.onLineState =[[info objectForKey:DEVICE_ONLINE_STATUS] intValue] == DEVICESTATUS_ONLINE?DEVICESTATUS_ONLINE:DEVICESTATUS_OFFLINE;
        self.bDeviceServiceOnlineState         =[[info objectForKey:DEVICE_DEVICE_ServiceState] intValue];

        if (self.isDeviceType) {
            
            self.isDeviceSwitchAlarm =[[info objectForKey:DEVICE_JSON_ALARMSWITCH] boolValue];
        }
        
        self.isCustomLinkModel   = self.linkType == CONNECTTYPE_IP ? TRUE : FALSE;
        

    }
    return self;

}

/**
 *  添加设备初始化model类型
 *
 *  @param info   传入的字典
 *  @param YSTNum 云视通号
 *
 *  @return 返回相应的设备model类型
 */
-(id)initWithADDDeviceDictionary:(NSDictionary *)info  YSTNUM:(NSString *)YSTNum{
    
    self = [super init];
    
    if (self !=nil) {
        
        NSDictionary *dInfo = [info objectForKey:DEVICE_JSON_DINFO];
        self.yunShiTongNum  = YSTNum.uppercaseString;
        self.nickName       = YSTNum.uppercaseString;
        self.userName       = [dInfo objectForKey:DEVICE_JSON_DVUSERNAME];
        self.passWord       = [dInfo objectForKey:DEVICE_JSON_DVPASSWORD];
        self.onLineState    = [[dInfo objectForKey:DEVICE_JSON_ONLINESTATE] intValue];
        self.hasWifi        = [[dInfo objectForKey:DEVICE_JSON_WIFI] intValue];
        self.onLineState    = DEVICESTATUS_ONLINE;
        self.hasWifi        = DEVICESTATUS_OFFLINE;
        self.linkType       = CONNECTTYPE_YST;
        
        self.isDeviceType        =[[dInfo objectForKey:DEVICE_JSON_TYPE] intValue] == kJVCDeviceModelDeviceType_HomeIPC ? YES : NO;
        self.deviceUpdateType       = [dInfo objectForKey:DEVICE_JSON_SUB_TYPE];
        self.deviceModelInt      = [[dInfo objectForKey:DEVICE_JSON_SUB_TYPE_INT] intValue];
        self.deviceVersion       = [dInfo objectForKey:DEVICE_JSON_SOFT_VERSION];
        if (self.isDeviceType) {
            
            self.isDeviceSwitchAlarm =[[dInfo objectForKey:DEVICE_JSON_ALARMSWITCH] boolValue];
        }
        self.bDeviceServiceOnlineState =[[dInfo objectForKey:DEVICE_DEVICE_ServiceState] intValue];
        self.deviceType            = [[info objectForKey:DEVICE_JSON_TYPE] intValue];
    }
    
    return self;
}


/**
 *  初始化设备
 *
 *  @param ystNum          云视通号
 *  @param deviceNickName  昵称
 *  @param deviceUserName  用户名
 *  @param devicePassWord  密码
 *  @param deviceIp        设备ip
 *  @param devicePort      设备端口号
 *  @param onlineState     在线状态
 *  @param linkType        连接模式
 *  @param hasWifiValue    wifi
 *  @param DeviceLickModel 用户修改状态
 *
 *  @return 设备对象
 */
- (id)initDeviceWithYstNum:(NSString *)ystNum
                  nickName:(NSString *)deviceNickName
            deviceUserName:(NSString *)deviceUserName
            devicePassWord:(NSString *)devicePassWord
                  deviceIP:(NSString *)deviceIp
                devicePort:(NSString *)devicePort
         deviceOnlineState:(int)onlineState
            deviceLinkType:(int)linkType
             deviceHasWifi:(int)hasWifiValue
  devicebICustomLinckModel:(BOOL)DeviceLickModel
                ipAddState:(BOOL)ipAddState
{
    self = [super init];
    
    if (self !=nil) {
        
        self.yunShiTongNum  = ystNum;
        self.nickName       = deviceNickName;
        self.userName       = deviceUserName;
        self.passWord       = devicePassWord;
        self.onLineState    = onlineState;
        self.hasWifi        = hasWifiValue;
        if (ipAddState) {
            self.ip             = [[JVCSystemUtility shareSystemUtilityInstance] getIPAddressForHostString:deviceIp];
            self.linkType       = CONNECTTYPE_IP;

        }else{
            self.ip             = deviceIp;
            self.linkType       = CONNECTTYPE_YST;

        }
        self.port           = devicePort;
        self.onLineState    = DEVICESTATUS_ONLINE;
        self.hasWifi        = DEVICESTATUS_OFFLINE;
        self.isCustomLinkModel = DeviceLickModel;
        self.bIpOrDomainAdd = ipAddState;
    }
    
    return self;
}


/**
 *  初始化设备
 *  @param deviceUserName  用户名
 *  @param devicePassWord  密码
 *  @param deviceIp        设备ip
 *  @param devicePort      设备端口号
 *  @return 设备对象
 */
- (id)initDeviceWithIP:(NSString *)deviceIp
            devicePort:(NSString *)devicePort
            deviceUserName:(NSString *)deviceUserName
            devicePassWord:(NSString *)devicePassWord
{
    self = [super init];
    
    if (self !=nil) {
        
        self.yunShiTongNum  = deviceIp;
        self.nickName       = deviceIp;
        self.userName       = deviceUserName;
        self.passWord       = devicePassWord;
        self.ip             = [[JVCSystemUtility shareSystemUtilityInstance] getIpOrNetHostString:deviceIp];
        self.port           = devicePort;
        self.onLineState    = DEVICESTATUS_ONLINE;
        self.hasWifi        = DEVICESTATUS_OFFLINE;
        self.linkType       = CONNECTTYPE_IP;
        self.isCustomLinkModel = 1;
        self.bIpOrDomainAdd = YES;
    }
    
    return self;
}


@end
