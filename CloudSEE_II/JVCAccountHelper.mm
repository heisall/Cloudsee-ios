//
//  JVBAccountHelper.m
//  iBaby
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAccountHelper.h"
#import "JVCAccountInterface.h"
#import "JVCSystemUtility.h"
#import "JSONKit.h"
#import "JVCLogHelper.h"

@implementation JVCAccountHelper

@synthesize delegate;

static JVCAccountHelper *sharedjvcAccountHelper = nil;

char outAccountSessionBuffer[40];


#define CONNECTTIMEOUTSECOND 10
#define RQCONNECTTIMEOUTSECOND 10

#define KSuccess 0

-(id)init{
    
    if (self=[super init]) {
        
    }
    
    return self;
}

/**
 *  获取帐号中间类对象
 *
 *  @return 帐号库对象
 */
+(JVCAccountHelper *)sharedJVCAccountHelper{
    
    @synchronized(self){
        
        if (sharedjvcAccountHelper==nil) {
            
            sharedjvcAccountHelper=[[self alloc] init];
            
            return sharedjvcAccountHelper;
        }
    }
    
    return sharedjvcAccountHelper;
    
}

/**
 *  模式重写对象创建方法
 *
 *  @param zone 任何默认对内存的操作都是在Zone上进行的，确保只能创建一次
 *
 *  @return 单利对象
 */
+(id)allocWithZone:(struct _NSZone *)zone{
    
    @synchronized(self){
        
        if (sharedjvcAccountHelper == nil) {
            
            sharedjvcAccountHelper = [super allocWithZone:zone];
            
            return sharedjvcAccountHelper;
        }
    }
    
    return nil;
}

/**
 *  注册帐号的SDK，使用帐号库提供的函数，必须确保SDK注册成功
 *
 *  @param sdkLogPath                       帐号库存放日志文件的路径 如果没写在缓存文件夹里面
 *  @param channelServerAddressStr          短连接的服务器地址
 *  @param onlineServerAddressStr           上线的服务器地址
 *  @param islocalCheck                     TRUE:忽略本地缓存解析IP,为TRUE的时候不会在调用初始化SDK和设置超时的函数
 *
 *  @return  0:全部成功 1:注册Sdk失败  2:配置域名（或IP）失败
 */
-(int)InitSdk:(NSString *)sdkLogPath  channelServerAddressStr:(NSString *)channelServerAddressStr onlineServerAddressStr:(NSString *)onlineServerAddressStr  islocalCheck:(BOOL)islocalCheck isSetAddress:(BOOL)isSetAddress{
    
    if (islocalCheck) {
        
        bool ConfigServerAddressResult=ConfigServerAddress_C([channelServerAddressStr UTF8String],[onlineServerAddressStr UTF8String]);
        
        if (!ConfigServerAddressResult) {
            
            return 2;
        }
        
        return SUCCESS;
    }
    
    bool initSdkResult=InitSDK_C((char *)[sdkLogPath UTF8String]);
    
    if (!initSdkResult) {
        
        return 1;
    }
    
    
    if (isSetAddress) {//SetServerIP_C 设置服务器的IP地址，不能为域名
        
        SetServerIP_C([channelServerAddressStr UTF8String], [onlineServerAddressStr UTF8String]);
        
        return SUCCESS;
    }
    //ConfigServerAddress_C 设置服务器的地址，但是这个接口可以传ip也可以传域名
    bool ConfigServerAddressResult=ConfigServerAddress_C([channelServerAddressStr UTF8String],[onlineServerAddressStr UTF8String]);
    
    
    if (!ConfigServerAddressResult) {
        
        return 2;
    }
    
//    SetTimeoutSecond_C(CONNECTTIMEOUTSECOND,RQCONNECTTIMEOUTSECOND);
    
    DDLogVerbose(@"%s---------initAccountSdkEnd.",__FUNCTION__);
    
    return SUCCESS;
    
}



/**
 *	释放帐号SDK
 */
-(void)UnInitSDK{
    
    UnInitSDK_C();
    
}

/**
 *  设置帐号SDK的连接和请求的超时时间（单位是s）
 *
 *  @param connectTimeOut   连接的的超时时间(>0有效，默认设置5s)
 *  @param rqconnectTimeOut 请求的超时时间（>0有效,默认设置5s）
 */
-(void)setTimeoutSecond:(int)connectTimeOut rqconnectTimeOut:(int)rqconnectTimeOut{
    
    if (connectTimeOut<=0||rqconnectTimeOut<=0) {
        
        return;
    }
    
    SetTimeoutSecond_C(connectTimeOut,rqconnectTimeOut);
    
}

/**
 *	判断用户名是否存在
 *
 *	@param	userName	注册的用户名
 *
 *	@return	USER_HAS_EXIST		= 2,			//用户已经存在
 USER_NOT_EXIST		= 3,			//用户不存在
 */
