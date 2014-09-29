//
//  JVCBaseRgbBackgroundColorView.m
//  JVCEditDevice
//  基于RGB颜色做背景图的View 提供圆角、设置背景颜色的方法
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseRgbBackgroundColorView.h"
#import  <QuartzCore/QuartzCore.h>

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
            
            self.layer.cornerRadius  = cornerRadius;
            self.layer.borderWidth   = 0.0;
            self.layer.borderColor   = [UIColor clearColor].CGColor;
            self.layer.masksToBounds = YES;
        }
    }
    return self;
}

/**
 *  UIView转Image
 *
 *  @return 转换后的Image
 */
-(UIImage *)imageWithUIView{

    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return image;
}

@end
