//
//  JVCEditDeviceOperationView.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseRgbBackgroundColorView.h"

@interface JVCEditDeviceOperationView : JVCBaseRgbBackgroundColorView

/**
 *  初始化视图控件布局
 *
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @param iconImage  图标
 */
-(void)initWithLayoutView:(NSString *)title titleColor:(UIColor *)titleColor iconImage:(UIImage *)iconImage;
@end
