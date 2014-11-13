//
//  JVCSystemConfigMacro.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

/**
 *  判刑是否是iphone5设备
 */
#define iphone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]



#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define LABEL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define LABEL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define IOS7    7.0

#define IOS8    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO

#define SETCOLOR(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

static NSString *const kAPPIDNUM  = @"583826804";
//腾讯云统计的key
static NSString *const kTencentKey  = @"IJI3ZDS167IB";

static const int  kOPENGLMAXCOUNT = 17;//opengl数量

static const int  KWINDOWSFLAG  = 1000000000;//tag

static const int OPENGLMAXCOUNT  = 16;//opengl显示最大值

static const NSString *DefaultUserName = @"abc";//默认用户名
static const NSString *DefaultPassWord = @"123";      //默认密码

static const NSString *DefaultHomeUserName = @"admin";//默认用户名
static const NSString *DefaultHomePassWord = @"123456";      //默认密码

static  const int KPredicateUserNameLegateAddNum            = 100;//正则校验用户名合法时返回值添加100

static const  int KUserNameMaxLength   =  28;//用户名最大长度
static const  int KPassWordMaxLength   =  20;//密码最大长度
static const  int KTextFieldLeftLabelViewWith   =  10;//textfield 左侧label的宽度

static const  int KDevicePassWordMaxLength   =  16;//设备密码最大长度
static const  int KDeviceUserNameMaxLength   =  16;//设备密码最大长度
static NSString const * FMDB_USERINF  = @"userInfoTable.sqlite";//数据库的名称

static const  int KDeviceMaxChannelNUM      =  64;//设备通道最大值
static const  int KLocalAddDeviceMaxNUM     =  4;//本地添加设备最大值

static const  int KDeviceMaxChannelNUM_64      =  64;//添加通道的最大值64

static const  NSString *kSAVEYSTNUM    = @"saveYStNum";//保存云视通的号

static const  NSString *kAPPWELCOME   = @"Welcomehelp";

static const  NSString *kAPPWELCOMEAlarmState   = @"kAPPWELCOMEAlarmState";//设备报警状态标识


#define RGBConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

#define SETLABLERGBCOLOUR(X,Y,Z) [UIColor colorWithRed:X/255.0 green:Y/255.0 blue:Z/255.0 alpha:1.0]

#define RGB_YUANCHENG_BTN_R   255.0
#define RGB_YUANCHENG_BTN_G   255.0
#define RGB_YUANCHENG_BTN_B   255.0

//--------------- 远程回放
#define RGB_YUANCHENG_COLOUM_R 82.0
#define RGB_YUANCHENG_COLOUM_G 32.0
#define RGB_YUANCHENG_COLOUM_B 51.0

#define RGB_YUANCHENG_LABLE_R   47.0
#define RGB_YUANCHENG_LABLE_G   71.0
#define RGB_YUANCHENG_LABLE_B   110.0

/**
 *  腾讯云统计界面的id
 */
static NSString *const kTencentKey_login                    = @"1001";  //登录界面的
static NSString *const kTencentKey_resign                   = @"1002";  //注册界面的
static NSString *const kTencentKey_bindEamil                = @"1003";  //绑定邮箱
static NSString *const kTencentKey_Demo                     = @"1004";  //demo
static NSString *const kTencentKey_getPw                    = @"1005";  //找回密码
static NSString *const kTencentKey_EditOldUserAndPassWord   = @"1006";  //修改老密码和老用户

static NSString *const kTencentKey_deviceList               = @"2001";//我的设备界面
static NSString *const kTencentKey_operationPlay            = @"2002";//播放界面
static NSString *const kTencentKey_selectChannels           = @"2003";//选中通道界面

static NSString *const kTencentKey_alarmList                = @"3001";//报警消息
static NSString *const kTencentKey_deviceConfig             = @"4001";//配置界面
static NSString *const kTencentKey_more                     = @"5001";//更多界面

static NSString *const kTencentKey_addDevieYst              = @"adddevieyst";//播放界面
static NSString *const kTencentKey_qrsacn                   = @"qrsacn";//二维码
static NSString *const kTencentKey_wireless                 = @"wireless";//无线局域网
static NSString *const kTencentKey_addvoliceDevie           = @"addvoliceDevie";//声波配置
static NSString *const kTencentKey_addscanLan               = @"scanlan";//局域网广播设备
static NSString *const kTencentKey_addIpDoamin              = @"addIpDoamin";//ip和域名添加设备
static NSString *const kTencentKey_editDeviceinfo           = @"editdeviceinfo";//编辑设备信息
static NSString *const kTencentKey_editDevicelicktype       = @"editDevicelicktype";//连接模式
static NSString *const kTencentKey_editchannelsinfo         = @"editchannelsinfo";//编辑通道信息
static NSString *const kTencentKey_editaddevicesafe         = @"addevicesafe";//添加远程回放的


static NSString *const kTencentEvent_login                  = @"1000001";//登录事件
static NSString *const kTencentEvent_login_sta              = @"1000001_1";//登录事件
static NSString *const kTencentEvent_login_end              = @"1000001_2";//登录事件

