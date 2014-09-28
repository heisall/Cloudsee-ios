//
//  JVCAnimationHelper.m
//  CloudSEE_II
//  动画的助手类
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAnimationHelper.h"

@implementation JVCAnimationHelper

static JVCAnimationHelper *jvcJVCAnimationHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCAnimationHelper的单例
 */
+ (JVCAnimationHelper *)shareJVCAnimationHelper{
    
    @synchronized(self)
    {
        if (jvcJVCAnimationHelper == nil) {
            
            jvcJVCAnimationHelper = [[self alloc] init];
            
        }
        return jvcJVCAnimationHelper;
    }
    return jvcJVCAnimationHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcJVCAnimationHelper == nil) {
            
            jvcJVCAnimationHelper = [super allocWithZone:zone];
            
            return jvcJVCAnimationHelper;
        }
    }
    return nil;
}

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
-(void )startWithAnimation:(UIView *)baseView exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 duration:(NSTimeInterval)duration animationType:(NSString const *)type animationSubType:(NSString *)subType{
    
    [baseView retain];
    [type retain];
    [subType retain];

    CATransition *animation  = [CATransition animation];
    animation.duration       = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
   
    if (type == nil) {
        
         animation.type = kCATransitionFade;
        
    }else{
    
        animation.type = (NSString *)type;
    }
    
    if (subType == nil) {
        
        animation.subtype = kCATransitionFromLeft;
        
    }else{
    
        animation.subtype = subType;
    }
    
    [baseView release];
    [type release];
    [subType release];
    
    [baseView exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    
    [[baseView layer] addAnimation:animation forKey:@"animation"];
}

@end
