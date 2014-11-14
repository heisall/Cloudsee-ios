//
//  JVCNetworkSettingWithTopItem.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCNetworkSettingWithTopItem : UIView

/**
 *  顶部按钮的初始化
 *
 *  @param frame 顶部视图的位置
 *  @param title 顶部视图的标题
 *
 *  @return 一个顶部按钮视图
 */
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

/**
 *  设置标题字体的颜色是否选中
 *
 *  @param selected YES:选中 NO:未选中
 */
-(void)isSelected:(BOOL)selected;

@end
