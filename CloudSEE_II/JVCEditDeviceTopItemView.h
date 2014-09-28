//
//  JVCEditDeviceTopItemView.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCEditDeviceTopItemView : UIView


/**
 *  初始化带下划线的标签
 *
 *  @param frame              位置和大小
 *  @param title              标签的文本
 *  @param titleLableFontSize 文本的字体大小
 *
 *  @return 标签View
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleLableFontSize:(CGFloat)titleLableFontSize;

/**
 *  设置View的状态
 *
 *  @param selected YES:选中 NO:未选中
 */
- (void)setViewSatus:(BOOL)selected;

@end
