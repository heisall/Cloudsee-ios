//
//  JVCBaseWithTopToolViewAndDropListViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCTopToolBarView.h"
#import "JVCAnimationHelper.h"
#import "JVCEditViewControllerDropListViewCell.h"

static const CGFloat        kDropTableViewHeight                 = 46.0f;  //下拉设备列表的Cell高度
static const NSTimeInterval kOperationViewAnimationScaleBig      = 0.7;    //功能按钮点击变大的延时时间
static const NSTimeInterval kOperationViewAnimationScaleRestore  = 0.5;    //功能按钮点击变大后恢复的延时时间
static const NSTimeInterval kDropListViewAnimationBegin          = 0.8;    //下拉视图下拉的延时时间
static const NSTimeInterval kDropListViewAnimationEnd            = 0.5;    //下拉视图收回的延时时间

@interface JVCBaseWithTopToolViewAndDropListViewController : JVCBaseWithGeneralViewController <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,JVCTopToolBarViewDelegate> {
    
    int                nIndex ;
    UITableView       *deviceListTableView;
    UIImageView       *dropImageView;
    NSMutableArray    *titles;
    JVCTopToolBarView *toolBarView;         //顶部工具条
    UIView            *operationView;
}

@property (nonatomic,assign) int nIndex;

/**
 *  初始化功能区域按钮
 */
-(void)initWithOperationView;

/**
 *  清除顶部滚动条
 */
-(void)clearToolView;

/**
 *  初始化顶部的布局
 */
-(void)initWithTopToolView;

/**
 *  动画借结束后处理逻辑
 */
-(void)animationEndCallBack;

/**
 *  下拉结束处理逻辑
 */
-(void)dropDownCilckEnd;

#pragma mark -------------JVCTopToolBarView delegate

-(void)topItemSelectedIndex:(int)index;

@end
