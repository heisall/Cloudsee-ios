//
//  JVCDeviceHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCDeviceMacro.h"

@interface JVCDeviceHelper : NSObject

enum ControlSwitchType
{
    DEVICE_ALARTM_SWITCH= 0,         //安全防护
    DEVICE_ALARTM_TIME_SWITCH = 1,   //防护的时间
    DEVICE_ALARTM_ANYTIME_SWITCH = 2,//全监控
    DEVICE_ALARTM_BABY_SWITCH = 3 ,   //baby模式
    DEVICE_TF_SWITCH = 4,            //TF卡存储
    
    DEVICE_Name =20     //baby模式
};

enum UPDATEDEVICEMATHTYPE{
    
    UPDATEDEVICEMATH_CMD_UPDATE=0,        //IPC升级命令
    UPDATEDEVICEMATH_CMD_EXIT=1,          //IPC升级退出
    UPDATEDEVICEMATH_DOWNLOAD_VALUE,      //IPC下载升级文件的进度
    UPDATEDEVICEMATH_WRITE_VALUE,         //IPC烧写文件的进度
    UPDATEDEVICEMATH_CMD_REBOOT           //IPC烧写完重启
    
};

enum DEVICEONLINESTATE
{
    DEVICEONLINESTATE_ONLINE        = 0,          //设备在线
    DEVICEONLINESTATE_OFFLINE       = 1,          //设备离线
    DEVICEONLINESTATE_UNKONWN       = 2,          //设备不确定
    DEVICEONLINESTATE_TIMEROUT      = 3,          //设备请求超时
    DEVICEONLINESTATE_ERROR         = 4,          //设备请求错误
    
};

/**
 *  获取设备服务类库对象（注需要帐号初始化SDK，帐号登陆
 之后相应的方法才能生效，
 否则提供的对应方法无法使用）
 *
 *  @return 设备服务类库对象
 */
+(JVCDeviceHelper *)sharedDeviceLibrary;

/**
 *	获取帐号下面的设备列表
 *
 *	@return	JSON格式的设备列表 注:返回为Nil 时，为请求超时
 */
-(NSDictionary *)getAccountByDeviceList;

/**
 *	获取帐号下面的所有通道信息
 *
 *	@return	JSON格式的设备列表 注:返回为Nil 时，为请求超时
 */
-(NSDictionary *)getAccountByChannelList;

/**
 *	获取帐号下面的设备的详细信息
 *
 *  @param  deviceGuidStr 云视通号
 *
 *	@return	JSON 按云视通一条设备详细信息 注:返回为Nil 时，为请求超时
 */
-(NSDictionary *)getDeviceInfoByDeviceGuid:(NSString *)deviceGuidStr;

/**
 *	修改设备的连接模式
 *
 *	@param	deviceGuidStr	云通号
 *	@param	linkType	连接模式（0-云通连接 1:IP连接）
 *	@param	userName	用户名
 *	@param	password	密码
 *	@param	ip	        连接的IP（linkType==1生效）
 *	@param	port	    连接的密码（linkType==1生效）
 *
 *	@return	{"mt":2014,"rt":0,"mid":1} rt为0时 操作成功，否则失败 (－5 请求超时)
 */
-(int)modifyDeviceLinkModel:(NSString *)deviceGuidStr linkType:(int)linkType userName:(NSString *)userName password:(NSString *)password ip:(NSString *)ip port:(NSString *)port;

/**
 *	修改本地连接信息
 *
 *	@param	deviceGuidStr  云通号
 *	@param	userName	   本地连接的用户名
 *	@param	password	   本地连接的密码
 *	@param	nikeName	   设备的昵称
 *
 *	@return	0标示成功 否则为错误代码
 */
-(int)modifyDeviceConnectInfo:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password nickName:(NSString *)nikeName;

/**
 *	添加设备的方法
 *
 *	@param	deviceGuidStr	云通号
 *	@param	userName	    用户名
 *	@param	password	    密码
 *
 *	@return	{"mt":2016,"rt":0,"mid":1} rt为0时 操作成功，否则错误代码
 */
-(int)addDeviceToAccount:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password;


