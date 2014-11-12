//
//  JVCUserInfoManager.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCUserInfoManager.h"
#import "JVCSystemUtility.h"
#import "JVCDataBaseHelper.h"
/**
 *  账号信息
 */
static const NSString * USERINFO_NAME       =  @"user" ;//用户名
static const NSString * USERINFO_PW         =  @"password";//密码
static const NSString * USERINFO_TIMER      =  @"timer";//最后一次登录时间
static const NSString * USERINFO_AutoLogin  =  @"AutoLogin";//自动登录
static const NSString * USERINFO_Gesture    =  @"Gesture";//手势密码
static const NSString * USERINFO_StrToken   =  @"Token";//手势密码
static const NSString * USERINFO_AlarmState =  @"userAlarmState";//用户报警状态
static const NSString * USERINFO_LoginToken =  @"LoginToken";//账号登陆获取的token


@interface JVCUserInfoManager ()
{
    
    NSMutableDictionary *_dirUserInfo;
    
}

@end


@implementation JVCUserInfoManager
@synthesize strUserName,strLastLoginTimer,strPassword;
@synthesize bAutoLoginState,bGestureState;
@synthesize strToken;
@synthesize strLoginToken;
static JVCUserInfoManager *shanreInstance = nil;

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (JVCUserInfoManager *)shareUserInfoManager
{
    @synchronized(self)
    {
        if (shanreInstance == nil) {
            
            shanreInstance = [[self alloc] init];
            
            [shanreInstance initUserInfoDic];
        }
        return shanreInstance;
        
    }
    return shanreInstance;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shanreInstance == nil) {
            
            shanreInstance = [super allocWithZone:zone];
            
            return shanreInstance;
            
        }
    }
    return nil;
}

- (void)initUserInfoDic
{
    _dirUserInfo = [[NSMutableDictionary alloc] init];
    
}

- (NSString *)strUserName {
    
    NSString *str = [[_dirUserInfo objectForKey:USERINFO_NAME] lowercaseString];
    
    return (!str)?@"":str;
}

- (NSString *)strPassword {
    
    NSString *str = [_dirUserInfo objectForKey:USERINFO_PW];
    
    return (!str)?@"":str;
}

- (NSString *)strLastLoginTimer {
    
    NSString *str = [_dirUserInfo objectForKey:USERINFO_TIMER];
    
    return (!str)?@"":str;
}

- (NSString *)strToken {
    
    NSString *str = [_dirUserInfo objectForKey:USERINFO_StrToken];
    
    return (!str)?@"":str;
}

- (NSString *)strLoginToken {
    
    NSString *str = [_dirUserInfo objectForKey:USERINFO_LoginToken];
    
    return (!str)?@"":str;
}


- (BOOL)bAutoLoginState {
    
    NSNumber *str = [_dirUserInfo objectForKey:USERINFO_AutoLogin];
    
    return str.boolValue;
}

- (BOOL )bGestureState {
    
    NSNumber *str = [_dirUserInfo objectForKey:USERINFO_Gesture];
    
    return str.boolValue;
}

- (int)iUserAlarmState
{
    NSNumber *str = [_dirUserInfo objectForKey:USERINFO_AlarmState];
    
    return str.intValue;

}



- (void)setStrUserName:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_NAME];
}

- (void)setStrPassword:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_PW];
}

- (void)setStrLastLoginTimer:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_TIMER];
}

- (void)setStrToken:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_StrToken];
}

- (void)setStrLoginToken:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_LoginToken];
}


- (void)setBAutoLoginState:(BOOL)value {
    
    
    [_dirUserInfo setObject:[NSNumber numberWithBool:value] forKey:USERINFO_AutoLogin];
}

- (void)setBGestureState:(BOOL)value {
    
    [_dirUserInfo setObject:[NSNumber numberWithBool:value] forKey:USERINFO_Gesture];
}

- (void)setIUserAlarmState:(int)value {
    
    [_dirUserInfo setObject:[NSNumber numberWithInt:value] forKey:USERINFO_AlarmState];
}
/**
 *  保存用户名密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)saveUserInfoWithUserName:(NSString *)userName passWord:(NSString *)passWord
{
}


/**
 *  设置常量为用户名密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)setConstantUserInfoWithUserName:(NSString *)userName passWord:(NSString *)passWord
{
    [[JVCUserInfoManager shareUserInfoManager] setStrUserName:userName];
    [[JVCUserInfoManager shareUserInfoManager] setStrPassword:passWord];
    
}

/**
 *  把老的用户放到新的数据库中
 */
- (void)convertOldUserInfoToDateBase
{
    JVCSystemUtility *systemUtility =  [JVCSystemUtility shareSystemUtilityInstance];
    NSString *tPathlist = [systemUtility getUserInfoPlistPath];
    NSMutableArray *tOldUserArray = [[NSMutableArray alloc] initWithContentsOfFile:tPathlist];
    
    JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;

    for (NSDictionary *tDirUser in tOldUserArray) {
        

       NSString *passWord   = [tDirUser objectForKey:(NSString *)USERINFO_PW];
       NSString *userName   = [tDirUser objectForKey:(NSString *)USERINFO_NAME];
        int nLoginInter = (int )[tDirUser objectForKey:(NSString *)USERINFO_TIMER];
        [fmdbHelp writeOldUserInfoToDataBaseWithUserName:userName passWord:passWord loginTimer:nLoginInter];
    }
    
    [systemUtility removeOldUserPlist];

}

@end
