//
//  JVCRGBHelper.h
//  JVCEditDevice
//  颜色的助手类，用于获取颜色的rgb值
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCRGBModel.h"
#import "JVCRGBColorMacro.h"

@interface JVCRGBHelper : NSObject 

/**
 *  单例
 *
 *  @return 返回JVCRGBHelper的单例
 */
+ (JVCRGBHelper *)shareJVCRGBHelper;

/**
 *  根据RGBModel的键值获取UIColor对象
 *
 *  @param strkeyName RGBModel的键
 *  @param alpha      透明度
 *
 *  @return UIColor对象 不存在返回nil
 */
-(UIColor *)rgbColorForKey:(NSString const *)strkeyName alpha:(CGFloat)alpha;

/**
 *  根据RGBModel的键值获取UIColor对象
 *
 *  @param strkeyName RGBModel的键
 *
 *  @return UIColor对象 不存在返回nil
 */
-(UIColor *)rgbColorForKey:(NSString const *)strkeyName;

@end