/**
 *	删除帐号下面设备
 *
 *	@param	accountName	    删除设备所属的帐号
 *	@param	deviceGuidStr	云通号
 *
 *	@return	{"mt":2018,"rt":0,"mid":1} rt为0时 操作成功，否则失败,看错误码
 */
-(int)deleteDeviceInAccount:(NSString *)deviceGuidStr;


/**
 *	获取设备的温湿度（前多少个，默认前24个）
 *
 *	@param	deviceGuidStr	云通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)getTHListDataByYSTNumber:(NSString *)deviceGuidStr;


/**
 *	刷新帐号下设备信息的状态
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)refreshAccountNameByDeviceList;

/**
 *	获取评分、排名、同比增长数
 *
 *	@param	deviceGuidStr	云通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)getTHListMoreInfoByYSTNumber:(NSString *)deviceGuidStr;

/**
 *	刷新设备当前的温湿度数值
 *
 *	@param	accountName	    当前帐号
 *	@param	deviceGuidStr	云视通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)refreshDeviceTHValueByYSTNumber:(NSString *)deviceGuidStr;

/**
 *	控制设备的功能按钮（安全防护、时段、Baby模式）
 *
 *	@param	accountName	        帐户名
 *	@param	deviceGuidStr	    设备的云通号
 *	@param	operationInfoDict	控制的开关
 *  @param  switchState         开关的状态
 *  @param  updateText          更新的内容
 *
 *	@return	0：成功 1:失败
 */
-(int)controlDeviceOperationSwitchButton:(NSString *)accountName  deviceGuidStr:(NSString *)deviceGuidStr operationType:(int)operationType  switchState:(int)switchState updateText:(NSString *)updateText;

/**
 *  检查IPC是否有新版本
 *
 *  @param deviceType    设备类型
 *  @param deviceModel   设备型号
 *  @param deviceVersion 设备的版本
 *
 *  @return json格式 为空请求超时
 */
-(NSDictionary *)checkDeviceUpdateState:(int)deviceType deviceModel:(int)deviceModel deviceVersion:(NSString *)deviceVersion;

/**
 *	IPC远程升级的流程函数
 *
 *	@param	accountName	            更新IPC的帐号
 
 UPDATEDEVICEMATH_CMD_UPDATE=0,     //IPC升级命令
 UPDATEDEVICEMATH_CMD_EXIT=1,       //IPC升级退出
 UPDATEDEVICEMATH_DOWNLOAD_VALUE,   //IPC下载升级文件的进度
 UPDATEDEVICEMATH_WRITE_VALUE,      //IPC烧写文件的进度
 UPDATEDEVICEMATH_CMD_REBOOT        //IPC烧写完重启
 
 *	@param	deviceUpdateMathType	更新的业务编号
 *	@param	deviceGuidStr	        更新的IPC的云通号
 *	@param	updateText	            更新的文本（更新的URL）
 *
 *	@return	>=0成功 否则处理错误码
 */
-(int)deviceUpdateMath:(NSString *)accountName deviceUpdateMathType:(int)deviceUpdateMathType deviceGuidStr:(NSString *)deviceGuidStr updateText:(NSString *)updateText downloadSize:(int)downloadSize updateVer:(NSString *)updateVer;

/**
 *	修改设备的运视通连接的用户名和密码到设备服务器
 *
 *	@param	deviceGuidStr	运通号
 *	@param	userName	    用户名
 *	@param	password	    密码
 *
 *	@return	0 成功 否则
 */
-(int)modifyDevicePassWord:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password;


/**
 *  添加设备的通道接口 注：通道最多添加64个
 
 *   调试实例:
 
 {"pv":"1.0","dguid":"A230164761","dcs":4,"lpt":1,"mt":2039,"mid":81}
 
 {"mt":2040,"rt":0,"mid":81}
 
 *  @param deviceGuidStr     设备的云通号
 *  @param addChannelCount   添加的通道个数
 *
 *  @return 0 添加成功 （添加成功之后需要获取设备的通道信息，来获取新增的通道）
 */
-(int)addChannelToDevice:(NSString *)deviceGuidStr addChannelCount:(int)addChannelCount;


