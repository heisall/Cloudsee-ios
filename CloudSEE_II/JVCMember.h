//
//  JVCMember.h
//  CloudSEE_II
//  封装一个成员属性的类，用于标记成员的特性 （来自哪个对象，是否属于Foundation框架）
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "JVCType.h"

@interface JVCMember : NSObject {

    __weak id   _memberInObject;
    NSString   *_name;

}

/** 成员来源于哪个类（可能是父类） */
@property (nonatomic, assign) Class memberInClass;
/** 成员来源类是否是Foundation框架的 */
@property (nonatomic, readonly, getter = isMemberInClassFromFoundation) BOOL memberInClassFromFoundation;

/** 成员来源于哪个对象 */
@property (nonatomic, weak, readonly) id      memberInObject;

/** 成员名 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  初始化
 *
 *  @param memberInObject 成员属于的对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithMemberInObject:(id)memberInObject;

@end
