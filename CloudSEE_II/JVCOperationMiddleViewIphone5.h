//
//  JVCOperationMiddleViewIphone5.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperationMiddleViewIphone5Delegate <NSObject>


-  (void)operationMiddleIphone5BtnCallBack:(int)clickBtnType;

@end

enum OPERATIONBTNCLICKTYPE
{
    OPERATIONBTNCLICKTYPE_AUDIO         =   0,//音频对讲
    OPERATIONBTNCLICKTYPE_YTOPERATION   =   1,//云台
    OPERATIONBTNCLICKTYPE_PLAYBACK      =   2,//远程回放
};

@interface JVCOperationMiddleViewIphone5 : UIView
{
    id<OperationMiddleViewIphone5Delegate>delegateIphone5BtnCallBack;
}
@property(nonatomic,assign)id<OperationMiddleViewIphone5Delegate>delegateIphone5BtnCallBack;

+ (JVCOperationMiddleViewIphone5 *)shareInstance;

/**
 *  这个方法之前，一定要设置view的frame
 *  显示音频监听、云台、远程回放view
 *
 *  @param titleArray  主title
 *  @param detailArray 副title
 *  @param skinType    皮肤
 */
- (void)updateViewWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray skinType:(int )skinType;

/**
 *  设置选中的btn的类型
 *
 *  @param skinType 皮肤
 */
- (void)setAudioBtnSelectWithSkin:(int)skinType;

/**
 *  设置btn为非选中状态
 */
- (void)setAudioBtnUNSelect;

/**
 *  点击背景的回调
 *
 *  @param gesture 手势
 */
- (void)clickBackGroup:(UITapGestureRecognizer *)gesture;

/**
 *  返回按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getAudioBtnState;

@end
