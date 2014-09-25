//
//  JVCAccountPredicateMaths.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAccountPredicateMaths : NSObject

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (JVCAccountPredicateMaths *)shareAccontPredicateMaths;

/**
 *  判断用户名、密码是否合法
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *0登录成功、1：用户名为空、2：密码为空、3：用户名不合法、4：密码不合法
 *  @return 返回相应的数值
 */
- (int)loginPredicateUserName:(NSString *)userName  andPassWord:(NSString *)passWord;
@end
