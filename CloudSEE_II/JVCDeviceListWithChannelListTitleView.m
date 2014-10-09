//
//  JVCDeviceListWithChannelListTitleView.m
//  CloudSEE_II
//  单个通道标题的视图 （所属：JVCDeviceListWithChannelListViewController 使用）
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCDeviceListWithChannelListTitleView.h"
#import "JVCRGBHelper.h"

@implementation JVCDeviceListWithChannelListTitleView

@synthesize nChannelValueWithIndex;

static const CGFloat kTitleWithFontSize  = 14.0f;
static const CGFloat kTitleWithHeight    = 24.0f;

/**
 *  初始化标签视图
 *
 *  @param title 标题
 */
-(void)initWithTitleView:(NSString *)title {

    [title retain];
    
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UILabel *titleLbl        = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLbl.numberOfLines   = 1;
    titleLbl.font            = [UIFont systemFontOfSize:kTitleWithFontSize];
    titleLbl.frame           = CGRectMake(0.0, (self.frame.size.height - kTitleWithHeight)/2.0, self.frame.size.width,kTitleWithHeight);

    UIColor *titleColor  = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditDeviceButtonFont];
    
    if (titleColor) {
        
        titleLbl.textColor       = titleColor;
    }
  
    titleLbl.text            = title;
    titleLbl.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    [titleLbl release];
    
    [title release];
}

@end