/**
 *  删除设备的指定通道
 *
 调试实例:
 
 {"pv":"1.0","dguid":"A230164761","dcn":2,"lpt":1,"mt":2041,"mid":82}
 
 {"mt":2042,"rt":0,"mid":81}
 
 *  @param deviceGuidStr 设备的运视通号
 *  @param channelValue  要删除的通道
 *
 *  @return 0 删除成功
 */
-(int)deleteChannelbyChannelValue:(NSString *)deviceGuidStr channelValue:(int)channelValue;

/**
 *  修改设备的通道名称
 *
 调试实例：
 
 {"pv":"1.0","dguid":"A230164761","dcn":2,"dcname":"woca","lpt":1,"mt":2045,"mid":88}
 
 {"mt":2046,"rt":0,"mid":88}
 
 *  @param deviceGuidStr     设备的运视通号
 *  @param channelNickName   通道的昵称
 *  @param channelValue      修改的通道号
 *
 *  @return 0 修改成功
 */
-(int)modifyDeviceChannelNickName:(NSString *)deviceGuidStr channelNickName:(NSString *)channelNickName channelValue:(int)channelValue;

/**
 *  获取指定设备的通道信息
 *
 *  @param deviceGuidStr 设备的运视通号
 *
 *  @return {"mt":2044,"rt":0,"mid":83,
 "clist":
 [
 {"dcn":1,"dcname":"A230164761_1"},
 {"dcn":2,"dcname":"woca"},
 {"dcn":3,"dcname":"A230164761_3"},
 {"dcn":4,"dcname":"A230164761_4"},
 {"dcn":5,"dcname":"A230164761_5"},
 {"dcn":6,"dcname":"A230164761_6"}
 ]}
 mt：0 获取成功,解析 clist为通道信息集合,否则按错误代码处理
 */
-(NSDictionary *)getDeviceChannelListData:(NSString *)deviceGuidStr;

/**
 *  绑定设备的Wi-Fi信息
 *
 *  @param deviceGuidStr 云视通号
 *  @param wifiFlag      1:有Wi-Fi 0:不支持
 *
 *  @return 成功返回 0
 */
-(int)bindWifiInfoToDevice:(NSString *)deviceGuidStr WifiFlag:(int)wifiFlag;

/**
 *  判断设备是否在线
 *
 *  @param strGUID 云视通号
 *
 *  @return
 */
-(int)predicateDeviceOnlineStateWithYST:(NSString *)deviceGuidStr;

/**
 *  获取添加设备的信息
 *
 *  @param deviceGuidStr 传入的云视通号
 *
 *  @return 收到的字典   dsls 设备在线状态， 1为在线  drn 设备的绑定状态  0 没有绑定  其他值有绑定
 */
- (NSDictionary *)getDeviceOnlineAndBindingStateInfoWithGuid:(NSString *)deviceGuidStr;

/**
 *	删除报警信息的列表
 *
 *	@param	deleteIndexValue 删除
 *
 *	@return	返回JK_ALARM_LISTCOUNT个
 */
-(id)deleteAlarmHorisyWithIndex:(NSString *)deleteDeviceGuid;

/**
 *	获取报警信息的列表
 *
 *	@param	startIndexValue	从哪一条开始
 *
 *	@return	返回JK_ALARM_LISTCOUNT个
 */
-(id)getAccountByDeviceAlarmList:(int)startIndexValue;

/**
 *  获取演示点信息
 *
 *  @return 演示点集合
 */
-(NSDictionary *)getDemoInfoList;

/**
 *	删除报警信息的列表
 *
 *	@param	deleteIndexValue 删除
 *
 *	@return	返回JK_ALARM_LISTCOUNT个
 */
-(id)deleteAllAlarmHorisy;

/**
 *  获取广告位图片
 *
 *  @param type 本地缓存版本号
 *
 *  @return 广告位的字典
 */
-(NSDictionary *)getAdverInfoList:(int)type;

/**
 *  添加设备的新接口
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *  @param ystNum   云视通号
 *  @param count    通道个数
 *
 *  @return 收到的字典
 */
- (id)newInterfaceAddDeviceWithUserName:(NSString *)userName
                               passWord:(NSString *)passWord
                                 ystNum:(NSString *)ystNum
                           channelCount:(int)count;

@end
