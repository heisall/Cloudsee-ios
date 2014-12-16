//
//  JVCFoundation.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCFoundation.h"

static NSArray *_foundationClasses;

@implementation JVCFoundation

+ (void)initialize
{
    _foundationClasses = @[@"NSObject",@"NSNumber",@"NSArray",@"NSMutableArray",@"NSData",@"NSMutableData",
                           @"NSDate",@"NSDictionary",@"NSMutableDictionary",@"NSString",@"NSMutableString"];
}

/**
 *  判断一个类是否来之系统Foundation框架
 *
 *  @param typeClass 被检测的类名
 *
 *  @return YES:Foundation框架类 NO:自定义
 */
+(BOOL)isClassFromFoundation:(Class)typeClass
{
    return [_foundationClasses containsObject:NSStringFromClass(typeClass)];
}

@end
