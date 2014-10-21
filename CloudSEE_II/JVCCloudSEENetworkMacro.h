//
//  JVCCloudSEENetworkMacro.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#ifndef CloudSEE_II_JVCCloudSEENetworkMacro_h
#define CloudSEE_II_JVCCloudSEENetworkMacro_h

#define CONNECTMAXNUMS 16

enum CONNECTRESULTTYPE{
    
    CONNECTRESULTTYPE_Succeed                        = 1,  //连接成功
    CONNECTRESULTTYPE_Disconnect                     = 2,  //断开连接成功
    CONNECTRESULTTYPE_RepeatConnect                  = 3,  //重复的连接
    CONNECTRESULTTYPE_ConnectFailed                  = 4,  //连接失败
    CONNECTRESULTTYPE_NoConnection                   = 5,  //没有连接
    CONNECTRESULTTYPE_AbnormalConnectionDisconnected = 6,  //连接异常断开
    CONNECTRESULTTYPE_ServiceStop                    = 7,  //服务停止
    CONNECTRESULTTYPE_DisconnectFailed               = 8,  //断开连接失败
    CONNECTRESULTTYPE_YstServiceStop                 = 9,  //云视通服务停止
    CONNECTRESULTTYPE_VerifyFailed                   = 10, //身份验证失败
    CONNECTRESULTTYPE_ConnectMaxNumber               = 11, //超过连接最大数
    
};


enum RemoteOperationType {
    
    RemoteOperationType_YTO                   = 0, //云台操作
    RemoteOperationType_CaptureImage          = 1, //抓拍
    RemoteOperationType_LocalVideo            = 2, //本地录像
    RemoteOperationType_AudioListening        = 3, //音频监听
    RemoteOperationType_VoiceIntercom         = 4, //语音对讲
    RemoteOperationType_RemotePlaybackSearch  = 5, //语音对讲
    RemoteOperationType_RemotePlaybackSEEK    = 6, //远程回放快进
    RemoteOperationType_TextChat              = 7, //文本聊天
    
    
};

enum DEVICEMODEL{
    
    DEVICEMODEL_SoftCard          = 0,         //软压缩卡
    DEVICEMODEL_DVR               = 1,         //DVR
    DEVICEMODEL_HardwareCard_950  = 2,         //硬压缩卡 950
    DEVICEMODEL_HardwareCard_951  = 3,         //硬压缩卡 951
    DEVICEMODEL_IPC               = 4,         //IPC
    
};

enum AudioType {
    
    AudioType_PCM   = 0, // 8bit  320
    AudioType_G711  = 1, // 16bit 640
    AudioType_AMR   = 2, // 16bit 960
};

enum AudioSize {
    
    AudioSize_PCM   = 320, // 8bit  320
    AudioSize_G711  = 640, // 16bit 640
    AudioSize_AMR   = 960, // 16bit 960
};

enum AudioBit {
    
    AudioBit_PCM   = 8, // 8bit  320
    AudioBit_G711  = 16, // 16bit 640
    AudioBit_AMR   = 16, // 16bit 960
};

enum VoiceInterStateType {
    
    VoiceInterStateType_Succeed  = 0,
    VoiceInterStateType_End      = 1,
    
};

enum RemotePlayBackVideoStateType {
    
    RemotePlayBackVideoStateType_Succeed = 100, //远程回放成功
    RemotePlayBackVideoStateType_Stop    = 101, //远程回放停止
    RemotePlayBackVideoStateType_End     = 102, //远程回放结束
    RemotePlayBackVideoStateType_Failed  = 103, //远程回放失败
    RemotePlayBackVideoStateType_TimeOut = 104, //远程回放超时
};

static  NSString  *  const KJVCYstNetWorkMacroRemotePlayBackChannel  = @"remoteChannel";  //远程回放检索出文件的通道
static  NSString  *  const KJVCYstNetWorkMacroRemotePlayBackDate     = @"time";           //远程回放检索出文件的日期
static  NSString  *  const KJVCYstNetWorkMacroRemotePlayBackDisk     = @"disk";           //远程回放检索出文件存放的磁盘

#define REQUESTTIMEOUTSECOND  0.5

#define AP_WIFI_USERNAME @"wifiUserName"
#define AP_WIFI_PASSWORD @"wifiPassWord"
#define AP_WIFI_QUALITY  @"wifiQuality"
#define AP_WIFI_KEYSTAT  @"wifiKeyStat"
#define AP_WIFI_IESTAT   @"wifiIestat"
#define AP_WIFI_ENC      @"wifiEnc"
#define AP_WIFI_AUTH     @"wifiAuth"


enum TextChatType {
    
    TextChatType_Succeed       = 82,
    TextChatType_Stop          = 83,
    TextChatType_paraInfo      = 1002,  //码流参数信息
    TextChatType_ApList        = 1003,  //AP热点
    TextChatType_ApSetResult   = 1004,  //配置AP的返回值
    TextChatType_NetWorkInfo   = 1005,  //网络参数信息
    TextChatType_setStream     = 1006,  //设置码流信息
    TextChatType_setTalkModel  = 1007,  //设置家用IPC的语音对讲模式
    TextChatType_setAlarmType  = 1008,  
    
};

enum NetWorkType {
    
    NetWorkType_Wired    = 0,
    NetWorkType_WiFi     = 2,
    
};


#define MOBILECHSECOND          2
#define MOBILECHDEFAULT         3
#define MOBILECHFRAMEBEGIN      @"[CH"
#define MOBILECHFRAMEEND        @"];"


typedef struct AudioFrame//音频数据结构
{
    int	iIndex;//音频数据序号
    char cb[12];//音频数据？
} AudioFrame;

static NSString const *kDeviceFrameFlagKey        =  @"MainStreamQos";  // 1:高清 2：标清 3：流畅 0:默认不支持切换码流
static NSString const *kDeviceTalkModelFlagKey    =  @"talkSwitch";     // 0:设备采集 不播放声音 1:设备播放声音，不采集声音

static NSString const *kDeviceAlarmType   =  @"type";     // 1:门磁  2手环


#endif
