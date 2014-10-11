//
//  JVCLabelFieldSView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol JVCLabelFieldSViewDelegate <NSObject>

/**
 *  按钮按下的回调
 */
- (void)JVCLabelFieldBtnClickCallBack;

@end

@interface JVCLabelFieldSView : UIView
{
    id<JVCLabelFieldSViewDelegate>delegate;
}
@property(nonatomic,assign)id<JVCLabelFieldSViewDelegate>delegate;
- (void)initViewWithTitlesArray:(NSArray *)titleArray ;

/**
 *  获取指定的textField
 *
 *  @param index 第几个
 *
 *  @return 指定的textfield
 */
- (UITextField *)textFieldWithIndex:(int)index;

@end