-(int)IsUserExist:(NSString *)userName{
    
    return IsUserExist_C([userName UTF8String]);
}


/**
 *	注册帐号接口
 *
 *	@param	userName	用户名
 *	@param	passWord	密码
 *  @param  appTypeName 应用程序的名称 例如NVSIP
 *
 *	@return 成功返回0
 */
-(int)UserRegister:(NSString *)userName passWord:(NSString *)passWord appTypeName:(const NSString *)appTypeName{
    
    
    int resultValue=UserRegister_C([userName UTF8String],[passWord UTF8String],[appTypeName UTF8String]);
    
    return resultValue;
    
}

/**
 *  绑定用户的邮箱
 *
 *  @param securityMail 邮箱
 *
 *  @return 成功返回0
 */
-(int)bindMailToAccount:(NSString *)securityMail{
    
    
    return BindMailOrPhone_C([securityMail UTF8String]);
    
}

/**
 *  判断用户密码强度
 *
 *  @param userName 登陆的用户名
 *
 *  @return 成功返回0 ,119是用户的新密码加密规则，调用UserLogin接口登陆
 118是用户的老密码加密规则调用OldUserLogin接口登陆
 */
-(int)JudgeUserPasswordStrength:(NSString *)userName{
    
    return JudgeUserPasswordStrength_C([userName UTF8String]);
}

/**
 *	登陆
 *
 *	@param	username	用户名
 *	@param	passWord	密码
 *
 *	@return	成功返回0
 */
-(int)OldUserLogin:(NSString *)username passWord:(NSString *)passWord{
    
    return OldUserLogin_C([username UTF8String],[passWord UTF8String]);
    
}

/**
 *	登陆
 *
 *	@param	username	用户名
 *	@param	passWord	密码
 *
 *	@return	成功返回0
 */
-(int)oldUserLogin:(NSString *)username passWord:(NSString *)passWord{
    
    return OldUserLogin_C([username UTF8String],[passWord UTF8String]);
    
}

/**
 *	登陆
 *
 *	@param	username	用户名
 *	@param	passWord	密码
 *
 *	@return	成功返回0
 */
-(int)UserLogin:(NSString *)username passWord:(NSString *)passWord {
    
    return UserLogin_C([username  UTF8String],[passWord UTF8String]);
    
}

/**
 *  整合后的登录接口
 *
 *  @param username     用户名
 *  @param passWord     密码
 *  @param tokenStr     token
 *  @param languageType language
 *  @param alarmFlag    报警
 *
 *  @return 0 成功  1其他
 */
-(int)userLoginV2:(NSString *)username
         passWord:(NSString *)passWord
      tokenString:(NSString *)tokenStr
     languageType:(int)languageType
        alarmFlag:(int)alarmFlag{
    
    C_CLIENT_INFO clientIfo;
    memset(clientIfo.moblie_id, 0, 80);
    memcpy(clientIfo.moblie_id, [tokenStr UTF8String], strlen([tokenStr UTF8String]));
    clientIfo.terminal_type=IPHONE_CLIENT;
    clientIfo.language_type=languageType;
    clientIfo.alarm_flag = alarmFlag;
    return  UserLoginV2_C([username UTF8String],
                      [passWord UTF8String],clientIfo);

}

/**
 *  获取账号的sessionkey
 *
 *  @return nil 获取失败  其他的就是他的值
 */
- (id)getAccountSessionKey
{
    memset(outAccountSessionBuffer, 0, sizeof(outAccountSessionBuffer));
    
    int result = GetSession_C(outAccountSessionBuffer);
    
    if (result != KSuccess ) {
        
        return nil;
    }
    
    if (strlen(outAccountSessionBuffer)<=0) {
        
        return nil;
    }
    
    NSData *responseData=[NSData dataWithBytes:outAccountSessionBuffer length:strlen(outAccountSessionBuffer)];
    
    return [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];

}

/**
 *  修改已注册非规范用户名及密码
 *
 *  @param newUserName 新用户
 *  @param newPassword 新密码
 *
 *  @return 成功返回0
 */
-(int)ResetUserNameAndPassword:(NSString *)newUserName newPassword:(NSString *)newPassword{
    
    return ResetUserNameAndPassword_C([newUserName UTF8String], [newPassword UTF8String]);
}




/**
 *	登出
 *
 *	@return	成功返回0
 */
-(int)UserLogout{
    
    return UserLogout_C();
    
}

/**
 *  修改符合用户规则但帐户使用老密码加密规则
 *
 *  @param newPassword 新密码
 *
 *  @return 成功返回0
 */
