//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int , CustomAlertType) {
    
    CustomAlertType_btn_One = 0,//一个按钮
    
    CustomAlertType_btn_None = 1,//没有按钮
    
};

@interface DXAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)showCustomAlert:(int)type;

- (void)updateProgressViewProgress:(int)index;

- (id)initWithTitleAndProgress:(NSString *)title;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;



@end