//
//  JVCCatchCrash.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/27/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCCatchCrash.h"
#import "JVCLogHelper.h"
@implementation JVCCatchCrash

void uncaughtExceptionHandler(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@ end\n",name, reason, stackArray];
    
    [[JVCLogHelper shareJVCLogHelper] writeDataToFile:exceptionInfo fileType:LogType_CatchCrash];
}

@end

