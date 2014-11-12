//
//  JVBAccountInterface.h
//  iBaby
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCAccountMacro.h"

@interface JVCAccountInterface : NSObject

typedef void (*LiveStatusCB)(const int ret);

typedef void (*ServerPushCallBack_Info_C)(const int message_type, const c_SERVER_PUSH_INFO serverPushInfo);


extern "C" {
    
    void DestroyResouce_C();
	
    bool ConfigServerAddress_C(const char* appchannel_server_addr, const char* apponline_server_addr);
	/**
     * @brief 初始化接口SDK（加载配置，网络模块）
     */
    bool InitSDK_C(char *url);
    
    void UnInitSDK_C();
	/** ==== 所有网络接口为同步阻塞接口（远程过程调用）， 默认超时时间为10s（可在配置文件中更改），
     返回值为int类型，如果成功均返回IReturnCode枚举中的SUCCESS，业务逻辑判断及错误返回其他枚举值====**/
	
	/**
     * @brief 判断用户是否存在
     * @param [in]	用户名
     * @return   如果用户不存在返回USER_NOT_EXIST，存在返回USER_HAS_EXIST
     */
    int IsUserExist_C(const char* username);
    
    
	/**
     * @brief 用户注册
     * @param [in] 用户名
     * @param [in] 用户密码（由上层直接传入加密的密码）
     */
    int UserRegister_C(const char *username, const char* password, const char* appTypeName);
    
    /**
     * @brief 判断用户密码强度
     * @param [in] 用户名
     */
    int JudgeUserPasswordStrength_C(const char * accodunt_name);
    
    /**
     * @brief 用户登录（过渡处理）
     * @param [in] 用户名
     * @param [in] 用户密码
     */
    int OldUserLogin_C(const char * account_name, const char * password);
    
    /**
     * @brief 用户登录
     * @param [in] 用户名
     * @param [in] 用户密码
     * @param [in] 客户端相关信息
     */
    int UserLogin_C(const char* username,
                    const char* password);
    
    /**
     *  获取登陆用户的Session
     *
     *  @param session 缓存空间
     *
     *  @return 成功返回0
     */
    int GetSession_C(char* session);
    
    /**
     * @brief 修改已注册非规范用户名及密码
     * @param [in] 新用户名
     * @param [in] 新密码
     */
    int ResetUserNameAndPassword_C(const char* new_account_name, const char* password);
    
    
    /**
     * @brief 绑定邮箱或者手机（调用前先调用IsUserExist看是否被占用）
     * @param [in] 邮箱或者手机
     */
    int BindMailOrPhone_C(const char* mailOrPhone);
    
    
    /**
     * @brief 登录成功后上报客户端相关平台信息
     * @param [in] 客户端平台信息
     */
    int ReportClientPlatformInfo_C(const C_CLIENT_INFO clientInfo);
    
    
	/**
     * @brief 注销用户
     */
    int UserLogout_C();
    
    
    /*
     *@brief 验证密码
     *@param [in] 密码
     */
    int ResetUserPassword_C(const char* password,const char* username);
    
	/**
     * @brief 修改用户密码
     * @param [in] 旧密码
     * @param [in] 新密码
     */
    int ModifyUserPassword_C(const char* password, const char* new_password);
    
	/**
	 * @brief 发送反馈消息到用户邮箱
	 * @param [in] 反馈消息
	 * @param [in] 邮箱地址
	 */
    int SendFeedBackToMail_C(const char* feedback,  const char* mail_address);
    
	/**
     * @brief 用户上线
     * @param [in] 心跳状态回调函数(心跳检测与服务器的连接状态是否正常,对服务器后台起到防止半开连接的作用），
     需要在上层实现LiveStatusCB来实时判断与服务器通信是否正常，累计统计达到一定次数时认为和
     服务器连接中断
     */
    int Online_C(LiveStatusCB liveStatusCb);
    
    
   	/**
     * @brief 接收业务服务器主动消息
     * @param [in] 推送消息回调函数（如果不想收到推送消息在其中加上处理即可，ios推送体系除外）
     */
    void RegisterServerPushFunc_C(ServerPushCallBack_Info_C sp_cb_info);
	/*
	 *@brief 得到当前报警是否开启
	 *@param [out] 报警开启标识  (枚举 alarmflag）
	 */
    int  GetCurrentAlarmFlag_C( int *alarm_flag);
	
    /**
	 * @brief 设置报警标识（关闭或是开启）
	 * @param [in] 报警开启标识  (枚举 alarmflag）
	 * @param [in] 设备唯一标识
	 */
    int  SetCurrentAlarmFlag_C(const int alarm_flag, const char * mobile_id);
	/**
	 * @brief 通过此接口发出长连接网络请求，得到具体响应(长连接服务器，对应具体的业务服务）
	 * @param [in] 请求数据
	 * @param [out] 响应数据
	 * @return
	 */
    int GetResponseByRequestDeviceShortConnectionServer_C(const char* request,  char* response);
    
    /**
     * @brief 通过此接口发出网络请求，得到具体响应(短连接服务器，对应具体的业务服务）
     * @param [in] 	业务服务器类型
     * @param [in] 	请求数据
     * @param [out] 	响应数据
     * @return
     */
    int GetResponseByRequestDevicePersistConnectionServer_C(const char* request,  char* response);
	
    /**
     * @brief 通过此接口发出网络请求，得到具体响应(短连接服务器，对应具体的业务服务）
     * @param [in] 	业务服务器类型
     * @param [in] 	请求数据
     * @param [out] 	响应数据
     * @return
     */
    int GetResponseByRequestShortConnectionServer_C(const int app_type, const char* request,  char* response);
    
	/**
     * @brief 通过此接口发出网络请求，得到具体响应(长连接服务器，对应上线服务器）
     * @param [in] 	业务服务器类型
     * @param [in] 	请求数据
     * @param [out] 	响应数据
     * @return
     */
    int GetResponseByRequestPersistConnectionServer_C(const int app_type,const char* request,  char* response);
    
    /**
	 * @brief 用来停止心跳（当网络已经断开，logout实际已经没有意义，退出时使用）
	 */
    void StopHeartBeat_C();
    
    /**
	 * @brief 设置网络行为超时时间（暴露给应用层）
	 * @param [in]	连接超时时间
	 * @param [in]	得到回应超时时间
	 * @return
	 */
    void SetTimeoutSecond_C(const int connect_timeout_second, const int rq_timeout_second);
    
    /**
	 * @brief 得到服务器ip地址
	 * @param [out]	应用服务器ip
	 * @param [out]	上线服务器ip
	 * @return
	 */
    void GetServerIP_C(char* appchannel_server_ip, char* apponline_server_ip) ;
    
	/**
	 * @brief 设置服务器ip地址
	 * @param [in]	应用服务器ip
	 * @param [in]	上线服务器ip
	 * @return
	 */
    void SetServerIP_C(const char* appchannel_server_ip, const char* apponline_server_ip);
    
   
    
};

@end
