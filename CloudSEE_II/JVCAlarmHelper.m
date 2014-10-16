//
//  JVCAlarmHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmHelper.h"

@implementation JVCAlarmHelper

static JVCAlarmHelper *shareAlarmHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCAlarmHelper *)shareAlarmHelper
{
    @synchronized(self)
    {
        if (shareAlarmHelper == nil) {
            
            shareAlarmHelper = [[self alloc] init];
        }
        
        return shareAlarmHelper;
    }
    
    return shareAlarmHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAlarmHelper == nil) {
            
            shareAlarmHelper = [super allocWithZone:zone];
            
            return shareAlarmHelper;
        }
    }
    
    return nil;
}


@end
