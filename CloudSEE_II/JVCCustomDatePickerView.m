//
//  JVCCustomDatePickerView.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCCustomDatePickerView.h"
#import "JVCSystemUtility.h"

@interface JVCCustomDatePickerView (){
    
    UIDatePicker *datePickerView;
}

@end

@implementation JVCCustomDatePickerView
@synthesize jvcCustomDatePickerViewDelegate;

static const CGFloat  kDatePickerHeight         = 240.0f;
static const CGFloat  kButtonWithBottom         = 20.0f;

/**
 *  初始化日期控件的视图
 *
 *  @param frame   父视图大小
 *  @param strTime 当前选择的时间
 *
 *  @return 日期控件的视图
 */
-(id)initWithFrame:(CGRect)frame withSelectTime:(NSString *)strTime{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImage *imgeBtn = [UIImage imageNamed:@"mor_logOut.png"];
        
        CGFloat  datePickerWidth         = imgeBtn.size.width;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame =CGRectMake((self.frame.size.width - datePickerWidth)/2.0, self.frame.size.height - kButtonWithBottom - imgeBtn.size.height,datePickerWidth,imgeBtn.size.height);
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:LOCALANGER(@"jvc_more_loginout_quit") forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:imgeBtn forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        
        
        UIButton *surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        surebtn.frame =CGRectMake((self.frame.size.width - datePickerWidth)/2.0, cancelBtn.frame.origin.y - cancelBtn.frame.size.height - kButtonWithBottom,datePickerWidth, imgeBtn.size.height);
        [surebtn addTarget:self action:@selector(selectedFinshedTimeClick) forControlEvents:UIControlEventTouchUpInside];
        [surebtn setTitle:LOCALANGER(@"jvc_more_loginout_ok") forState:UIControlStateNormal];
        [surebtn setBackgroundImage:imgeBtn forState:UIControlStateNormal];
        [self addSubview:surebtn];
        
        
        UIView *contentView              = [[UIView alloc] init];
        
        contentView.frame                = CGRectMake(0.0, surebtn.frame.origin.y - kDatePickerHeight, datePickerWidth, kDatePickerHeight);
        
        self.backgroundColor              = RGBConvertColor(0.0, 0.0, 0.0, 0.7);
        
        datePickerView                     = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datePickerView.datePickerMode      = UIDatePickerModeCountDownTimer;
        datePickerView.backgroundColor     = [UIColor whiteColor];
        
        datePickerView.layer.cornerRadius  = 5.0;
        datePickerView.layer.masksToBounds = YES;
        
        if (strTime) {
            
            NSDate *date = [[JVCSystemUtility shareSystemUtilityInstance] strHoursConvertDateHours:strTime];
            
            if (date) {
                
                [datePickerView setDate:date animated:YES];
            }
        }
        
        [contentView addSubview:datePickerView];
        
        [datePickerView release];
        [self addSubview:contentView];
        [contentView release];
    }
    
    return self;
}

/**
 *  确定事件
 */
-(void)selectedFinshedTimeClick{
    
    DDLogVerbose(@"%s----------date=%@",__FUNCTION__,[[JVCSystemUtility shareSystemUtilityInstance] DateHoursConvertStrHours:datePickerView.date]);

    if (self.jvcCustomDatePickerViewDelegate != nil && [self.jvcCustomDatePickerViewDelegate respondsToSelector:@selector(JVCCustomDatePickerViewSelectedFinshedCallBack:withButtonClickIndex:)]) {
        
        [self.jvcCustomDatePickerViewDelegate JVCCustomDatePickerViewSelectedFinshedCallBack:[[JVCSystemUtility shareSystemUtilityInstance] DateHoursConvertStrHours:datePickerView.date] withButtonClickIndex:JVCCustomDatePickerViewClickTypeCancel];
    }
}

/**
 *  取消事件
 */
-(void)cancelClick{
    
    DDLogVerbose(@"%s----------date=%@",__FUNCTION__,[[JVCSystemUtility shareSystemUtilityInstance] DateHoursConvertStrHours:datePickerView.date]);
    
    if (self.jvcCustomDatePickerViewDelegate != nil && [self.jvcCustomDatePickerViewDelegate respondsToSelector:@selector(JVCCustomDatePickerViewSelectedFinshedCallBack:withButtonClickIndex:)]) {
        
        [self.jvcCustomDatePickerViewDelegate JVCCustomDatePickerViewSelectedFinshedCallBack:[[JVCSystemUtility shareSystemUtilityInstance] DateHoursConvertStrHours:datePickerView.date] withButtonClickIndex:JVCCustomDatePickerViewClickTypeSure];
    }
}


@end
