//
//  JVCOperationMiddleView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum TYPEBUTTONCLI
{
    TYPEBUTTONCLI_SOUND         =0,  //音频监听
    TYPEBUTTONCLI_YTOPERATION   =1,  //云台按下事件
    TYPEBUTTONCLI_PLAYBACK      =2,  //远程回调
    
};
static const NSString *BUNDLENAMEMiddle =  @"customMiddleView_cloudsee.bundle";

@protocol operationMiddleViewDelegate <NSObject>

/**
 *  按钮按下的回调
 *
 *  @param buttonType 选中的那个button
 */
- (void)operationMiddleViewButtonCallback:(int)buttonType;

@end

@interface JVCOperationMiddleView : UIView
{
    id<operationMiddleViewDelegate>delegateOperationMiddle;
}
@property(nonatomic,assign)id<operationMiddleViewDelegate>delegateOperationMiddle;


/**
 *  设置middleview
 *
 *  @param titileArray 显示文本
 *  @param frame       frame大小
 *  @param skinType    皮肤颜色
 */
- (void)updateViewWithTitleArray:(NSArray *)titileArray  frame:(CGRect)frame skinType:(int)skinType;

/**
 *  设置button的状态为选中状态
 *
 *  @param buttonIndex button的索引
 *  @param skinType    皮肤
 */
- (void)setSelectButtonWithIndex:(int)buttonIndex  skinType:(int)skinType;

/**
 *  设置所有的button为非选中状态
 */
- (void)setButtonSunSelect;

/**
 *  返回iphone4/4s按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getAudioBtnState;

@end
