//
//  JVCYTOperaitonView.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCYTOperaitonView : UIView

/**
 *  初始化view
 *
 *  @param frame frame 大小
 *
 *  @return view对象
 */
- (id)initContentViewWithFrame:(CGRect)frame;

/**
 *  根据选中的项目设置，云台帮助界面显示
 *
 *  @param operationType tag
 */
-(void)showOperationTypeImageVIew:(int)operationType;

@end
