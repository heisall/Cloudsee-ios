//
//  JVCScanNewDeviceViewController.m
//  CloudSEE_II
//  声波配置扫描设备界面，扫描设备成功，添加声波配置的设备
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCScanNewDeviceViewController.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceMacro.h"
#import "JVCSystemConfigMacro.h"
#import "JVCDeviceSourceHelper.h"
#import "AppDelegate.h"
#import "JVCConfigModel.h"

@interface JVCScanNewDeviceViewController () {
    
    UIView       *backGroud;
    NSTimer      *scanfTimer;
    CGRect        scanfImageFrame;
    BOOL          isExit;
}

@end

@implementation JVCScanNewDeviceViewController

static const    CFTimeInterval  kScanfWithAnimationDuration          = 10.0f;  //动画执行的时间
static const    CFTimeInterval  kScanfWithDurationBeginAnimationTime = 0.5f;   //延时动画的时间
static const    CFTimeInterval  kScanfAnimationWithKeepTime          = 120.0f; //动画持续的时间
static const    CGFloat         kBackButtonWithTop                   = 20.0f;
static const    CGFloat         kBackButtonWithLeft                  = 10.0f;
static const    CGFloat         kBackButtonWithFontSize              = 16.0f;
static NSString const          *kRotationAnimationKeyName            = @"scanRotation";

static const    NSTimeInterval  kScanfTimerInterval                  = 5.0f;
static const    CGFloat         kIcoImageViewwithBottom              = 7.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //初始化搜到的设备数据
        amLanSearchModelList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

/**
 *  获取一个范围内的随机数 [from,to），包括from，不包括to
 *
 *  @param from 最小边界值
 *  @param to   最大边界值
 *
 *  @return 随机数
 */
 -(int)getRandomNumber:(int)from to:(int)to {
     
    return (int)(from + (arc4random()%(to-from + 1)));
}

-(void)initLayoutWithViewWillAppear {

   self.navigationController.navigationBarHidden = YES;
    [self scanDeviceMath];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];

    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];
    
    if ([backGroud.layer animationForKey:(NSString *)kRotationAnimationKeyName]) {
        
        [backGroud.layer removeAnimationForKey:(NSString *)kRotationAnimationKeyName];
    }
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    [self initLayoutWithScanView];
    [self initLayoutWithBackClick];
    
    [self performSelector:@selector(scanDeviceMath) withObject:nil afterDelay:kScanfWithDurationBeginAnimationTime];
    
    
    scanfTimer = [NSTimer scheduledTimerWithTimeInterval:kScanfTimerInterval
                                                           target:self
                                                        selector:@selector(scanfDeviceList)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [scanfTimer fire];

}

/**
 *  判断当前生成的按钮不重合在扫描图标上
 *
 *  @param x x坐标
 *  @param y y坐标
 *
 *  @return 不重叠返回YES 采用中心点距离判断
 */
-(BOOL)checkNewDevicePoint:(CGFloat)x withY:(CGFloat)y{
    
    UIImage *deviceNewImage = [UIImage imageNamed:@"sca_device.png"] ;
    
    CGPoint deviceCenter    = CGPointMake(x + ceil(deviceNewImage.size.width/2.0), y+ceil(deviceNewImage.size.height/2.0));
    
    CGPoint scanImageCenter = CGPointMake(scanfImageFrame.origin.x + ceil(scanfImageFrame.size.width/2.0), scanfImageFrame.origin.y + ceil(scanfImageFrame.size.height/2.0));
    
    double distance_x = pow(scanImageCenter.x - deviceCenter.x, 2);
    double distance_y = pow(scanImageCenter.y - deviceCenter.y, 2);
    
    double distance = sqrt(distance_x + distance_y);
    
    
    if (distance >= (deviceNewImage.size.width + scanfImageFrame.size.width)/2.0 ) {
        
        return YES;
    }
    
    return NO;
    
}

/**
 *  判断当前生成的按钮不重合在已扫描的设备上
 *
 *  @param x x坐标
 *  @param y y坐标
 *
 *  @return 不重叠返回YES 采用中心点距离判断
 */
