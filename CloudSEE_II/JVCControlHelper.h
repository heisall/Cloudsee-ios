//
//  JVCControlHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCControlHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCControlHelper *)shareJVCControlHelper;

/**
 *  返回label 字段
 *
 *  @param labelText 文本
 *  @param frame     frame
 *
 *  @return label 对象  （用的时候，retain 一下）
 */
- (UILabel *)labelWithText:(NSString *)labelText ;

/**
 *  根据文字和字体大小动态生成label
 *
 *  @param labelText 文字
 *  @param fontSize  文字大小
 *
 *  @return 返回label
 */
- (UILabel *)labelWithText:(NSString *)labelText
              textFontSize:(int)fontSize;

/**
 *  返回uiimageview对象
 *
 *  @param stringImage image的名称
 *
 *  @return imageview
 */
- (UIImageView *)imageViewWithIamge:(NSString *)stringImage;
/**
 *  返回按钮,不传入图片，默认btn的按钮大小
 *
 *  @param titileString 按钮的title
 *  @param normalImage  默认背景
 *  @param horverImage  高亮背景
 *
 *  @return button 对象
 */
- (UIButton *)buttonWithTitile:(NSString *)titileString
                   normalImage:(NSString *)normalImage
                   horverimage:(NSString *)horverImage;

/**
 *  获取textfiel
 *
 *  @param labelText 左侧lable显示的数据
 *  @param imageName 背景图片，没有的话显示默认的
 *
 *  @return textfield
 */
- (UITextField *)textFieldWithLeftLabelText:(NSString *)labelText
                            backGroundImage:(NSString *)imageName;
@end