-(int)ResetUserPassword:(NSString *)newPassword username:(NSString *)username{
    
    return ResetUserPassword_C([newPassword UTF8String],[username UTF8String]);
    
}

/**
 *	修改用户密码
 *
 *	@param	oldPassword	旧密码
 *	@param	newPassWord	新密码
 *
 *	@return	成功返回0
 */
-(int)ModifyUserPassword:(NSString *)oldPassword newPassWord:(NSString *)newPassWord {
    
    
    return ModifyUserPassword_C([oldPassword UTF8String],[newPassWord UTF8String]);
}

/**
 *	维持在线心跳
 *
 *	@param	tokenStr	  消息推送的唯一标示
 *  @param	languageType  中文 0  英文 1
 *
 *	@return	成功返回0
 */
-(int)keepOnline:(NSString *)tokenStr languageType:(int)languageType{
    
    RegisterServerPushFunc_C(ServerPushCallBack);
    
//    C_CLIENT_INFO clientIfo;
//    
//    memset(clientIfo.moblie_id, 0, 80);
//    memcpy(clientIfo.moblie_id, [tokenStr UTF8String], strlen([tokenStr UTF8String]));
//    
//    clientIfo.terminal_type=IPHONE_CLIENT;
//    clientIfo.language_type=languageType;
//    
//    ReportClientPlatformInfo_C(clientIfo);
    
    
    return Online_C(clientOnLine);
    
}

/**
 *  获取帐号系统的报警开关
 *
 *  @return @return	ALARM_ON  = 0, 打开
 ALARM_OFF = 1, 关闭
 */
-(int)getAlarmStateInt{
    
    int resultValue=-1;
    
    GetCurrentAlarmFlag_C(&resultValue);
    
    return resultValue;
}

/**
 *	关掉帐号重连的心跳
 */
-(void)stopServerTimer{
    
    StopHeartBeat_C();
}

/**
 *	维持在线的函数
 *
 *	@param	ret
 
 SUCCESS = 0,
 SESSION_NOT_EXSIT	= 5,						//登录session不存在（登录已过期）
 SQL_NOT_FIND		= 6,
 PTCP_HAS_CLOSED		= 7,
 
 GENERATE_PASS_ERROR = -2,
 REDIS_OPT_ERROR		= -3,
 MY_SQL_ERROR		= -4,
 REQ_RES_TIMEOUT		= -5,
 CONN_OTHER_ERROR	= -6,
 CANT_CONNECT_SERVER = -7,
 JSON_INVALID		= -8,
 REQ_RES_OTHER_ERROR = -9,
 JSON_PARSE_ERROR	= -10,
 SEND_MAIL_FAILED	= -11,
 
 OTHER_ERROR			= -1000,
 
 *
 *
 */
void clientOnLine(const int ret){
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    if (sharedjvcAccountHelper.delegate!=nil) {
        
        if ([sharedjvcAccountHelper.delegate respondsToSelector:@selector(keepOnlineReturnValue:)]) {
            
            [sharedjvcAccountHelper.delegate keepOnlineReturnValue:ret];
        }
        
        
    }
    
    [pool release];
}


/**
 *	消息推送的回调
 *
 *	@param	message_type	类别
 *	@param	serverPushInfo	托送的信息
 */
