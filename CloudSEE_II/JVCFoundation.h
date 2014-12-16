//
//  JVCFoundation.h
//  CloudSEE_II
//  判断一个类是否来自系统Foundation框架
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCFoundation : NSObject

/**
 *  判断一个类是否来之系统Foundation框架
 *
 *  @param typeClass 被检测的类名
 *
 *  @return YES:Foundation框架类 NO:自定义
 */
+(BOOL)isClassFromFoundation:(Class)typeClass;

@end
