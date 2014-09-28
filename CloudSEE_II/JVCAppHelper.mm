//
//  JVCAppHelper.m
//  CloudSEE_II
//  应用程序公共方法
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAppHelper.h"
#import "JVCAccountHelper.h"
#import "JVCSystemUtility.h"


@implementation JVCAppHelper

static JVCAppHelper *jvcAppHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCAppHelper的单例
 */
+ (JVCAppHelper *)shareJVCAppHelper
{
    @synchronized(self)
    {
        if (jvcAppHelper == nil) {
            
            jvcAppHelper = [[self alloc] init];
            
        }
        return jvcAppHelper;
    }
    return jvcAppHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcAppHelper == nil) {
            
            jvcAppHelper = [super allocWithZone:zone];
            
            return jvcAppHelper;
        }
    }
    return nil;
}

/**
 *  获取指定索引View在矩阵视图中的位置
 *
 *  @param SuperViewWidth 父视图的宽
 *  @param viewCGRect     子视图的坐标
 *  @param nColumnCount   一列几个元素
 *  @param viewIndex      矩阵中的索引 （从1开始）
 */
-(void)viewInThePositionOfTheSuperView:(CGFloat)SuperViewWidth viewCGRect:(CGRect &)viewCGRect  nColumnCount:(int)nColumnCount viewIndex:(int)viewIndex{
	
    CGFloat viewWidth  = viewCGRect.size.width;
    CGFloat viewHeight = viewCGRect.size.height;
    
    float spacing = (SuperViewWidth - viewWidth*nColumnCount ) / (nColumnCount + 1);
    
    int column    =  viewIndex % nColumnCount; // 1
    int row       =  viewIndex / nColumnCount; // 0
    
    if (column != 0 ) {
        
        row = row + 1;
        
    }else {
        
        column = nColumnCount;
    }
    
    viewCGRect.origin.x = spacing * column + viewWidth  * (column -1);
    viewCGRect.origin.y = spacing * row    + viewHeight * (row -1);
}





@end
