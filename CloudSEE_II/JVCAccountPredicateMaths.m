//
//  JVCAccountPredicateMaths.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAccountPredicateMaths.h"
#import "JVCPredicateHelper.h"
#import "JVCAccountMacro.h"

@implementation JVCAccountPredicateMaths

static JVCAccountPredicateMaths *shareAccountPredicateMaths = nil;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (JVCAccountPredicateMaths *)shareAccontPredicateMaths
{
    @synchronized(self)
    {
        if (shareAccountPredicateMaths == nil) {
            
            shareAccountPredicateMaths = [[self alloc] init];
            
            return shareAccountPredicateMaths;
        }
        
        return shareAccountPredicateMaths;
    }
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAccountPredicateMaths == nil) {
            
            shareAccountPredicateMaths = [super allocWithZone:zone];
            
            return shareAccountPredicateMaths;
        }
        
        return nil;
    }
}


/**
 *  判断用户名、密码是否合法
 *
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *0登录成功、1：用户名为空、2：密码为空、3：用户名不合法、4：密码不合法
 *  @return 返回相应的数值
 */
- (int)loginPredicateUserName:(NSString *)userName  andPassWord:(NSString *)passWord
{
    /**
     *  判断用户名是否为空
     */
    if ([[JVCPredicateHelper shareInstance] predicateBlankString:userName]) {
        
        return LOGINRESULT_USERNAME_NIL;
    }
    /**
     *  判断用户名是否合法
     */
    //    if (![PredicateObject predicateLegalUserName:userName]) {
    //
    //        return LOGINRESULT_USERNAME_ERROR;
    //    }
    /**
     *  判断密码是否为空
     */
    if ([[JVCPredicateHelper shareInstance] predicateBlankString:passWord]) {
        
        return LOGINRESULT_PASSWORLD_NIL;
    }
    /**
     *  判断密码是否合法
     */
    //    if (![PredicateObject predicateLegalPassWorld:passWord]) {
    //
    //        return LOGINRESULT_PASSWORLD_ERROR;
    //    }
    
    /**
     *  合法
     */
    return LOGINRESULT_SUCCESS;
    
}

@end
