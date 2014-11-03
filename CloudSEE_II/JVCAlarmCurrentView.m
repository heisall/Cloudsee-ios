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
#import "JVCAlarmMacro.h"

@interface JVCAlarmCurrentView ()
{
    JVCAlarmModel *alarmModelSelect;
}

@end
@implementation JVCAlarmCurrentView
static const int KOriginY  = 10;  // 距离左侧的距离
static const int KOriginLabelDevice  = 50;  // 距离左侧的距离
static const NSTimeInterval KAnimationTimer  = 0.5;  // 动画时间
static const int KLableTitleFont  = 18;  // 距离左侧的距离
static const int KLableDeatilFont  = 16;  // 动画时间

@synthesize AlarmDelegate;
static JVCAlarmCurrentView *_shareInstance = nil;
@synthesize bShowState;
@synthesize bIsInPlay;
/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCAlarmCurrentView *)shareCurrentAlarmInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            _shareInstance.bIsInPlay = NO;
            _shareInstance.bShowState = NO;
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}


- (void)initCurrentAlarmView:(JVCAlarmModel *)alarmModel;
{
    alarmModelSelect = [alarmModel retain];
    
    self.backgroundColor = RGBConvertColor(0, 0, 0, 0.8);
    
    for (UIView *viewTemp  in self.subviews) {
        [viewTemp removeFromSuperview];
    }
    
    UIControl *control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [control addTarget:self action:@selector(CloseCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
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
    UILabel *labelTitle = [[JVCControlHelper shareJVCControlHelper] labelWithText:LOCALANGER(@"JVCAlarmCurrentView_title")];
    [labelTitle retain];
    labelTitle.font = [UIFont systemFontOfSize:KLableTitleFont];
    labelTitle.font = [UIFont systemFontOfSize:KLableTitleFont];
    labelTitle.frame = CGRectMake(nSpan, KOriginY, imageView.width-nSpan, labelTitle.height);
    if (btnColorBlue) {
        labelTitle.textColor = btnColorBlue;
    }
    [imageView addSubview:labelTitle];
    [labelTitle release];
    
    //设备
//    UILabel *labelDevice = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",@"设备：",alarmModel.strYstNumber]];
    UILabel *labelDevice = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",LOCALANGER(@"JVCAlarmCurrentView_device"),alarmModel.strYstNumber]];
    labelDevice.font = [UIFont systemFontOfSize:KLableDeatilFont];
    labelDevice.font = [UIFont systemFontOfSize:KLableDeatilFont];

    [labelDevice retain];
    labelDevice.frame = CGRectMake(nSpan, KOriginLabelDevice, imageView.width-nSpan, labelTitle.height);
    if (btnColorGray) {
        labelDevice.textColor = btnColorGray;
    }
    [imageView addSubview:labelDevice];
    [labelDevice release];

    NSString *titleString = nil;
    
    switch (alarmModel.iAlarmType) {
            
        case ALARM_MOTIONDETECT:
            titleString = LOCALANGER(@"JVCAlarmCurrentView_motion");
            break;
        case ALARM_DOOR:
            titleString = LOCALANGER(@"JVCAlarmCurrentView_door");
            break;
            
        default:
            titleString = LOCALANGER(@"JVCAlarmCurrentView_another");
            break;
    }
    //类型
    UILabel *labelArmType = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",LOCALANGER(@"JVCAlarmCurrentView_type"),titleString]];
    [labelArmType retain];
    labelArmType.frame = CGRectMake(nSpan, labelDevice.bottom+KOriginY, imageView.width-nSpan, labelTitle.height);
    labelArmType.font = [UIFont systemFontOfSize:KLableDeatilFont];

    if (btnColorGray) {
        labelArmType.textColor = btnColorGray;
    }
    [imageView addSubview:labelArmType];
    [labelArmType release];
    
    //查看
    UIButton *btnCheck = [[JVCControlHelper shareJVCControlHelper]buttonWithTitile:LOCALANGER(@"JVCAlarmCurrentView_see") normalImage:@"arm_btn_bg.png" horverimage:nil];
    [btnCheck retain];
    btnCheck.frame = CGRectMake(labelArmType.left, labelArmType.bottom+KOriginY, btnCheck.width, btnCheck.height);
    [btnCheck addTarget:self action:@selector(WatchCurrentView) forControlEvents:UIControlEventTouchUpInside];

    [imageView addSubview:btnCheck];
    [btnCheck release];

    //忽略
    UIButton *btnNignorce = [[JVCControlHelper shareJVCControlHelper]buttonWithTitile:LOCALANGER(@"JVCAlarmCurrentView_ignorce") normalImage:@"arm_btn_bg.png" horverimage:nil];
    [btnNignorce retain];
    btnNignorce.frame = CGRectMake(btnCheck.right+nSpan, btnCheck.top, btnNignorce.width, btnNignorce.height);
    [btnNignorce release];
    [btnNignorce addTarget:self action:@selector(CloseCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnNignorce];
    [image release];
    [imageView release];

}

/**
 *  关闭报警
 */
- (void)CloseCurrentView
{
    [UIView animateWithDuration:KAnimationTimer
                     animations:^{
                     
                         self.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finish){
                         self.transform = CGAffineTransformIdentity;
                         _shareInstance.bShowState = NO;
                         if (alarmModelSelect != nil) {
                             [alarmModelSelect release];
                             alarmModelSelect = nil;
                         }
                         [self removeFromSuperview];
                     }];
}

- (void)WatchCurrentView
{
    [self CloseCurrentView];
    
    if (AlarmDelegate != nil && [AlarmDelegate respondsToSelector:@selector(JVCAlarmAlarmCallBack:)]) {
        
        [AlarmDelegate JVCAlarmAlarmCallBack:alarmModelSelect];
        
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
