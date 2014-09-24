//
//  JVCAppHelper.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAppHelper : NSObject

/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCAppHelper *)shareJVCRGBHelper;

/**
 *  获取指定索引View在矩阵视图中的位置
 *
 *  @param SuperViewWidth 父视图的宽
 *  @param viewCGRect     子视图的坐标
 *  @param nColumnCount   一列几个元素
 *  @param viewIndex      矩阵中的索引 （从1开始）
 */
-(void)viewInThePositionOfTheSuperView:(CGFloat)SuperViewWidth viewCGRect:(CGRect &)viewCGRect  nColumnCount:(int)nColumnCount viewIndex:(int)viewIndex;

@end