-(BOOL)checkNewDevicePointWithOtherDevcReclosing:(CGFloat)x withY:(CGFloat)y{
    
    int isReclosingStatus = TRUE;
    
    for (int i = 0 ; i<amLanSearchModelList.count; i++) {
        
        UIButton *newDeviceBtn = (UIButton *)[self.view viewWithTag:kNewDeviceButtonWithTag+i];
        
        
        CGPoint deviceCenter    = CGPointMake(x + ceil(newDeviceBtn.frame.size.width/2.0), y+ceil(newDeviceBtn.size.height/2.0));
        
        CGPoint scanImageCenter = CGPointMake(newDeviceBtn.frame.origin.x + ceil(newDeviceBtn.frame.size.width/2.0), newDeviceBtn.frame.origin.y + ceil(newDeviceBtn.frame.size.height/2.0));
        
        double distance_x = pow(scanImageCenter.x - deviceCenter.x, 2);
        double distance_y = pow(scanImageCenter.y - deviceCenter.y, 2);
        
        double distance = sqrt(distance_x + distance_y);
        
        
        if (distance < newDeviceBtn.size.width +5.0) {
            
            isReclosingStatus = FALSE;
            
            break;
        }
        
    }
    
    return isReclosingStatus;
}

/**
 *  根据标签返回一个新设备的按钮
 *
 *  @param tag 标签
 *
 *  @return 新设备的按钮
 */
-(UIButton *)newDeviceuttonWithTag:(int)tag {
   
    UIImage *deviceNewImage = [UIImage imageNamed:@"sca_device_new.png"] ;
    
    UIButton *newDeviceBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    newDeviceBtn.frame      = CGRectMake(0, 0, deviceNewImage.size.width, deviceNewImage.size.height);
    [newDeviceBtn setBackgroundImage:deviceNewImage forState:UIControlStateNormal];
    newDeviceBtn.tag        = kNewDeviceButtonWithTag + tag;
    [newDeviceBtn addTarget:self  action:@selector(addNewScanDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    return newDeviceBtn;
}


/**
 *  初始化返回按钮
 */
- (void)initLayoutWithBackClick {


    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[UIImage imageBundlePath:@"voi_exit.png"]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:kBackButtonWithFontSize];
    [btn setTitle:LOCALANGER(@"jvc_adddevcie_sacn_back") forState:UIControlStateNormal];
    btn.frame = CGRectMake(kBackButtonWithLeft, kBackButtonWithTop, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [image release];
}

/**
 *  初始化局域网广播扫描视图
 */
- (void)initLayoutWithScanView {
    
    scanfNewDevice_x = (self.view.frame.size.width  - (kNewDeviceImageViewWithRadius*2) ) / 2.0;
    scanfNewDevice_y = (self.view.frame.size.height - (kNewDeviceImageViewWithRadius*2) ) / 2.0;
    
    UIImageView *bgImageView    = [self imageViewWithImageName:@"sca_bg.png"];
    
    [bgImageView retain];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIImage *sendImage        = [UIImage imageNamed:@"sca_log"];
    
    CGFloat sendButtonWidth   = sendImage.size.width;
    
    UIImageView *sendButton    = [[UIImageView alloc] init];
    sendButton.frame           = CGRectMake((self.view.frame.size.width - sendButtonWidth)/2.0 , bgImageView.frame.size.height/2.0 - sendButtonWidth/2.0 + kIcoImageViewwithBottom , sendButtonWidth, sendButtonWidth);
    [[sendButton layer] setCornerRadius:sendButtonWidth/2.0];
    sendButton.image           = sendImage;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.userInteractionEnabled= YES;
    
    scanfImageFrame           = sendButton.frame;
    
    UIImage *scanImage = [UIImage imageNamed:@"sca_ani"];
    
    CGFloat kScanfBgWithRadius = scanImage.size.width ;
    
    backGroud                  = [[UIView alloc] init];
    backGroud.backgroundColor  = [UIColor clearColor];
    backGroud.frame            = CGRectMake(sendButton.frame.size.width/2.0 + sendButton.frame.origin.x - kScanfBgWithRadius, sendButton.frame.origin.y + sendButton.frame.size.height/2.0 - kScanfBgWithRadius, kScanfBgWithRadius*2, kScanfBgWithRadius*2);
    [self.view addSubview:backGroud];
    
    
    UIImageView *line    = [[UIImageView alloc] init];
    line.frame           = CGRectMake(0.0, kScanfBgWithRadius , kScanfBgWithRadius, kScanfBgWithRadius);
    line.backgroundColor = [UIColor clearColor];
    line.image           = scanImage;
    [backGroud addSubview:line];
    
    [backGroud release];
    [line release];
    
    [self.view addSubview:sendButton];
    [sendButton release];
}

/**
 *  添加新设备
 */
-(void)addNewScanDevice:(UIButton *)button
{
    nSelectedIndex      = button.tag - kNewDeviceButtonWithTag;

    JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];
        
    [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:[NSString stringWithFormat:@"%@：%@",LOCALANGER(@"qrDevice"),model.strYstNumber] delegate:self selectAction:@selector(addQRdevice) cancelAction:nil selectTitle:LOCALANGER(@"jvc_DeviceList_APadd") cancelTitle:LOCALANGER(@"jvc_DeviceList_APquit") alertTage:0];
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self addQRdevice];
    }
}