static NSString *const kTencentEvent_Locallogin             = @"1000002";//本地登录事件
static NSString *const kTencentEvent_Locallogin_start       = @"1000002_1";//本地登录事件开始
static NSString *const kTencentEvent_Locallogin_end         = @"1000002_2";//本地登录事件结束

static NSString *const kTencentEvent_resign                 = @"1000003";//注册
static NSString *const kTencentEvent_resign_start           = @"1000003_1";//注册事件开始
static NSString *const kTencentEvent_resign_end             = @"1000003_2";//注册事件结束

static NSString *const kTencentEvent_Demo                   = @"1000004";//演示点事件
static NSString *const kTencentEvent_Demo_start             = @"1000004_1";//演示点事件开始
static NSString *const kTencentEvent_Demo_end               = @"1000004_2";//演示点事件结束

static NSString *const kTencentEvent_getpw                  = @"1000005";//找回密码
static NSString *const kTencentEvent_getpw_start            = @"1000005_1";//找回密码开始
static NSString *const kTencentEvent_getpw_end              = @"1000005_2";//找回密码结束

static NSString *const kTencentEvent_DeviceManager          = @"3000001";//设备管理
static NSString *const kTencentEvent_DeviceManager_start    = @"3000001_1";//设备管理开始
static NSString *const kTencentEvent_DeviceManager_end      = @"3000001_2";//设备管理结束

static NSString *const kTencentEvent_LickType               = @"3000002";//连接模式
static NSString *const kTencentEvent_LickType_start         = @"3000002_1";//连接模式开始
static NSString *const kTencentEvent_LickType_end           = @"3000002_2";//连接模式结束

static NSString *const kTencentEvent_channelManager         = @"3000003";//通道管理
static NSString *const kTencentEvent_channelManager_start   = @"3000003_1";//通道管理开始
static NSString *const kTencentEvent_channelManager_end     = @"3000003_2";//通道管理结束

static NSString *const kTencentEvent_EditView               = @"3000004";//立即查看
static NSString *const kTencentEvent_EditView_start         = @"3000004_1";//立即查看开始
static NSString *const kTencentEvent_EditView_end           = @"3000004_2";//立即查看结束

static NSString *const kTencentEvent_safeManager            = @"3000005";//安全防护
static NSString *const kTencentEvent_safeManager_start      = @"3000005_1";//立即查看开始
static NSString *const kTencentEvent_safeManager_end        = @"3000005_2";//立即查看结束

static NSString *const kTencentEvent_AlarmDevieManage       = @"3000006";//第三方设备
static NSString *const kTencentEvent_AlarmDevieManage_start = @"3000006_1";//第三方设备开始
static NSString *const kTencentEvent_AlarmDevieManage_end   = @"3000006_2";//第三方设备结束

static NSString *const kTencentEvent_operationPlay          = @"8000001";//播放界面
static NSString *const kTencentEvent_operationPlay_start    = @"8000001_1";//播放界面开始
static NSString *const kTencentEvent_operationPlay_end      = @"8000001_2";//播放界面结束

static NSString *const kTencentEvent_operationAudio         = @"8000002";//音频监听
static NSString *const kTencentEvent_operationAudio_start   = @"8000002_1";//音频监听开始
static NSString *const kTencentEvent_operationAudio_end     = @"8000002_2";//音频监听结束

static NSString *const kTencentEvent_operationYT            = @"8000003";//云台
static NSString *const kTencentEvent_operationyt_start      = @"8000003_1";//云台开始
static NSString *const kTencentEvent_operationyt_end        = @"8000003_2";//云台结束

static NSString *const kTencentEvent_operationplaybac       = @"8000004";//远程回放
static NSString *const kTencentEvent_operationplaybac_start = @"8000004_1";//远程回放开始
static NSString *const kTencentEvent_operationplaybac_en    = @"8000004_2";//远程回放结束

static NSString *const kTencentEvent_operationCaptur        = @"8000005";//抓拍
static NSString *const kTencentEvent_operationCaptur_start  = @"8000005_1";//抓拍开始
static NSString *const kTencentEvent_operationCaptu_end     = @"8000005_2";//抓拍结束

static NSString *const kTencentEvent_operationTalk          = @"8000006";//对讲
static NSString *const kTencentEvent_operationTalk_start    = @"8000006_1";//对讲开始
static NSString *const kTencentEvent_operationtalk_end     = @"8000006_2";//对讲结束

static NSString *const kTencentEvent_operationVideo         = @"8000007";//录像
static NSString *const kTencentEvent_operationVideo_start   = @"8000007_1";//录像开始
static NSString *const kTencentEvent_operationVideo_end    = @"8000007_2";//录像结束

static NSString *const kTencentEvent_operationSteam         = @"8000008";//码流
static NSString *const kTencentEvent_operationSteam_start   = @"8000008_1";//码流开始
static NSString *const kTencentEvent_operationSteam_end    = @"8000008_2";//码流结束