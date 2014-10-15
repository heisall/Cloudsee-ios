//
//  JVCScanNewDeviceViewController.m
//  CloudSEE_II
//  声波配置扫描设备界面，扫描设备成功，添加声波配置的设备
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCScanNewDeviceViewController.h"

@interface JVCScanNewDeviceViewController () {
    
    UIView      *backGroud;
}

@end

@implementation JVCScanNewDeviceViewController

static const    CFTimeInterval  kScanfWithAnimationDuration          = 10.0f;  //动画执行的时间
static const    CFTimeInterval  kScanfWithDurationBeginAnimationTime = 0.5f;   //延时动画的时间
static const    CFTimeInterval  kScanfAnimationWithKeepTime          = 120.0f; //动画持续的时间
static const    CGFloat         kBackButtonWithTop                   = 20.0f;
static const    CGFloat         kBackButtonWithLeft                  = 15.0f;
static NSString const          *kRotationAnimationKeyName            = @"scanRotation";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    return self;
}


-(void)initLayoutWithViewWillAppear {

    [self scanDeviceMath];
}

-(void)deallocWithViewDidDisappear {

    if ([backGroud.layer animationForKey:(NSString *)kRotationAnimationKeyName]) {
        
        [backGroud.layer removeAnimationForKey:(NSString *)kRotationAnimationKeyName];
    }
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [super viewDidLoad];
    UIImage *bgImage            = [UIImage imageNamed:@"sca_bg.png"];
    UIImageView *bgImageView    = [[UIImageView alloc] init];
    bgImageView.frame           = CGRectMake(0.0, 0.0, bgImage.size.width, self.view.frame.size.height);
    bgImageView.image           = bgImage;
    bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgImageView];
    
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];
        
    }

    UIImage *sendImage        = [UIImage imageNamed:@"sca_log"];
    
    CGFloat sendButtonWidth   = sendImage.size.width;
    
    UIImageView *sendButton    = [[UIImageView alloc] init];
    sendButton.frame           = CGRectMake((self.view.frame.size.width - sendButtonWidth)/2.0, bgImageView.frame.size.height/2.0 - sendButtonWidth/2.0 , sendButtonWidth, sendButtonWidth);
    [[sendButton layer] setCornerRadius:sendButtonWidth/2.0];
    sendButton.image           = sendImage;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.userInteractionEnabled= YES;
    
    UIImage *scanImage = [UIImage imageNamed:@"sca_ani.png"];
    
    CGFloat kScanfBgWithRadius = scanImage.size.width + 80;
    
    backGroud                  = [[UIView alloc] init];
    backGroud.backgroundColor  = [UIColor clearColor];
    backGroud.frame            = CGRectMake(sendButton.frame.size.width/2.0 + sendButton.frame.origin.x - kScanfBgWithRadius, sendButton.frame.origin.y + sendButton.frame.size.height/2.0 - kScanfBgWithRadius, kScanfBgWithRadius*2, kScanfBgWithRadius*2);
    [self.view addSubview:backGroud];
    [backGroud release];
    
    UIImageView *line    = [[UIImageView alloc] init];
    line.frame           = CGRectMake(0.0, kScanfBgWithRadius , kScanfBgWithRadius, kScanfBgWithRadius);
    line.backgroundColor = [UIColor clearColor];
    line.image           = scanImage;
    [backGroud addSubview:line];
    [line release];
    
    [self.view addSubview:sendButton];
    [sendButton release];
    
    [bgImageView release];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(kBackButtonWithLeft, kBackButtonWithTop, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [self performSelector:@selector(scanDeviceMath) withObject:nil afterDelay:kScanfWithDurationBeginAnimationTime];
    
}

/**
 *  返回上一级
 */
-(void)popClick{
    
    if ([backGroud.layer animationForKey:(NSString *)kRotationAnimationKeyName]) {
        
        [backGroud.layer removeAnimationForKey:(NSString *)kRotationAnimationKeyName];
    }
    
    [self BackClick];
}

-(void)scanDeviceMath{
    
    CABasicAnimation *rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue           = [NSNumber numberWithFloat:(2 * M_PI) ];
    rotationAnimation.duration          = kScanfWithAnimationDuration;
    rotationAnimation.delegate          = self;
    rotationAnimation.repeatCount       = kScanfAnimationWithKeepTime / kScanfWithAnimationDuration;
    [backGroud.layer addAnimation:rotationAnimation forKey:(NSString *)kRotationAnimationKeyName];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [self BackClick];
}

/**
 *  返回事件
 */
-(void)BackClick{

    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
