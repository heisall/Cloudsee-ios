//
//  JVCAnimationMacro.h
//  CloudSEE_II
//  动画助手类的常用常量定义类
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#ifndef CloudSEE_II_JVCAnimationMacro_h
#define CloudSEE_II_JVCAnimationMacro_h


//系统动画通用字段
//kCATransitionFade    交叉淡化过渡 （不支持过渡方向）
//kCATransitionPush    新视图把旧视图推出去
//kCATransitionReveal  将旧视图移开，显示下面的新视图
//kCATransitionMoveIn  新视图移到旧视图上面
static NSString const *  kJVCAnimationMacroCube                  = @"cube";                  //立体翻滚效果
static NSString const *  kJVCAnimationMacroSuckEffect            = @"suckEffect";            //收缩效果如一块布被抽走 （不支持过渡方向）
static NSString const *  kJVCAnimationMacroOglFlip               = @"oglFlip";               //上下翻转
static NSString const *  kJVCAnimationMacroRippleEffect          = @"rippleEffect";          //滴水效果 如波纹 （不支持过渡方向）
static NSString const *  kJVCAnimationMacroPageCurl              = @"pageCurl";              //向上翻页效果
static NSString const *  kJVCAnimationMacroPageUnCurl            = @"pageUnCurl";            //向下翻页效果
static NSString const *  kJVCAnimationMacroCameraIrisHollowOpen  = @"cameraIrisHollowOpen";  //镜头开 （不支持过渡方向）
static NSString const *  kJVCAnimationMacroCameraIrisHollowClose = @"cameraIrisHollowClose"; //镜头关 （不支持过渡方向）

#endif
