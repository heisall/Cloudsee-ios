//
//  JVCResultTipsHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end
