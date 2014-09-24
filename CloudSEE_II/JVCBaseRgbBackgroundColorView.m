//
//  JVCBaseRgbBackgroundColorView.m
//  JVCEditDevice
//  基于RGB颜色做背景图的View 提供圆角、设置背景颜色的方法
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseRgbBackgroundColorView.h"

@implementation JVCBaseRgbBackgroundColorView


/**
 *  设置View的位置背景色 圆角
 *
 *  @param frame           view的位置和大小
 *  @param backgroundColor 背景色
 *  @param cornerRadius    圆角大小
 *
 *  @return View
 */
- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = backgroundColor;
        
        if (cornerRadius > 0) {
            
            [[self layer] setCornerRadius:cornerRadius];
        }
    }
    return self;
}

@end
