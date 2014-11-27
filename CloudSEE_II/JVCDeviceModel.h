//
//  JVCDeviceModel.h
//  CloudSEE_II
//  设备的model类
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCDeviceModel : NSObject
{
   
    NSString *userName;         //用户名
    NSString *passWord;         //密码
    NSString *nickName;         //昵称
    NSString *yunShiTongNum;    //云视通号
    NSString *ip;               //ip
	NSString *port;             //端口号
    NSString *domainName;       //域名

    int  onLineState;               //1 在线   0：不在线  （云视通服务器状态）
    int  hasWifi;                   //0：没有wifi   1：有WiFi
    int  useWifi;                   //0  没有用WiFi  1 ：使用WiFi
    int  linkType;                  //设备连接模式  0 云视通连接  1：ip连接
    BOOL isCustomLinkModel;         //连接模式 //YES 客户定制IP连接 NO：非定制
    BOOL bIpOrDomainAdd;            //域名ip添加 //YES 域名ip NO：非域名ip
    BOOL isDeviceType;              //连接类型  NO：其他 YES:家用产品
    BOOL isDeviceSwitchAlarm;       //设备的安全防护开关
    BOOL bDeviceServiceOnlineState; //设备服务器状态
    
    //设备升级
    int  deviceModelInt;            //对应dstypeint
    int  deviceType;                //对应dtype
    NSString *deviceVersion;        //对应dsv
    NSString *deviceUpdateType;     //设备的类型dstype
}

enum kJVCDeviceModelDeviceType {
    
    kJVCDeviceModelDeviceType_HomeIPC = 2,
};

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *passWord;
@property(nonatomic,retain) NSString *nickName;
@property(nonatomic,retain) NSString *yunShiTongNum;
@property(nonatomic,retain) NSString *ip;
@property(nonatomic,retain) NSString *port;
@property(nonatomic,retain) NSString *domainName;       //域名

@property(nonatomic,assign) int  linkType;
@property(nonatomic,assign) int  onLineState;
@property(nonatomic,assign) int  hasWifi;
@property(nonatomic,assign) int  useWifi;
@property(nonatomic,assign) BOOL isCustomLinkModel;
@property(nonatomic,assign) BOOL bIpOrDomainAdd;   
@property(nonatomic,assign) BOOL isDeviceType;
@property(nonatomic,assign) BOOL isDeviceSwitchAlarm;
@property(nonatomic,assign) BOOL bDeviceServiceOnlineState;

@property(nonatomic,assign) int  deviceModelInt;
@property(nonatomic,assign) int  deviceType;
@property(nonatomic,retain)  NSString *deviceVersion;
@property(nonatomic,retain) NSString *deviceUpdateType;
/**
 *  初始化
 *
 *  @param info 数组信息
 *
 *  @return 初始化好的数据
 */
-(id)initWithDictionary:(NSDictionary *)info;

/**
 *  添加设备初始化model类型
 *
 *  @param info   传入的字典
 *  @param YSTNum 云视通号
 *
 *  @return 返回相应的设备model类型
 */
-(id)initWithADDDeviceDictionary:(NSDictionary *)info  YSTNUM:(NSString *)YSTNum;

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
                ipAddState:(BOOL)ipAddState;

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
        devicePassWord:(NSString *)devicePassWord;

@end
