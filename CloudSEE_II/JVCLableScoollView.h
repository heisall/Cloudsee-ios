//
//  JVCLableScoollView.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCLableScoollView : UIScrollView <UIGestureRecognizerDelegate>

/**
 *  根据标签集合数据设置滚动视图的大小
 *
 *  @param titles 标签集合
 */
-(void)initWithLayout:(NSArray *)titles;

@end
