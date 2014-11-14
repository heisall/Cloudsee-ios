//
//  JVCWireTableViewCell.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  JVCWireTableViewCellDelegate <NSObject>

/**
 *  文本框输入改变的回调
 *
 *  @param text  改变的内容
 *  @param index 在父类数组的索引
 */
-(void)textFiledWithTextChange:(NSString *)text withIndex:(int)index;

@end

@interface JVCWireTableViewCell : UITableViewCell <UITextFieldDelegate>{

    id<JVCWireTableViewCellDelegate> deleage;

}

@property (nonatomic,assign) id<JVCWireTableViewCellDelegate> deleage;

/**
 *  初始化单个cell的视图
 *
 *  @param title   标签名称
 *  @param text    文本框内容
 *  @param index   在数组的索引
 *  @param enabled 输入框是否允许输入
 */
- (void)initContentView:(NSString *)title  withTextFiled:(NSString *)text withIndex:(int)index withTextFiledEnabled:(BOOL)enabled;

/**
 *  如果正在输入，关闭键盘
 */
-(void)resignFirstResponderMath;
@end
