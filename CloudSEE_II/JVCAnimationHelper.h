//
//  JVCAnimationHelper.h
//  CloudSEE_II
//  动画助手类，提供常用的动画函数
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCAnimationMacro.h"

@interface JVCAnimationHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCAnimationHelper的单例
 */
+ (JVCAnimationHelper *)shareJVCAnimationHelper;

/**
 *  系统动画的公共函数 提供 水波 、镜头开开（关）、翻转、收缩
 *
 *  @param baseView 基类
 *  @param index1   旧视图
 *  @param index2   新视图
 *  @param duration 动画时间
 *  @param type     类别
 *  @param subType  方向
 *
 *  @return CATransition 对象
 */
-(void )startWithAnimation:(UIView *)baseView exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 duration:(NSTimeInterval)duration animationType:(NSString const *)type animationSubType:(NSString *)subType;
@end