- (void)addQRdevice
{
    JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:nSelectedIndex];
    
    [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceDelegate = self;
    
    [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] addDeviceWithYstNum:model.strYstNumber
                                                                userName:(NSString *)DefaultUserName
                                                                passWord:(NSString *)DefaultPassWord];
        
    [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] addDeviceWithYstNum:model.strYstNumber
                                                                    userName:(NSString *)DefaultHomeUserName
                                                                    passWord:(NSString *)DefaultHomePassWord];
   
}

/**
 *  添加云视通成功的时候
 */
- (void)addDeviceSuccess
{
    JVCDeviceSourceHelper *deviceSourceObj    = [JVCDeviceSourceHelper shareDeviceSourceHelper];
     NSArray              *lanModelDeviceList = [deviceSourceObj LANModelListConvertToSourceModel:amLanSearchModelList];
    
    [lanModelDeviceList retain];
    
    [deviceSourceObj updateLanModelToChannelListData:lanModelDeviceList];
    
    [lanModelDeviceList release];
    
    [self setDeviceButtonNoNewStatus];
}

/**
 *  设置添加的设备不是新设备状态
 */
-(void)setDeviceButtonNoNewStatus{

    dispatch_async(dispatch_get_main_queue(), ^{
    
        UIButton *button = (UIButton *)[self.view viewWithTag:kNewDeviceButtonWithTag+nSelectedIndex];
        
        [button setBackgroundImage:[UIImage imageNamed:@"sca_device.png"] forState:UIControlStateNormal];

    });

}

/**
 *  局域网扫描设备
 */
-(void)scanfDeviceList {
   
    JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelperObj=[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper];
    jvcLANScanWithSetHelpYSTNOHelperObj.delegate = self;
    
    [jvcLANScanWithSetHelpYSTNOHelperObj SerachLANAllDevicesAsynchronousRequestWithDeviceListData];
}

/**
 *  判断当前的缓存数据中 广播到的设备是否存在
 *
 *  @param ystNumber 云视通号
 *
 *  @return 存在返回YES 否则返回NO
 */
-(BOOL)checkLanSearchModelIsExist:(NSString *)ystNumber {
    
    for (int i = 0 ; i < amLanSearchModelList.count; i++) {
        
        JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[amLanSearchModelList objectAtIndex:i];
        
        if ([model.strYstNumber isEqualToString:ystNumber]) {
            
            return YES;
        }
        
    }
    
    return NO;
}

/**
 *  返回的所有广播搜到的设备
 *
 *  @param SerachLANAllDeviceList 返回的设备数组
 */
