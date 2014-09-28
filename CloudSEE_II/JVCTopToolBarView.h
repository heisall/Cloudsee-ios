//
//  JVCTopToolBarView.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JVCTopToolBarViewDelegate <NSObject>

/**
 *  当前云视通号索引
 *
 *  @param index 云视通号索引
 */
-(void)topItemSelectedIndex:(int)index;

@end

@interface JVCTopToolBarView : UIScrollView {

    id<JVCTopToolBarViewDelegate> jvcTopToolBarViewDelegate;
}

@property (nonatomic,assign) id<JVCTopToolBarViewDelegate> jvcTopToolBarViewDelegate;

/**
 *  初始化设备管理的顶部工具栏
 *
 *  @param titles 标题集合
 */
-(void)initWithLayout:(NSArray *)titles;

/**
 *  根据索引选中顶部的操作按钮
 *
 *  @param index 索引
 */
-(void)setSelectedTopItemAtIndex:(int)index;
@end
