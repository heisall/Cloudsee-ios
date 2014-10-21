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

@interface JVCScanNewDeviceViewController () {
    
    UIView       *backGroud;
    NSTimer      *scanfTimer;
    UIButton     *scanfNewDevice;
    CGFloat       scanfNewDevice_x;
    CGFloat       scanfNewDevice_y;
    
    JVCDeviceModel *devieNewModel;
}

@end

@implementation JVCScanNewDeviceViewController

static const    CFTimeInterval  kScanfWithAnimationDuration          = 10.0f;  //动画执行的时间
static const    CFTimeInterval  kScanfWithDurationBeginAnimationTime = 0.5f;   //延时动画的时间
static const    CFTimeInterval  kScanfAnimationWithKeepTime          = 120.0f; //动画持续的时间
static const    CGFloat         kBackButtonWithTop                   = 20.0f;
static const    CGFloat         kBackButtonWithLeft                  = 15.0f;
static NSString const          *kRotationAnimationKeyName            = @"scanRotation";
static const    CGFloat         kNewDeviceImageViewWithRadius        = 100.0f;

static const    NSTimeInterval kScanfTimerInterval                   = 5.0f;
static const    CGFloat         kNewDeviceImageViewWithMinScale      = 0.1f;
static const    CGFloat         kNewDeviceImageViewWithMinAlpha      = 0.1f;
static const    CGFloat         kNewDeviceWithanimateWithDuration    = 1.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
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
 -(int)getRandomNumber:(int)from to:(int)to
 
{
    
    return (int)(from + (arc4random()%(to-from + 1)));
    
}

-(void)initLayoutWithViewWillAppear {

    [self scanDeviceMath];
}

-(void)deallocWithViewDidDisappear {

   
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    scanfNewDevice_x = (self.view.frame.size.width  - (kNewDeviceImageViewWithRadius*2) ) / 2.0;
    scanfNewDevice_y = (self.view.frame.size.height - (kNewDeviceImageViewWithRadius*2) ) / 2.0;

    
    UIImageView *bgImageView    = [self imageViewWithImageName:@"sca_bg.png"];
    
    [bgImageView retain];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
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
    
    UIImage *scanImage = [UIImage imageNamed:@"sca_ani"];
    
    CGFloat kScanfBgWithRadius = scanImage.size.width ;
    
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
    
//    scanfNewDevice = [self imageViewWithImageName:@"sca_device.png"];
    UIImage *deviceNewImage = [UIImage imageNamed:@"sca_device.png"] ;
    scanfNewDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    scanfNewDevice.frame = CGRectMake(0, 0, deviceNewImage.size.width, deviceNewImage.size.height);
    [scanfNewDevice setBackgroundImage:deviceNewImage forState:UIControlStateNormal];
    [scanfNewDevice addTarget:self  action:@selector(addNewScanDevice) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rectDevice    = scanfNewDevice.frame;
    rectDevice.origin.x  = scanfNewDevice_x ;
    rectDevice.origin.y  = scanfNewDevice_y ;
    scanfNewDevice.frame = rectDevice;
    
    [self.view addSubview:scanfNewDevice];
    
    DDLogVerbose(@"%@",scanfNewDevice);
    scanfNewDevice.alpha = kNewDeviceImageViewWithMinAlpha;
    scanfNewDevice.transform = CGAffineTransformMakeScale(kNewDeviceImageViewWithMinScale, kNewDeviceImageViewWithMinScale);
    
    scanfTimer = [NSTimer scheduledTimerWithTimeInterval:kScanfTimerInterval
                                                           target:self
                                                        selector:@selector(scanfDeviceList)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [scanfTimer fire];
    
}

/**
 *  添加新设备
 */
-(void)addNewScanDevice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现设备：%@",devieNewModel.yunShiTongNum] message:nil delegate:self cancelButtonTitle:@"添加" otherButtonTitles:@"取消", nil];
    alert.delegate = self;
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceDelegate = self;
        [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] addDeviceWithYstNum:devieNewModel.yunShiTongNum
                                                                    userName:devieNewModel.userName
                                                                    passWord:devieNewModel.passWord];
    }
   

}

/**
 *  添加云视通成功的时候
 */
- (void)addDeviceSuccess
{
    [self gotoBack];
}

/**
 *  局域网扫描设备
 */
-(void)scanfDeviceList {
   
    DDLogVerbose(@"%s-----",__FUNCTION__);
    JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelperObj=[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper];
    jvcLANScanWithSetHelpYSTNOHelperObj.delegate = self;
    
    [jvcLANScanWithSetHelpYSTNOHelperObj SerachLANAllDevicesAsynchronousRequestWithDeviceListData];
    
    
}

/**
 *  返回的所有广播搜到的设备
 *
 *  @param SerachLANAllDeviceList 返回的设备数组
 */
-(void)SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:(NSMutableArray *)SerachLANAllDeviceList{

    [SerachLANAllDeviceList retain];
    
    if (SerachLANAllDeviceList.count > 0) {
        
        [self stopScanfDeviceTimer];
        
        devieNewModel = [[self LANModelConvertToSourceModel:SerachLANAllDeviceList] retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat x  = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
            CGFloat y = [self getRandomNumber:0 to:kNewDeviceImageViewWithRadius*2];
            
            CGRect rectDevice    = scanfNewDevice.frame;
            rectDevice.origin.x  = scanfNewDevice_x + x;
            rectDevice.origin.y  = scanfNewDevice_y + y;
            scanfNewDevice.frame = rectDevice;
            
            [UIView animateWithDuration:kNewDeviceWithanimateWithDuration animations:^{
                
                scanfNewDevice.alpha     = 1.0f;
                scanfNewDevice.transform = CGAffineTransformIdentity;
                

            }];
        });
    }
    
  
    [SerachLANAllDeviceList release];
}

/**
 *  把广播到的设备实体转换成sourceModel
 *
 *  @param lanModelList 广播到的设备集合
 *
 *  @return 广播到的设备集合（存放的sourceModel集合）
 */
-(JVCDeviceModel *)LANModelConvertToSourceModel:(NSMutableArray *)lanModelList{
    
        JVCLanScanDeviceModel *lanModel=(JVCLanScanDeviceModel *)[lanModelList objectAtIndex:0];
        
        JVCDeviceModel *devieNewModelTemp=[[JVCDeviceModel alloc] init];
        
        devieNewModelTemp.yunShiTongNum = lanModel.strYstNumber;
        devieNewModelTemp.nickName      = lanModel.strYstNumber;
        devieNewModelTemp.userName      = (NSString *)DefaultUserName;
        devieNewModelTemp.passWord      = (NSString *)DefaultPassWord;
        devieNewModelTemp.onLineState   = DEVICESTATUS_ONLINE;
        devieNewModelTemp.hasWifi       = lanModel.iNetMod;
        devieNewModelTemp.linkType      = CONNECTTYPE_IP;
        devieNewModelTemp.ip            = lanModel.strDeviceIP;
        devieNewModelTemp.port          = lanModel.strDevicePort;
    
        return [devieNewModelTemp autorelease];
}


/**
 *  返回上一级
 */
-(void)popClick{
    
    [self gotoBack];
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

    [self gotoBack];
}

/**
 *  返回事件
 */
-(void)gotoBack{

    [self stopScanfDeviceTimer];
    
    JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelperObj=[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper];
    jvcLANScanWithSetHelpYSTNOHelperObj.delegate = nil;

    self.navigationController.navigationBarHidden = NO;

    [self.navigationController popToRootViewControllerAnimated:YES];
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
}

- (void)dealloc
{
    [devieNewModel release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
