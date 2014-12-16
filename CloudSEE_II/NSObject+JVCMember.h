//
//  NSObject+JVCMember.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCCustomMember.h"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^JVCMemberClassesBlock)(Class c, BOOL *stop);


@interface NSObject (JVCMember)

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(JVCCustomMemberBlock)block;


/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(JVCMemberClassesBlock)block;

@end
