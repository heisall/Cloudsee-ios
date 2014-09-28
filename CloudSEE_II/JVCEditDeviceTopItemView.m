//
//  JVCEditDeviceTopItemView.m
//  JVCEditDevice
//  设备管理的顶部滚动条的单个按钮视图
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditDeviceTopItemView.h"
#import "JVCRGBHelper.h"

@interface JVCEditDeviceTopItemView (){

    UIView   *underlineView;
    BOOL     isSelected;
    UILabel  *titleLbl;
}

@end

@implementation JVCEditDeviceTopItemView

static const CGFloat kUnderlineViewHeight  = 3.0f;

/**
 *  初始化带下划线的标签
 *
 *  @param frame              位置和大小
 *  @param title              标签的文本
 *  @param titleLableFontSize 文本的字体大小
 *
 *  @return 标签View
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleLableFontSize:(CGFloat)titleLableFontSize
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        titleLbl = [[UILabel alloc] init];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        titleLbl.numberOfLines = 1;
        titleLbl.font = [UIFont systemFontOfSize:titleLableFontSize];
        titleLbl.frame = CGRectMake(0.0, 0.0, self.frame.size.width,self.frame.size.height);
        titleLbl.text  = title;
        [self addSubview:titleLbl];
        [titleLbl release];
        
        /**初始化底部的下划线**/
        underlineView = [[UIView alloc] init];
        //设置边框的颜色
        underlineView.frame = CGRectMake(0.0, self.frame.size.height - kUnderlineViewHeight, self.frame.size.width, kUnderlineViewHeight);
        [self addSubview:underlineView];
        [underlineView release];
        
        isSelected = FALSE;
        
        [self setTitleColor];
        [self setUnderlineViewColor];
    }
    
    return self;
}

/**
 *  设置View的状态
 *
 *  @param selected YES:选中 NO:未选中
 */
- (void)setViewSatus:(BOOL)selected{
    
    if (selected != isSelected) {
        
        isSelected = selected;
        [self setTitleColor];
        [self setUnderlineViewColor];
    }
}

//设置标题的颜色
-(void)setTitleColor{

    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *titleColor = [rgbHelper rgbColorForKey:(isSelected == YES ? kJVCRGBColorMacroEditDeviceTopBarItemSelectFontColor: kJVCRGBColorMacroEditDeviceTopBarItemUnselectFontColor)];
    
    if (titleColor) {
        
        titleLbl.textColor = titleColor;
    }
}

/**
 * 设置底部边框的颜色
 */
-(void)setUnderlineViewColor{
    
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    if (isSelected == YES) {
        
        UIColor *UnderlineViewColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditDeviceTopBarItemSelectUnderlineViewColor];
        
        if (UnderlineViewColor) {
            
            underlineView.backgroundColor = UnderlineViewColor;
        }
        
    }else {
    
        underlineView.backgroundColor = [UIColor clearColor];
    }
}

@end
