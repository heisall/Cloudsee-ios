//
//  JVCAlarmCurrentView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmCurrentView.h"
#import "JVCControlHelper.h"
#import "JVCAlarmModel.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"

@implementation JVCAlarmCurrentView
static const int KOriginY  = 10;  // 距离左侧的距离
static const int KOriginLabelDevice  = 60;  // 距离左侧的距离
static const NSTimeInterval KAnimationTimer  = 0.5;  // 动画时间

@synthesize AlarmDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCurrentAlarmView:(JVCAlarmModel *)alarmModel;
{
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
    [control addTarget:self action:@selector(CloseCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [self didAddSubview:control];
    [control release];
    
    
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *btnColorGray  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
    UIColor *btnColorBlue  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginBlue];
    
    NSString *path = [UIImage imageBundlePath:@"arm_btn_bg.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
   
    //背景
    UIImageView *imageView = [[JVCControlHelper shareJVCControlHelper] imageViewWithIamge:@"arm_diobg.png"];
    [imageView retain];
    imageView.frame = CGRectMake((self.width-imageView.width)/2.0, (self.height -imageView.height)/2.0 , imageView.width, imageView.height);
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    //关闭
    UIButton *btnClose = [[JVCControlHelper shareJVCControlHelper]buttonWithTitile:nil normalImage:@"arm_close.png" horverimage:nil];
    NSString *imageClosePath = [UIImage imageBundlePath:@"arm_close.png"];
    [btnClose addTarget:self action:@selector(CloseCurrentView) forControlEvents:UIControlEventTouchUpInside];

    UIImage *imageClose = [[UIImage alloc] initWithContentsOfFile:imageClosePath];
    [btnClose retain];
    
    btnClose.frame = CGRectMake(imageView.right - imageClose.size.width/2.0 , imageView.top - imageClose.size.height/2.0, btnClose.width, btnClose.height);
    [self addSubview:btnClose];
    [btnClose release];
    [imageClose release];
    
     int  nSpan = (imageView.size.width - image.size.width*2)/3.0;
    
    //label
    UILabel *labelTitle = [[JVCControlHelper shareJVCControlHelper] labelWithText:@"报警信息"];
    [labelTitle retain];
    labelTitle.frame = CGRectMake(nSpan, KOriginY, imageView.width-nSpan, labelTitle.height);
    if (btnColorBlue) {
        labelTitle.textColor = btnColorBlue;
    }
    [imageView addSubview:labelTitle];
    [labelTitle release];
    
    //设备
//    UILabel *labelDevice = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",@"设备：",alarmModel.strYstNumber]];
    UILabel *labelDevice = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",@"设备：",@"361"]];

    [labelDevice retain];
    labelDevice.frame = CGRectMake(nSpan, KOriginLabelDevice, imageView.width-nSpan, labelTitle.height);
    if (btnColorGray) {
        labelDevice.textColor = btnColorGray;
    }
    [imageView addSubview:labelDevice];
    [labelDevice release];

    //类型
    UILabel *labelArmType = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%d",@"类型：",4]];
    [labelArmType retain];
    labelArmType.frame = CGRectMake(nSpan, labelDevice.bottom+KOriginY, imageView.width-nSpan, labelTitle.height);
    if (btnColorGray) {
        labelArmType.textColor = btnColorGray;
    }
    [imageView addSubview:labelArmType];
    [labelArmType release];
    
    //查看
    UIButton *btnCheck = [[JVCControlHelper shareJVCControlHelper]buttonWithTitile:@"查看" normalImage:@"arm_btn_bg.png" horverimage:nil];
    [btnCheck retain];
    btnCheck.frame = CGRectMake(labelArmType.left, labelArmType.bottom+KOriginY, btnCheck.width, btnCheck.height);
    [btnCheck addTarget:self action:@selector(WatchCurrentView) forControlEvents:UIControlEventTouchUpInside];

    [imageView addSubview:btnCheck];
    [btnCheck release];

    //忽略
    UIButton *btnNignorce = [[JVCControlHelper shareJVCControlHelper]buttonWithTitile:@"忽略" normalImage:@"arm_btn_bg.png" horverimage:nil];
    [btnNignorce retain];
    btnNignorce.frame = CGRectMake(btnCheck.right+nSpan, btnCheck.top, btnNignorce.width, btnNignorce.height);
    [btnNignorce release];
    [btnNignorce addTarget:self action:@selector(CloseCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnNignorce];
    [image release];
    [imageView release];

}

- (void)CloseCurrentView
{
    [UIView animateWithDuration:KAnimationTimer
                     animations:^{
                     
                         self.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finish){
                     
                         [self removeFromSuperview];
                     }];
}

- (void)WatchCurrentView
{
    [self CloseCurrentView];
    
    if (AlarmDelegate != nil && [AlarmDelegate respondsToSelector:@selector(JVCAlarmAlarmCallBack:)]) {
        
        [AlarmDelegate JVCAlarmAlarmCallBack:AlarmType_Watch];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
