//
//  JVCAccountMacro.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#ifndef CloudSEE_II_JVCAccountMacro_h
#define CloudSEE_II_JVCAccountMacro_h

/**
 * @brief   用户基本信息
 */

typedef struct c_userInfo_
{
    char username[20];
    char security_mail[30];
    //...
}C_USER_INFO;


enum languageType
{
	CHINESE = 0,
	ENGLISH = 1,
};

enum CommonStatus
{
	UNKNOWN = -1,
};

typedef struct c_clientLoginInfo_
{
    int terminal_type;		//登录平台类型
    int	language_type;		//语言类型
    char moblie_id[80];	//手机唯一识别符
    int  alarm_flag;
    
}C_CLIENT_INFO;


typedef struct c_ServerPushInfo
{
    char username[20];			//加强验证，防止串话
    char send_timestamp[20];
    char message[500];
    
}c_SERVER_PUSH_INFO;

enum platformType
{
	ANDROID_CLIENT = 1,
	IPHONE_CLIENT  = 2,
	IPAD_CLIENT	   = 3,
};

#define STR_PTCP_HAS_CLOSED "TCP_CLOSED"
#define STR_PTCP_HAS_ERROR	"TCP_ERROR"



enum OnlineStatus
{
    OFFLINE = 0,
    ONLINE,
    LEAVING,
    HIDING,
};

enum IReturnCode
{
    SUCCESS = 0,
    
	USER_HAS_EXIST			= 2,						//用户已经存在
	USER_NOT_EXIST			= 3,						//用户不存在
	PASSWORD_ERROR			= 4,						//密码错误
	SESSION_NOT_EXSIT		= 5,						//登录session不存在（登录已过期）
	SQL_NOT_FIND			= 6,
	PTCP_HAS_CLOSED			= 7,						//断开与服务器的连接
    
	LOW_STRENGTH_PASSWORD	= 118,						//低强度密码用户
	HIGH_STRENGTH_PASSWORD	= 119,						//高强度密码用户
    
	GENERATE_PASS_ERROR 	= -2,
	REDIS_OPT_ERROR			= -3,						//内部服务器错误
	MY_SQL_ERROR			= -4,						//内部服务器错误
	REQ_RES_TIMEOUT			= -5,						//请求超时
	CONN_OTHER_ERROR		= -6,						//连接服务器错误
	CANT_CONNECT_SERVER 	= -7,						//无法连接无服务器
	JSON_INVALID			= -8,						//数据不合法
	REQ_RES_OTHER_ERROR 	= -9,						//请求错误
	JSON_PARSE_ERROR		= -10,						//数据不合法
	SEND_MAIL_FAILED		= -11,
	ACCOUNTNAME_OTHER 		= -16,						//已注册不符合规则注册的用户（老用户）
	PASSWORD_DANGER 		= -17,						//用户密码级别太低
    PHONE_NUM_ERROR 		= -15,						//手机号格式不正确
    OTHER_ERROR				= -1000,
};

enum alarmflag
{
    ALARM_ON  = 0,
    ALARM_OFF = 1,
};

/**
 *  登录注册的枚举
 */
enum  loginResut
{
    LOGINRESULT_SUCCESS = 0,//登录成功
    LOGINRESULT_USERNAME_NIL,//用户名为空
    LOGINRESULT_PASSWORLD_NIL,//密码为空
    LOGINRESULT_USERNAME_ERROR,//用户名不合法
    LOGINRESULT_PASSWORLD_ERROR,//密码不合法
    LOGINRESULT_ENSURE_PASSWORD_NIL,//确认密码为空
    LOGINRESULT_ENSURE_PASSWORD_ERROR,//确认密码与密码不相同
    LOGINRESULT_EMAIL_ERROR,//邮箱不合法
    LOGINRESULT_NOT_EQUAL_USER_PASSWORD,//用户保存密码与用户输入的不一致
    LOGINRESULT_OLD_PASS_EQUAl_NEW_PASSWORD,//用户保存密码与用户输入的不一致

};



enum MODIFYLINKMODELTYPE
{
    LINKMODEL_SUCCESS = 0,
    LINKMODEL_USER_NIL ,//用户名为空
    LINKMODEL_USER_ERROR ,//用户名格式不合法
    LINKMODEL_PASSWORD_NIL ,//密码为空
    LINKMODEL_PASSWORD_ERROR ,//密码格式不合法
    LINKMODEL_IP_NIL ,//ip为空
    LINKMODEL_IP_ERROR ,//ip格式不合法
    LINKMODEL_PORT_NIL ,//PORT为空
    LINKMODEL_PORT_ERROR ,//port格式不合法
    
};

/**
 *  注册的枚举
 */
enum VALIDATIONUSERNAMETYPE{
    
    VALIDATIONUSERNAMETYPE_S        = 0,   //校验通过
    VALIDATIONUSERNAMETYPE_LENGTH_E = -1,  //用户名长度只能在4-28位字符之间；
    VALIDATIONUSERNAMETYPE_NUMBER_E = -2,  //用户名不能全为数字
    VALIDATIONUSERNAMETYPE_OTHER_E  = -3,  //用户名只能由英文、数字及“_”、“-”组成
    VALIDATIONUSERNAMETYPE_PHONE_E  = -4,  //手机号格式不正确
    VALIDATIONUSERNAMETYPE_EMAIL_E  = -5,  //邮箱格式不正确
};

static const int  LOGINRUSULT_SUCCESS      = 0;
static const int  USERTYPE_NEW             = 119;  //新账号
static const int  USERTYPE_OLD             = 118;  //老账号
static const int  RESERT_USER_AND_PASSWORD = -16;  //重置用户名和密码
static const int  RESERT_PASSWORD          = -17;  //重置密码
static const int  KlogoOffSet_y            = 80;   //logo的开始问题

#endif
