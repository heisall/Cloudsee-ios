//
//  JVCResultTipsHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
static const int KAddTag  = 100;//判断用户的时候的返回值是负数，给他加100处理

@interface JVCResultTipsHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCResultTipsHelper *)shareResultTipsHelper;


/**
 *  弹出用户名、密码正则验证的提示
 *
 *  @param result 相应的返回值
 */
- (void)showLoginPredacateAlertWithResult:(int )result;

/**
 *  账号通过验证，调用登录函数收到的错误返回值的提示
 *
 *  @param resutl 相应的返回值
 */
- (void)loginInWithJudegeUserNameStrengthResult:(int)result;

/**
 *  修改设备的用户名、密码、昵称的返回值显示信息
 */
- (void)showModifyDeviceInfoResult:(int)result;

/**
 *  添加设备界面、根据正则的返回值处理提示
 *
 *  @param result 正则的返回值
 */
- (void)showAddDevicePredicateAlert:(int )result;

/**
 *  连接模式界面修改
 *
 *  @param result 相应的返回值
 */
- (void)showModifyDevieLinkModelError:(int )result;
@end
