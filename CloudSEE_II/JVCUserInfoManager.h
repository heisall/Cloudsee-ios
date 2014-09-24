//
//  JVCUserInfoManager.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface JVCUserInfoManager : NSObject

@property (nonatomic, retain) NSString *strUserName;
@property (nonatomic, retain) NSString *strPassword;
@property (nonatomic, retain) NSString *strLastLoginTimer;

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (JVCUserInfoManager *)shareUserInfoManager;


#define kkUserName [JVCUserInfoManager shareUserInfoManager].strUserName
#define kkPassword [JVCUserInfoManager shareUserInfoManager].strPassword
#define kLastTimer [JVCUserInfoManager shareUserInfoManager].strLastLoginTimer

/**
 *  获取用户名
 *
 *  @return 用户名
 */
- (NSString *)strUserName ;

/**
 *  获取密码
 *
 *  @return 密码
 */
- (NSString *)strPassword ;

/**
 *  获取最后一次登录时间
 *
 *  @return 最后一次登录时间
 */
- (NSString *)strLastLoginTimer ;

/**
 *  设置用户名
 *
 *  @param value 用户名
 */
- (void)setStrUserName:(NSString *)value ;

/**
 *  设置密码
 *
 *  @param value 密码
 */
- (void)setStrPassword:(NSString *)value ;

/**
 *  设置最后一次登录时间
 *
 *  @param value 最后登录时间
 */
- (void)setStrLastLoginTimer:(NSString *)value ;

/**
 *  保存用户名密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)saveUserInfoWithUserName:(NSString *)userName passWord:(NSString *)passWord;

/**
 *  设置常量为用户名密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)setConstantUserInfoWithUserName:(NSString *)userName passWord:(NSString *)passWord;




@end
