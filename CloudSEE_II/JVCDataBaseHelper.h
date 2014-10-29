//
//  JVCDataBaseHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

static int      const  kLoginStateON    = 1;      //数据库打开自动登录
static int      const  kLoginStateOFF   = 0;      //关闭自动登录

@interface JVCDataBaseHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDataBaseHelper *)shareDataBaseHelper;

/**
 *  创建用户表格
 */
- (void)createUserInfoTable;

/**
 *  登录成功后，将用户名，密码存到数据库中，首先看看数据库中有这条数据吗，有更新，没有直接写入
 *
 *  @param userName 用户名
 *  @param passWord 秘密
 */
- (void)writeUserInfoToDataBaseWithUserName:(NSString *)userName  passWord:(NSString *)passWord;


/**
 *  往表格中插入数据
 *
 *  @param userName 用户名
 *  @param passWord 密码 * 
 *  @param timer    时间截
 */
- (void)writeOldUserInfoToDataBaseWithUserName:(NSString *)userName  passWord:(NSString *)passWord  loginTimer:(int)loginTimer;
/**
 *  获取所有数据库中用户的数据
 *
 *  @return 用户数组
 */
- (NSMutableArray *)getAllUsers;

/**
 *  根据用户名修改自动登录状态
 *
 *  @param userName 用户名
 *  @param autoLoginState  登录状态
 */
- (void)updateUserAutoLoginStateWithUserName:(NSString *)userName   loginState:(BOOL )autoLoginState;

/**
 *  根据用户名删除账号信息
 *
 *  @param userName 用户名
 */
- (void)deleteUserInfoWithUserName:(NSString *)userName;

/**
 *  登录的账号个数
 *
 *  @return 账号个数
 */
- (int)usersHasLoginCount;

@end
