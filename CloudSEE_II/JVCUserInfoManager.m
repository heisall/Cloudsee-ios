//
//  JVCUserInfoManager.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCUserInfoManager.h"


/**
 *  账号信息
 */
static const NSString * USERINFO_NAME       =  @"user" ;//用户名
static const NSString * USERINFO_PW         =  @"password";//密码
static const NSString * USERINFO_TIMER      =   @"timer";//最后一次登录时间

@interface JVCUserInfoManager ()
{
    
    NSMutableDictionary *_dirUserInfo;
    
}

@end


@implementation JVCUserInfoManager
@synthesize strUserName,strLastLoginTimer,strPassword;

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
    
    NSString *str = [_dirUserInfo objectForKey:USERINFO_NAME];
    
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

- (void)setStrUserName:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_NAME];
}

- (void)setStrPassword:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_PW];
}

- (void)setStrLastLoginTimer:(NSString *)value {
    
    [_dirUserInfo setObject:value forKey:USERINFO_TIMER];
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

@end
