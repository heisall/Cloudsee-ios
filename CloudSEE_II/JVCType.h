//
//  JVCType.h
//  CloudSEE_II
//  包装一种类型，用于反射对属性类型、父类的处理
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCType : NSObject

//类型标识符 例如 @"NSMutableArray"
@property (nonatomic, copy)             NSString *strTypeIdentifier;
 //对象的类型（基本数据类型，此值为nil）
@property (nonatomic, assign, readonly) Class typeClass;
 ///类型是否来自于Foundation框架，比如NSString、NSArray
@property (nonatomic, readonly, getter = isFromFoundation) BOOL fromFoundation;
//是否支持KVC协议
@property (nonatomic, readonly, getter = isKVCDisabled)    BOOL KVCDisabled;

/**
 *  初始化一个类型对象
 *
 *  @param code 类型标识符
 */
- (instancetype)initWithTypeIdentifier:(NSString *)strTypeIdentifier;

@end
