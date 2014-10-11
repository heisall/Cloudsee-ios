//
//  JVCAccountMathHelp.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAccountMathHelp.h"
#import "JVCAccountHelper.h"
#import "JVCAccountMacro.h"

@implementation JVCAccountMathHelp

static JVCAccountMathHelp *_shareInstance = nil;

/**
 *  单例
 *
 *  @return 返回shareAccountMathInstance的单例
 */
+ (JVCAccountMathHelp *)shareAccountMathInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}

/**
 *  新账号登录
 */
- (void)loginInWithNewUserTypeWithUserName:(NSString *)userName  passWord:(NSString *)passWord
{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int resultnewType = [[JVCAccountHelper sharedJVCAccountHelper] UserLogin:userName passWord:passWord];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (LOGINRESULT_SUCCESS == resultnewType) {//成功
                
                
                //如果是present出来的，就让他dismiss掉，如果不是直接切换
                
            }else{
                
              //  [[JVCResultTipsHelper shareResultTipsHelper] loginInWithJudegeUserNameStrengthResult:resultnewType];
                
            }
            
        });
    });
}
@end
