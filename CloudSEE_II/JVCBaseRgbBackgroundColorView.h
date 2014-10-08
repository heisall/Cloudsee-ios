//
//  JVCBaseRgbBackgroundColorView.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCBaseRgbBackgroundColorView : UIView


/**
 *  设置View的位置背景色 圆角
 *
 *  @param frame           view的位置和大小
 *  @param backgroundColor 背景色
 *  @param cornerRadius    圆角大小
 *
 *  @return View
 */
- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

/**
 *  UIView转Image
 *
 *  @return 转换后的Image
 */
-(UIImage *)imageWithUIView;


@end
