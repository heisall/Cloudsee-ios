//
//  JVBAccountHelper.h
//  iBaby
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JVCAccountDelegate <NSObject>

/**
 *  维持在线的委托回调
 *
 *  @param keepOnlineType 返回的维持在线的结果
 */
-(void)keepOnlineReturnValue:(int)keepOnlineType;

/**
 *  帐号服务器的长连接的回调 （包含实时报警、赶人下线、TCP断开）
 *
 *  @param keepOnlineType
 */
-(void)serverPushCallBack:(int)message_type serverPushData:(NSData *)serverPushData;

@end

@interface JVCAccountHelper : NSObject{

   id <JVCAccountDelegate> delegate;

}

@property (nonatomic,assign) id <JVCAccountDelegate> delegate;


/**
 *  获取帐号中间类对象
 *
 *  @return 帐号库对象
 */
+(JVCAccountHelper *)sharedJVCAccountHelper;

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
-(int)InitSdk:(NSString *)sdkLogPath  channelServerAddressStr:(NSString *)channelServerAddressStr onlineServerAddressStr:(NSString *)onlineServerAddressStr  islocalCheck:(BOOL)islocalCheck isSetAddress:(BOOL)isSetAddress;


/**
 *	释放帐号SDK
 */
-(void)UnInitSDK;

/**
 *  设置帐号SDK的连接和请求的超时时间（单位是s）
 *
 *  @param connectTimeOut   连接的的超时时间(>0有效，默认设置5s)
 *  @param rqconnectTimeOut 请求的超时时间（>0有效,默认设置5s）
 */
-(void)setTimeoutSecond:(int)connectTimeOut rqconnectTimeOut:(int)rqconnectTimeOut;

/**
 *	判断用户名是否存在
 *
 *	@param	userName	注册的用户名
 *
 *	@return	USER_HAS_EXIST		= 2			//用户已经存在
 USER_NOT_EXIST		= 3			//用户不存在
 */
-(int)IsUserExist:(NSString *)userName;

/**
 *	注册帐号接口
 *
 *	@param	userName	用户名
 *	@param	passWord	密码
 *  @param  appTypeName 应用程序的名称 例如NVSIP
 *
 *	@return 成功返回0
 */
//-(int)UserRegister:(NSString *)userName passWord:(NSString *)passWord appTypeName:(NSString *)appTypeName;
-(int)UserRegister:(NSString *)userName passWord:(NSString *)passWord appTypeName:(const NSString *)appTypeName;
/**
 *  绑定用户的邮箱
 *
 *  @param securityMail 邮箱
 *
 *  @return 成功返回0
 */
-(int)bindMailToAccount:(NSString *)securityMail;


/**
 *  判断用户密码强度
 *
 *  @param userName 登陆的用户名
 *
 *  @return 成功返回0 ,119是用户的新密码加密规则，调用UserLogin接口登陆
 118是用户的老密码加密规则调用OldUserLogin接口登陆
 */
-(int)JudgeUserPasswordStrength:(NSString *)userName;

/**
 *	登陆
 *
 *	@param	username	用户名
 *	@param	passWord	密码
 *
 *	@return	成功返回0  －16:调用ResetUserNameAndPassword重置用户名和密码,注销再登陆（后台）
 －17:调用ResetUserPassword重置密码
 */
-(int)OldUserLogin:(NSString *)username passWord:(NSString *)passWord;

/**
 *	登陆
 *
 *	@param	username	用户名
 *	@param	passWord	密码
 *
 *	@return	成功返回0
 */
-(int)UserLogin:(NSString *)username passWord:(NSString *)passWord;

/**
 *  修改已注册非规范用户名及密码
 *
 *  @param newUserName 新用户
 *  @param newPassword 新密码
 *
 *  @return 成功返回0
 */
-(int)ResetUserNameAndPassword:(NSString *)newUserName newPassword:(NSString *)newPassword;

/**
 *	修改用户密码
 *
 *	@param	oldPassword	旧密码
 *	@param	newPassWord	新密码
 *
 *	@return	成功返回0
 */
-(int)ModifyUserPassword:(NSString *)oldPassword newPassWord:(NSString *)newPassWord;

/**
 *	登出
 *
 *	@return	成功返回0
 */
-(int)UserLogout;

/**
 *  修改符合用户规则但帐户使用老密码加密规则
 *
 *  @param newPassword 新密码
 *
 *  @return 成功返回0
 */
-(int)ResetUserPassword:(NSString *)newPassword username:(NSString *)username;

/**
 *	维持在线心跳
 *
 *	@param	tokenStr	  消息推送的唯一标示
 *  @param	languageType  中文 0  英文 1
 *
 *	@return	成功返回0
 */
-(int)keepOnline:(NSString *)tokenStr languageType:(int)languageType;

/**
 *  获取帐号系统的报警开关
 *
 *  @return @return	ALARM_ON  = 0, 打开
 ALARM_OFF = 1, 关闭
 */
-(int)getAlarmStateInt;

/**
 *	关掉帐号重连的心跳
 */
-(void)stopServerTimer;

/**
 *  获取帐号的服务器地址
 *
 *  @param channelServerAddress 短连接的
 *  @param onlineServerAddress  维持在线的
 */
-(void)getAccountServerAddress:(char *)channelServerAddress onlineServerAddress:(char *)onlineServerAddress;

@end
