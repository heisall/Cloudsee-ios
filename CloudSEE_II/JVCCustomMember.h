//
//  JVCCustomMember.h
//  CloudSEE_II
//  封装一个成员变量用于处理类属性的类型
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCMember.h"
@class JVCType;


@interface JVCCustomMember : JVCMember

/** 成员变量 */
@property (nonatomic, assign) Ivar ivar;
/** 成员属性名 */
@property (nonatomic, copy, readonly) NSString *propertyName;
/** 成员变量的值 */
@property (nonatomic) id propertyValue;
/** 成员变量的类型 */
@property (nonatomic, strong, readonly) JVCType *type;




/**
 *  初始化
 *
 *  @param ivar             成员变量
 *  @param propertyInObject 成员变量属于的对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar withPropertyInObject:(id)propertyInObject;

@end

/**
 *  遍历成员变量用的block
 *
 *  @param ivar 成员变量的包装对象
 *  @param stop YES代表停止遍历，NO代表继续遍历
 */
typedef void (^JVCCustomMemberBlock)(JVCCustomMember *ivar, BOOL *stop);
