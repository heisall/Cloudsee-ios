//
//  JVCSignleAlarmDisplayView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSignleAlarmDisplayView.h"
#import "JVCCloudSEENetworkHelper.h"

@implementation JVCSignleAlarmDisplayView

@synthesize tAlarmModel;
@synthesize palyVideoDelegate;

//static const NSInteger  TIMER = 6;
//
//static const NSInteger  HUBTAG = 12683;

static const NSInteger  BTNTAG = 12683;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initView
{
    UIControl *contrlBg = [[UIControl alloc] initWithFrame:self.frame];
    [contrlBg addTarget:self action:@selector(ClickbackGroud) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contrlBg];
    [contrlBg release];
    
    UIImage *imageBg = [UIImage imageNamed:@"alarmBG.png"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - imageBg.size.width)/2.0, 120, imageBg.size.width, imageBg.size.height)];
    UIImageView *imageViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    imageViewbg.image =imageBg;
    [contentView addSubview:imageViewbg];
    [imageViewbg release];
    
    //报警图片
    UIImage *iamgeDefault = [UIImage imageNamed:@"alarmDefault.png"];
    UIImageView *imageView = [[UIImageView alloc] init];//
    imageView.frame =CGRectMake((contentView.frame.size.width - iamgeDefault.size.width)/2.0, 15, iamgeDefault.size.width, iamgeDefault.size.height);
    if (tAlarmModel.strAlarmLocalPicURL.length>0) {
        
       NSString *stringPath =  [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:@"1414637512.864878.jpg"];
        
        UIImage *iamgeAlarm = [[UIImage alloc] initWithContentsOfFile:stringPath];
        if (iamgeAlarm ==nil|| [iamgeAlarm isKindOfClass:[NSNull class]]) {
            
            imageView.image = iamgeDefault;

        }else{
            imageView.image = iamgeAlarm;

        }
//        imageView.image = iamgeAlarm;

        [iamgeAlarm release];

    }else{
        
        imageView.image = iamgeDefault;

    }
    
    [contentView addSubview:imageView];
    [imageView release];
    
    //报警时间
    UILabel *labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.size.height+imageView.frame.origin.y+10, contentView.frame.size.width, 20)];
    labelTimer.backgroundColor = [UIColor clearColor];
    labelTimer.font = [UIFont systemFontOfSize:14];
    labelTimer.textColor = [UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1];
    labelTimer.textAlignment = UITextAlignmentLeft;
    labelTimer.text = [NSString stringWithFormat:@"%@",self.tAlarmModel.strAlarmTime];
    [contentView addSubview:labelTimer];
    [labelTimer release];
    
    /**
     *  横线
     */
    UILabel *labelHor = [[UILabel alloc] initWithFrame:CGRectMake(10, labelTimer.frame.size.height+labelTimer.frame.origin.y, contentView.frame.size.width-20, 0)];
    labelHor.backgroundColor = [UIColor grayColor];
    [contentView addSubview:labelHor];
    [labelHor release];
    
    /**
     *  查看视频
     */
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgBtnNormal = [UIImage imageNamed:@"alarmBtnHover.png"];
    UIImage *imgBtnUnUse = [UIImage imageNamed:@"alarmBtnNormal.png"];

    btn.frame = CGRectMake((contentView.frame.size.width-imgBtnNormal.size.width)/2.0, labelTimer.frame.size.height+labelTimer.frame.origin.y+5, imgBtnNormal.size.width, imgBtnNormal.size.height);
    [btn setBackgroundImage:imgBtnNormal forState:UIControlStateNormal];
    btn.tag = BTNTAG;
    [btn addTarget:self action:@selector(clickedToPlayView) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:btn];
    if (self.tAlarmModel.strAlarmVideoUrl.length ==0) {
        
        [btn setBackgroundImage:imgBtnUnUse forState:UIControlStateNormal];
        
        [btn setTitle:LOCALANGER(@"home_no_Alarm_video") forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
         btn.enabled = NO;
        
    }else{
    
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:LOCALANGER(@"home_alarm_watch_video") forState:UIControlStateNormal];
        [btn setBackgroundImage:imgBtnNormal forState:UIControlStateNormal];
        
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:LOCALANGER(@"home_alarm_watch_video") forState:UIControlStateNormal];
    [btn setBackgroundImage:imgBtnNormal forState:UIControlStateNormal];

    [self addSubview:contentView];
    [contentView release];
    
}

/**
 *  播放视频
 */
- (void)clickedToPlayView
{
    
    if (palyVideoDelegate!=nil&&[palyVideoDelegate respondsToSelector:@selector(playVideoCallBack:)]) {
        
        NSLog(@"%@===",self.tAlarmModel.strAlarmLocalPicURL);
        
        [palyVideoDelegate playVideoCallBack:self.tAlarmModel];
        
    }
    
}


- (void)ClickbackGroud
{
    [self removeWithAnimation];
    
}

-(void)removeWithAnimation
{
    CABasicAnimation *reverseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    reverseAnimation.duration = 0.5;
    reverseAnimation.beginTime =  0.5;
    reverseAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    reverseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    reverseAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: reverseAnimation, nil];
    animationGroup.delegate = self;
    animationGroup.duration = reverseAnimation.duration +0.5;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    static NSString * const kRemoveStr = @"remove";
    
    [self.layer addAnimation:animationGroup
                      forKey:kRemoveStr];
    
}

#pragma mark - Core animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) {
       
        if (palyVideoDelegate!=nil&&[palyVideoDelegate respondsToSelector:@selector(jvcSingleAlarmClickBackGroundCallBack)]) {
            
            [palyVideoDelegate jvcSingleAlarmClickBackGroundCallBack];
            
        }
        [self removeFromSuperview];
    }
}

- (void)dealloc
{
    [tAlarmModel release];
    [super dealloc];
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
