//
//  JVCHorizontalScreenBar.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HORIZEROSCREENVIEWHEIGHT  44
enum TYPEHORIZONTAL
{
    HORIZONTALBAR_TACK          = 0,//对讲
    HORIZONTALBAR_CAPTURE       = 1,//拍照
    HORIZONTALBAR_VIDEO         = 2,//录像
    HORIZONTALBAR_AUDIO         = 3,//音频
    HORIZONTALBAR_RESTORE       = 4,//回放默认状态
    HORIZONTALBAR_ROTATION      = 5,//图片旋转
    HORIZONTALBAR_STREAM        = 6,//画质
    
    
};

@protocol HorizontalScreenBarDelegate <NSObject>

/**
 *  HorizontalScreenBar按钮按下的返回值
 *
 *  @param btn 传回相应的but
 */
- (void)HorizontalScreenBarBtnClickCallBack:(UIButton *)btn;

@end

@interface JVCHorizontalScreenBar : UIView
{
    id<HorizontalScreenBarDelegate>HorizontalDelegate;
    
    BOOL bStateHorigin;//用于横屏隐藏
    
}
@property(nonatomic,assign)id<HorizontalScreenBarDelegate>HorizontalDelegate;
@property(nonatomic,assign)BOOL bStateHorigin;
+(JVCHorizontalScreenBar *)shareHorizontalBarInstance;

/**
 *  设置按钮为选中状态
 *
 *  @param index 选中状态
 */
- (void)setBtnForSelectState:(int)index;

/**
 *  设置所有的按钮为非选中状态
 */
- (void)setALlBtnNormal;

/**
 *  设置按钮的选中状态为非选中状态
 *
 *  @param index 按钮索引
 */
-(void)setBtnForNormalState:(int)index;

/**
 *  返回按钮的选中状态
 *
 *  @param index 按钮索引
 */
- (BOOL)getBtnSelectStateWithIndex:(int)index;

/**
 *  设置码流标题
 */
- (void)setStreamBtnTitle:(NSString *)titile;


@end
