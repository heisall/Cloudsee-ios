//
//  JVCTencentHelp.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/12/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCTencentHelp.h"
static JVCTencentHelp *shareTencentHelp = nil;
@implementation JVCTencentHelp
static const NSString *kTenchetValue        = @"Value";
static const NSString *kTenchetValuekey     = @"Key";

static const NSString *kTenchetaty          = @"aty";
static const NSString *kTenchetbtn          = @"btn";
static const NSString *kTenchetgid          = @"gid";
static const NSString *kTenchetOK           = @"OK";
static const NSString *kTenchetOne          = @"1";

/**
 *  单例
 *
 *  @return 对象
 */
+(JVCTencentHelp *)shareTencentHelp
{
    @synchronized(self)
    {
        if (shareTencentHelp == nil) {
            
            shareTencentHelp = [[self alloc] init];
            
            
        }
        
        return shareTencentHelp;
    }
    
    return shareTencentHelp;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareTencentHelp == nil) {
            
            shareTencentHelp = [super allocWithZone:zone];
            
            return shareTencentHelp;
        }
    }
    
    return nil;
}

/**
 *  点击事件的次数统计
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEvent:(NSString *)tencentKey
{
    switch (JVCTencentLeveal) {
            
        case JVCTencentTypeOpen:
        {
            NSDictionary* kvs = [NSDictionary dictionaryWithObject:kTenchetValue
                                                            forKey:kTenchetValuekey];
            
            [MTA trackCustomKeyValueEvent:tencentKey props:kvs];

        }
            break;
            
        default:
            break;
    }
}

/**
 *  跟踪事件开始
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEventBegin:(NSString *)tencentKey
{
   
    
    switch (JVCTencentLeveal) {
        case JVCTencentTypeOpen:
        {
            NSDictionary* kvs = [NSDictionary dictionaryWithObject:kTenchetValue
                                                            forKey:kTenchetValuekey];
            [MTA trackCustomKeyValueEventBegin:tencentKey props:kvs];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  跟踪事件结束
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEventEnd:(NSString *)tencentKey
{
    
    switch (JVCTencentLeveal) {
            
        case JVCTencentTypeOpen:
        {
            NSDictionary* kvs = [NSDictionary dictionaryWithObject:kTenchetValue
                                                            forKey:kTenchetValuekey];
            [MTA trackCustomKeyValueEventEnd :tencentKey props:kvs];
        }
            break;
            
        default:
            break;
    }

}

/**
 *  跟踪活动页面按钮事件
 *
 *  @param tencentKey         腾讯key值
 *  @param activityViewString 活动页面
 */
- (void)tencenttrackCustomKeyValueEvent:(NSString *)tencentKey  activityClass:(NSString *)activityViewString
{
    switch (JVCTencentLeveal) {
            
        case JVCTencentTypeOpen:
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:3];
            [dictionary setObject:activityViewString forKey:kTenchetaty];
            [dictionary setObject:kTenchetOK forKey:kTenchetbtn];
            [dictionary setObject:kTenchetOne forKey:kTenchetgid];
            [MTA trackCustomKeyValueEvent:tencentKey
                                    props:dictionary];
            [dictionary release];

        }
            break;
            
        default:
            break;
    }
    
   }

/**
 *  初始腾讯sdk
 */
- (void)initTencentSDK
{
    switch (JVCTencentLeveal) {
            
        case JVCTencentTypeOpen:
        {
            [MTA startWithAppkey:kTencentKey];
            
        }
            break;
            
        default:
            break;
    }

}


@end
