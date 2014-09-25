//
//  JVCPredicateHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCPredicateHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCPredicateHelper *)shareInstance;

/**
 *  判断字符串是否为空
 *
 *  @param string 传入的字符串
 *
 *  @return yes 为空  no：不为空
 */
- (BOOL)predicateBlankString:(NSString *)string;
@end