-(void)SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:(NSMutableArray *)SerachLANAllDeviceList{

    [SerachLANAllDeviceList retain];
    
    JVCDeviceSourceHelper *deviceSourceObj = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    
    NSArray *lanModelDeviceList=[deviceSourceObj LANModelListConvertToSourceModel:SerachLANAllDeviceList];
    
    [lanModelDeviceList retain];
    
    [deviceSourceObj updateLanModelToChannelListData:lanModelDeviceList];
    
    [lanModelDeviceList release];

    
    for (int i = 0; i < SerachLANAllDeviceList.count; i++) {
        
        JVCLanScanDeviceModel *model = (JVCLanScanDeviceModel *)[SerachLANAllDeviceList objectAtIndex:i];
        
        
        if (amLanSearchModelList.count >= kNewDeviceWithMaxCount) {
            
            [self stopScanfDeviceTimer];
            break;
        }
        
        if ([self checkLanSearchModelIsExist:model.strYstNumber] ) {
            
            continue;
        }
        
        if ( ADDDEVICE_HAS_EXIST == [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:model.strYstNumber]){
        
            continue;
        }
       
        [amLanSearchModelList addObject:model];
        
        [self playNewSound];
        
        UIButton *newButton = [self newDeviceuttonWithTag:amLanSearchModelList.count - 1];
        
        [newButton retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat x  ;
            CGFloat y  ;
            
            do {
            
                 x  = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
                 y  = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
                
            }while (![self checkNewDevicePoint:scanfNewDevice_x+x withY:scanfNewDevice_y+y]);
            
                CGRect rectDevice    = newButton.frame;
                rectDevice.origin.x  = scanfNewDevice_x + x;
                rectDevice.origin.y  = scanfNewDevice_y + y;
                newButton.frame      = rectDevice;
                newButton.alpha = kNewDeviceImageViewWithMinAlpha;
                newButton.transform = CGAffineTransformMakeScale(kNewDeviceImageViewWithMinScale, kNewDeviceImageViewWithMinScale);
                [self.view addSubview:newButton];
                
                [UIView animateWithDuration:kNewDeviceWithanimateWithDuration animations:^{
                    
                    newButton.alpha     = 1.0f;
                    newButton.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL isFinshed){
                
                
                }];
        });

        [newButton release];
    }
    
    [SerachLANAllDeviceList release];
}


/**
 *  播放扫描背景音乐
 */
-(void)playScanSound{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:@"sca_sound" ofType:@"mp3"];
    
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:soundPath withIsRunloop:YES];

}

/**
 *  播放发现设备
 */
-(void)playNewSound{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:@"sca_new" ofType:@"mp3"];
    
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:soundPath withIsRunloop:NO];
}

/**
 *  播放配置完成
 */
-(void)playConfigSound{
    
    NSString *soundPath = [[NSBundle mainBundle ] pathForResource:NSLocalizedString(@"jvc_scanf_finshed", nil) ofType:@"mp3"];
    
    JVCSystemSoundHelper *soundHelperObj = [JVCSystemSoundHelper shareJVCSystemSoundHelper];
    
    [soundHelperObj playSound:soundPath withIsRunloop:NO];
}


/**
 *  返回上一级
 */
-(void)popClick{
    
    [self gotoBack];
}

/**
 *  局域网广播动画
 */
-(void)scanDeviceMath{
    
    CABasicAnimation *rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue           = [NSNumber numberWithFloat:(2 * M_PI) ];
    rotationAnimation.duration          = kScanfWithAnimationDuration;
    rotationAnimation.delegate          = self;
    rotationAnimation.repeatCount       = kScanfAnimationWithKeepTime / kScanfWithAnimationDuration;
    [backGroud.layer addAnimation:rotationAnimation forKey:(NSString *)kRotationAnimationKeyName];
    [self playScanSound];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (!isExit ) {
        
        [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];
        [self stopScanfDeviceTimer];
    }
}

/**
 *  返回事件
 */
-(void)gotoBack{

    isExit = TRUE;
    [self stopScanfDeviceTimer];
    
    if ([backGroud.layer animationForKey:(NSString *)kRotationAnimationKeyName]) {
        
        [backGroud.layer removeAnimationForKey:(NSString *)kRotationAnimationKeyName];
    }
     
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/**
 *  停止扫描设备
 */
-(void)stopScanfDeviceTimer{
    
    if (scanfTimer != nil) {
        
        if ([scanfTimer isValid]) {
            
            [scanfTimer invalidate];
            scanfTimer = nil;
        }
    }
    
    JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelperObj=[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper];
    jvcLANScanWithSetHelpYSTNOHelperObj.delegate = nil;
    
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
