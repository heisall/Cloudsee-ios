//
//  JVCAPConfigMiddleView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JVCAPOperationMiddleViewDelegate <NSObject>

/**
 *  按钮按下的回调
 *
 *  @param buttonType 选中的那个button
 */
- (void)ApConfigoperationMiddleViewButtonCallback:(int)buttonType;

@end
@interface JVCAPConfigMiddleView : UIView
{
    id<JVCAPOperationMiddleViewDelegate>delegateApOperationMiddle;
}
@property(nonatomic,assign)id<JVCAPOperationMiddleViewDelegate>delegateApOperationMiddle;


/**
 *  单例
 *
 *  @return 返回单例
 */
+ (JVCAPConfigMiddleView *)shareAPConfigMiddleInstance;

/**
 *  设置middleview
 *
 *  @param titileArray 显示文本
 *  @param frame       frame大小
 *  @param skinType    皮肤颜色
 */
- (void)updateAPViewWithTitleArray:(NSArray *)titileArray;

/**
 *  设置button的状态为选中状态
 *
 *  @param buttonIndex button的索引
 *  @param skinType    皮肤
 */
- (void)setAPConfigButtonSelect:(int)buttonIndex;

/**
 *  设置button为非选中状态
 */
- (void)setButtonunSelect:(int )buttonindex;

/**
 *  返回iphone4/4s按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getBtnSelectState:(int)buttonIndex;

/**
 *  获取相应的按钮
 *
 *  @param index 索引
 *
 *  @return btn
 */
-(UIButton *)getSelectbtn:(int)index;

@end
