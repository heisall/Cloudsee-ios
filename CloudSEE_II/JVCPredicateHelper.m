//
//  JVCPredicateHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPredicateHelper.h"

@implementation JVCPredicateHelper

static JVCPredicateHelper *_shareInstance = nil;
/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCPredicateHelper *)shareInstance
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
 *  判断字符串是否为空
 *
 *  @param string 传入的字符串
 *
 *  @return yes 为空  no：不为空
 */
- (BOOL)predicateBlankString:(NSString *)string
{
    if(string == nil)
    {
        return  YES;
    }
    if (string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        return YES;
    }
    
    return NO;
}

@end
