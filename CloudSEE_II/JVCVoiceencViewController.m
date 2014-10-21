//
//  JVCVoiceencViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencViewController.h"
#import "JVCVoiceencInteface.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCScanNewDeviceViewController.h"
#import "JVCVoiceencHelpViewController.h"
#import "JVCSystemSoundHelper.h"

@interface JVCVoiceencViewController (){
    
    UIImageView *sendButton;
    UIView      *backGroud;
}

@end

@implementation JVCVoiceencViewController

@synthesize strSSID,strPassword;

static const  int              kDefaultSamplerate                       = 48000;
static const  int              kDefaultSignalCount                      = 60; //信号的数量值越大越好 建议40
static const  int              kVoiceencSettingCount                    = 3;
static const  CGFloat          kSendButtonWithTop                       = 150.0f;
static const  CGFloat          kScanfBgWithRadius                       = 52.0f;
static const  CFTimeInterval   kAnimatinDuration                        = 1.0f;
static NSString const         *kAnimatinDurationKey                     = @"pulse";

static const  CGFloat          kNetButtonWithSendButtonTop              = 100.0f;

static const    CGFloat        kTitleLableFontSize                      = 14.0;
static const    CGFloat        kTitleLableFontHeight                    = kTitleLableFontSize + 4.0;
static const    CGFloat        kTitleLableWithBgViewTop                 = 30.0;
static const    CGFloat        kVoiceencHelpButtonWithSendButtonBottom  = 80.0;

