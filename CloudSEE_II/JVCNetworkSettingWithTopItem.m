//
//  JVCNetworkSettingWithTopItem.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCNetworkSettingWithTopItem.h"

@interface JVCNetworkSettingWithTopItem (){
    
    UILabel *titleLbl;
}

@end
@implementation JVCNetworkSettingWithTopItem

static const CGFloat  kTitleWithFontSize = 14.0f;

/**
 *  顶部按钮的初始化
 *
 *  @param frame 顶部视图的位置
 *  @param title 顶部视图的标题
 *
 *  @return 一个顶部按钮视图
 */
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor =[UIColor clearColor];
        
        titleLbl                 = [[UILabel alloc] init];
        titleLbl.frame           = CGRectMake(0.0, 0.0, self.bounds.size.width,self.bounds.size.height);
        titleLbl.text            = title;
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.font            = [UIFont systemFontOfSize:kTitleWithFontSize];
        titleLbl.textColor       = SETLABLERGBCOLOUR(61.0, 115.0, 175.0);
        titleLbl.textAlignment   = UITextAlignmentCenter;
        
        [self addSubview:titleLbl];
        [titleLbl release];
    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
}

/**
 *  设置标题字体的颜色是否选中
 *
 *  @param selected YES:选中 NO:未选中
 */
-(void)isSelected:(BOOL)selected{
    
    titleLbl.textColor = selected == YES?SETLABLERGBCOLOUR(255.0, 255.0, 255.0):SETLABLERGBCOLOUR(61.0, 115.0, 175.0);
}


@end
