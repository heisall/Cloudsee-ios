//
//  JVCEditDeviceOperationView.m
//  JVCEditDevice
//  视频编辑界面的单个功能按钮视图
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditDeviceOperationView.h"

@interface JVCEditDeviceOperationView () {

    UIImageView *iconImageView;

}

@end

@implementation JVCEditDeviceOperationView

-(void)dealloc{
    
    [super dealloc];
}

/**
 *  初始化视图控件布局
 *
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @param iconImage  图标
 */
-(void)initWithLayoutView:(NSString *)title titleColor:(UIColor *)titleColor iconImage:(UIImage *)iconImage {
    
    [title retain];
    [titleColor retain];
    [iconImage retain];
    
    //初始化图标
    
    iconImageView    = [[UIImageView alloc] init];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image           = iconImage;
    iconImageView.frame = CGRectMake((self.frame.size.width - iconImageView.image.size.width)/2.0, (self.frame.size.height - iconImageView.image.size.height)/3.0, iconImageView.image.size.width, iconImageView.image.size.height);
    [self addSubview:iconImageView];
    
    
    //初始化标题
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor    = titleColor;
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    int  subOffy = 5;
    int  heigin = 20;
    if (![[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        subOffy = 15;
        heigin = 40;
    }
    titleLbl.frame = CGRectMake(0.0,iconImageView.frame.size.height + iconImageView.frame.origin.y - subOffy, self.frame.size.width, heigin);
    titleLbl.numberOfLines = 0;
    titleLbl.lineBreakMode = UILineBreakModeWordWrap;
    titleLbl.font  = [UIFont systemFontOfSize:11];
    [self addSubview:titleLbl];
    [titleLbl release];
    
    [iconImageView release];
    
    [title release];
    [titleColor release];
    [iconImage release];
}

/**
 *
 *  @param iconImage 设置背景图片
 */
-(void)setIconImage:(UIImage *)iconImage {
    
    [iconImageView setImage:iconImage];


}

@end