char encodeInputAudio[kDefaultSamplerate ]   = {0};
char encodeOutAudio[kDefaultSamplerate *2]   = {0};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"声波配置";
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    OpenALBufferViewcontroller *openAL = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    [openAL initOpenAL];
    
    UIImage *sendbtnImage = [UIImage imageNamed:@"voi_sendBtn.png"];
    
    
    CGFloat sendButtonWidth   = sendbtnImage.size.width*0.8;
    
    sendButton                 = [[UIImageView alloc] init];
    sendButton.frame           = CGRectMake((self.view.frame.size.width - sendButtonWidth)/2.0, kSendButtonWithTop, sendButtonWidth, sendButtonWidth);
    [[sendButton layer] setCornerRadius:sendButtonWidth/2.0];
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.image           = sendbtnImage;
    sendButton.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *singleCilck = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation)];
    singleCilck.numberOfTapsRequired    = 1;
    [sendButton addGestureRecognizer:singleCilck];
    [singleCilck release];
    
    UIImage *helpeImage            =  [UIImage imageNamed:@"voi_help_btn.png"];
    
    UIButton *helperButton         = [UIButton buttonWithType:UIButtonTypeCustom];
    helperButton.backgroundColor   = [UIColor clearColor];
    [helperButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    CGRect rectHelprButton ;
    
    rectHelprButton.size      = helpeImage.size;
    rectHelprButton.origin.y  = sendButton.frame.origin.y - kVoiceencHelpButtonWithSendButtonBottom - helpeImage.size.height;
    rectHelprButton.origin.x  = ( self.view.frame.size.width - helpeImage.size.width ) / 2.0;
    helperButton.frame             = rectHelprButton;
    [helperButton setBackgroundImage:helpeImage forState:UIControlStateNormal];
    [helperButton addTarget:self action:@selector(gotoHelpeViewController) forControlEvents:UIControlEventTouchUpInside];
    [helperButton setTitle:@"观看操作演示" forState:UIControlStateNormal];
    [self.view addSubview:helperButton];
    
    backGroud          = [[UIView alloc] init];
    backGroud.backgroundColor  = [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    backGroud.frame            = CGRectMake(sendButton.frame.size.width/2.0 + sendButton.frame.origin.x - kScanfBgWithRadius, sendButton.frame.origin.y + sendButton.frame.size.height/2.0 - kScanfBgWithRadius, kScanfBgWithRadius*2, kScanfBgWithRadius*2);
    [[backGroud layer] setCornerRadius:kScanfBgWithRadius];
    [self.view addSubview:backGroud];
    [backGroud release];
    
    [self.view addSubview:sendButton];
    [sendButton release];
    
    UIImage *nextButtonImage = [UIImage imageNamed:@"voi_next.png"];
    
    UILabel *titleLbl        = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLbl.textAlignment   = NSTextAlignmentCenter;
    titleLbl.numberOfLines   = 1;
    titleLbl.font            = [UIFont systemFontOfSize:kTitleLableFontSize];
    titleLbl.frame           = CGRectMake(backGroud.frame.origin.x, backGroud.frame.origin.y + kTitleLableWithBgViewTop + backGroud.frame.size.height, backGroud.frame.size.width,kTitleLableFontHeight);
    titleLbl.text            = @"点击发送声波";
    [self.view addSubview:titleLbl];
    [titleLbl release];
    
    CGRect rectNextButton;
    rectNextButton.size      = nextButtonImage.size;
    rectNextButton.origin.x  = (self.view.frame.size.width - rectNextButton.size.width)/2.0;
    rectNextButton.origin.y  = sendButton.frame.size.height + sendButton.frame.origin.y + kNetButtonWithSendButtonTop;
    
    UIButton *button         = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor   = [UIColor clearColor];
    button.frame             = rectNextButton;
    [button setBackgroundImage:nextButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoLanSerchDevice) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

/**
 *  前往声波配置帮助视图
 */
-(void)gotoHelpeViewController{
    
    JVCVoiceencHelpViewController *vocHelper = [[JVCVoiceencHelpViewController alloc] init];
    
    [self.navigationController pushViewController:vocHelper animated:YES];
    
    [vocHelper release];
}

/**
 *  前往扫描设备界面
 */
-(void)gotoLanSerchDevice{
    
    JVCScanNewDeviceViewController *sacnNewDeviceController = [[JVCScanNewDeviceViewController alloc] init];
    
    [self.navigationController pushViewController:sacnNewDeviceController animated:YES];
    
    [sacnNewDeviceController release];

}

-(void)startAnimation{
    
    
    if ([backGroud.layer animationForKey:(NSString *)kAnimatinDurationKey]) {
        
        return;
    }
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimatinDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    //self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @5.0;
    scaleAnimation.duration = kAnimatinDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration             = kAnimatinDuration;
    opacityAnimation.values               = @[@0.6, @0.6, @0.0];
    opacityAnimation.keyTimes             = @[@0, @0.2, @1.0];
    opacityAnimation.removedOnCompletion  = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    animationGroup.animations = animations;
    
    [backGroud.layer addAnimation:animationGroup forKey:(NSString *)kAnimatinDurationKey];
    
    //开始播放声波数据
    [NSThread detachNewThreadSelector:@selector(playVoiceenSound) toTarget:self withObject:nil];
}

/**
 *  播放声波音频数据
 */
-(void)playVoiceenSound{
    
    OpenALBufferViewcontroller *openAL = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    
    int len;
    
    char *p =(char *) [[NSString stringWithFormat:@"%@;%@",self.strSSID,self.strPassword] UTF8String];
    
    memset(encodeInputAudio, 0, sizeof(encodeInputAudio));
    
    //把要发送的数据，编码成适合的数据
    len = voiceenc_data2code((unsigned char *)p, strlen(p), (unsigned char *)encodeInputAudio, sizeof(encodeInputAudio));
    
    for (int j= 0 ; j< kVoiceencSettingCount; j++) {
        
        int i;
        
        for (i=0;i<len;i++)
        {
            memset(encodeOutAudio, 0, sizeof(encodeOutAudio));
            
            int al = voiceenc_code2pcm_16K16Bit(kDefaultSamplerate, kDefaultSignalCount, encodeInputAudio[i], (unsigned char *)encodeOutAudio, sizeof(encodeOutAudio));
            
           [openAL openAudioFromQueue:(short *)encodeOutAudio dataSize:al playSoundType:playSoundType_16k16B];
            
        }
        while ([openAL checkOpenAlStatus] != AL_STOPPED) {
            
        }
        usleep(200*1000);
        
        [openAL clear];
        
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        while ([openAL checkOpenAlStatus] != AL_STOPPED) {
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [backGroud.layer removeAnimationForKey:(NSString *)kAnimatinDurationKey];
        });
        
    });
    
}

/**
 *  发现一个新设备，提示音
 */
-(void)playSound {
    
    NSString *path = [[NSBundle mainBundle ] pathForResource:@"voi_send" ofType:@"mp3"];
    
    if (path) {
        
        [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:path withIsRunloop:NO];
    }
   
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self playSound];
}

-(void)initLayoutWithViewWillAppear {
    
    [self playSound];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];
}

-(void)dealloc{

    [strSSID release];
    [strPassword release];
    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