void ServerPushCallBack(const int message_type, const c_SERVER_PUSH_INFO serverPushInfo){
    
    NSString *returnStr=[NSString stringWithCString:(const char*)serverPushInfo.message encoding:NSUTF8StringEncoding];
    
    NSData *returnData=[returnStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (sharedjvcAccountHelper.delegate != nil) {
        
        
        if ([sharedjvcAccountHelper.delegate respondsToSelector:@selector(serverPushCallBack:serverPushData:)]) {
            
            [sharedjvcAccountHelper.delegate serverPushCallBack:message_type serverPushData:returnData];
        }
        
    }
}

/**
 *  获取帐号的服务器地址
 *
 *  @param channelServerAddress 短连接的
 *  @param onlineServerAddress  维持在线的
 */
-(void)getAccountServerAddress:(char *)channelServerAddress onlineServerAddress:(char *)onlineServerAddress{
    
    GetServerIP_C(channelServerAddress, onlineServerAddress) ;
    
}

#pragma mark 初始化账号
/**
 *  初始化账号服务器域名
 *
 *  @param state      TRUE  :忽略本地缓存解析IP,为TRUE的时候不会在调用初始化SDK和设置超时的函数
 *  @param Islocation TRUE  :中国
 */
- (int)intiAccountSDKWithIsLocalCheck:(BOOL )state withIslocation:(BOOL)Islocation{
    
    NSArray *pathsAccount=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *pathAccountHome=[pathsAccount objectAtIndex:0];
    
    NSString * pathAccount=[pathAccountHome stringByAppendingPathComponent:ACCOUNTSERVICELOG];
    
    NSString *APPCHANNELSERVICEADDRESSPATHPATH =[pathAccountHome stringByAppendingPathComponent:Islocation == YES ? (NSString *)kAppChannelServiceAddressC:(NSString *)kAppChannelServiceAddressE];
    
    NSString *AccountAPPONLINESERVICEADDRESSPATH =[pathAccountHome stringByAppendingPathComponent:Islocation == YES ? (NSString *)kAppOnlineServiceAddressC:(NSString *)kAppOnlineServiceAddressE];
    
    int result = [self InitSdk:pathAccount
       channelServerAddressStr:Islocation == YES?(NSString *)kAppChannelServiceAddressC:(NSString *)kAppChannelServiceAddressE
channelServerAddressStrLocalPath:APPCHANNELSERVICEADDRESSPATHPATH
        onlineServerAddressStr:Islocation == YES ?(NSString *)kAppOnlineServiceAddressC:(NSString *)kAppOnlineServiceAddressE
onlineServerAddressStrLocalPath:AccountAPPONLINESERVICEADDRESSPATH
                  islocalCheck:state
                   isLogAppend:YES];
    
    return result;
}

-(int)InitSdk:(NSString *)sdkLogPath  channelServerAddressStr:(NSString *)channelServerAddressStr channelServerAddressStrLocalPath:(NSString *) channelServerAddressStrLocalPath onlineServerAddressStr:(NSString *)onlineServerAddressStr onlineServerAddressStrLocalPath:(NSString *)onlineServerAddressStrLocalPath islocalCheck:(BOOL)islocalCheck isLogAppend:(BOOL)isLogAppend{
    
    NSMutableString *mstrChannelServerPath=nil;
    
    NSMutableString *mstronlineServerPath=nil;
    
    [mstrChannelServerPath deleteCharactersInRange:NSMakeRange(0, [mstrChannelServerPath length])];
    
    [mstronlineServerPath deleteCharactersInRange:NSMakeRange(0, [mstronlineServerPath length])];
    
    [mstrChannelServerPath appendString:channelServerAddressStrLocalPath];
    [mstronlineServerPath appendString:onlineServerAddressStrLocalPath];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if (!isLogAppend) {
        
        [fileManager removeItemAtPath:sdkLogPath error:nil];
    }
    
    if (!islocalCheck) {
        
        NSMutableString *mstrChannelServer = [NSMutableString stringWithCapacity:10];
        
        NSMutableString *mstronlineServer = [NSMutableString stringWithCapacity:10];
        
        if ([[JVCSystemUtility shareSystemUtilityInstance] checkLocalFileExist:channelServerAddressStrLocalPath]) {
            
            NSData *channelServerAddressData=[NSData dataWithContentsOfFile:channelServerAddressStrLocalPath];
            
            
            NSString *strChannelServer=[[NSString alloc] initWithData:channelServerAddressData encoding:NSUTF8StringEncoding];
            
            [mstrChannelServer appendString:strChannelServer];
            
            
            [strChannelServer release];
            
            if ([[JVCSystemUtility shareSystemUtilityInstance] checkLocalFileExist:onlineServerAddressStrLocalPath]) {
                
                NSData *onlineServerAddressData=[NSData dataWithContentsOfFile:onlineServerAddressStrLocalPath];
                
                NSString *stronlineServerAddress=[[NSString alloc] initWithData:onlineServerAddressData encoding:NSUTF8StringEncoding];
                
                
                [mstronlineServer appendString:stronlineServerAddress];
                
                [stronlineServerAddress release];
                
                
                return [[JVCAccountHelper sharedJVCAccountHelper] InitSdk:sdkLogPath channelServerAddressStr:mstrChannelServer onlineServerAddressStr:mstronlineServer islocalCheck:islocalCheck isSetAddress:TRUE];
            }
        }
        
    }
    
    return [[JVCAccountHelper sharedJVCAccountHelper] InitSdk:sdkLogPath channelServerAddressStr:channelServerAddressStr onlineServerAddressStr:onlineServerAddressStr islocalCheck:islocalCheck isSetAddress:FALSE];
    
}

/**
 *	激活token
 *
 *	@param	device_id	设备的唯一标识
 *
 *	@return	成功返回0
 */
-(int)activeServerPushToken:(NSString *)device_id{
    
    return SetCurrentAlarmFlag_C(ALARM_ON,[device_id UTF8String]);
}

/**
 *	取消token
 *
 *	@param	device_id	设备的唯一标识
 *
 *	@return	成功返回0
 */
-(int)CancelServerPushToken:(NSString *)device_id{
    
    
    return SetCurrentAlarmFlag_C(ALARM_OFF,[device_id UTF8String]);
    
}


@end
