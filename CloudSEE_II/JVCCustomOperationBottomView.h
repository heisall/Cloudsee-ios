//
//  JVCCustomOperationBottomView.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol customBottomDelegate <NSObject>

/**
 *  按钮按下的事件回调
 */
- (void)customBottomPressCallback:(NSUInteger )buttonPress;

@end


enum ButtomPressType
{
    
    BUTTON_TYPE_CAPTURE=0,//按下抓拍
    BUTTON_TYPE_TALK,     //对讲
    BUTTON_TYPE_VIDEO,    //录像
    BUTTON_TYPE_MORE,     //更多
};


enum VideoStreamType
{
    VideoStreamType_Default = 0,//默认
    VideoStreamType_HD,        //高清
    VideoStreamType_SD,        //标清
    VideoStreamType_FL,         //流畅
};


@interface JVCCustomOperationBottomView : UIView
{
    
    id<customBottomDelegate>BottomDelegate;
    
}

@property(nonatomic,assign) id<customBottomDelegate>BottomDelegate;

/**
 *  单例
 *
 *  @return 返回 单例
 */
+ (JVCCustomOperationBottomView *)shareInstance;

/**
 *  初始化播放视频底部view
 *
 *  @param titileArray title的列表
 *  @param frame       frame大小
 *  @param skinType    皮肤类型
 *
 *  @return id类型
 */
- (void)updateViewWithTitleArray:(NSArray *)titileArray Frame:(CGRect)frame SkinType:(int)skinType;

/**
 *  根据index获取button
 *
 *  @param index 获取button的索引
 *
 *  @return 放回相应的bug，如果超出返回nil
 */
-(UIButton *)getButtonWithIndex:(int )index;

/**
 *  设置所有的按钮未选中状态
 */
- (void)setAllButtonUnselect;


/**
 *  设置单个按钮为未选中状态
 *
 *  @param index button的索引
 *
 *  @return yes 成功  no 失败
 */
- (BOOL)setbuttonUnSelectWithIndex:(int )index;

/**
 *  设置button的选中状态
 *
 *  @param index    要选中的button
 *  @param skinType 皮肤的标志
 *
 *  @return 成功yes  否则 no
 */
- (BOOL)setbuttonSelectStateWithIndex:(int )index andSkinType:(int )skinType;

/**
 *  换肤之后，重新设置选中的按钮颜色或设置按钮的hoverhight的颜色值
 *
 *  @param skinType 选中的皮肤颜色
 */
- (void)resetSelectButtonsWithSkinType:(int )skinType;

/**
 *  设置码流
 *
 *  @param stremType 码流类型
 */
- (void)setVideoStreamState:(int)stremType;


@end
