//
//  JVCCustomDatePickerView.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JVCCustomDatePickerViewDelegate <NSObject>


/**
 *  选择结束的回调
 *
 *  @param strSelectedTime 当前选择的时间
 *  @param nClickIndex     选择的时间
 */
-(void)JVCCustomDatePickerViewSelectedFinshedCallBack:(NSString *)strSelectedTime withButtonClickIndex:(int)nClickIndex;

@end

@interface JVCCustomDatePickerView : UIView {

    id <JVCCustomDatePickerViewDelegate> jvcCustomDatePickerViewDelegate;
}

enum JVCCustomDatePickerViewClickType {


    JVCCustomDatePickerViewClickTypeSure    = 0,
    JVCCustomDatePickerViewClickTypeCancel  = 1,

};

@property (nonatomic,assign) id <JVCCustomDatePickerViewDelegate> jvcCustomDatePickerViewDelegate;

/**
 *  初始化日期控件的视图
 *
 *  @param frame   父视图大小
 *  @param strTime 当前选择的时间
 *
 *  @return 日期控件的视图
 */
-(id)initWithFrame:(CGRect)frame withSelectTime:(NSString *)strTime;

@end
