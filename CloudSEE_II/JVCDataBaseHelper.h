//
//  JVCDataBaseHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 *  获取所有数据库中用户的数据
 *
 *  @return 用户数组
 */
- (NSMutableArray *)getAllUsers;
@end
