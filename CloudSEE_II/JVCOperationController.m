//
//  JVCOperationController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationController.h"
#import "JVCOperationMiddleViewIphone5.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCManagePalyVideoComtroller.h"
#import "JVCRemoteVideoPlayBackVControler.h"
#import "JVCOperationMiddleView.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCCustomYTOView.h"
#import "JVCDeviceSourceHelper.h"
#import "JVNetConst.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "GlView.h"

#import<AssetsLibrary/AssetsLibrary.h>

static const int  STARTHEIGHTITEM =  40;

static const NSString * BUNDLENAMEBottom  = @"customBottomView_cloudsee.bundle";//bundle的名称


//static const int WINDOWSFLAG  = WINDOWSFLAG;//tag


bool selectState_sound ; // yes  选中   no：没有选中
bool selectState_talk ;
bool selectState_audio ;

@interface JVCOperationController ()
{
    /**
     *  当用户名密码错误时，要跳转到修个用户名。密码界面，此变量用于获取相应的index
     */
    int iModifyIndex;
    
    /**
     *  标志修改用户名密码的alert是否弹出来的标志位
     */
    BOOL bStateModifyDeviceInfo;
    
    JVCCustomOperationBottomView *_operationItemSmallBg;
    
    /**
     *  保存本地相册的path
     */
    NSString *_strSaveVideoPath;
    
    /**
     *  音频监听、云台、远程回调的中间view
     */
    JVCOperationMiddleViewIphone5 *operationBigView;

}

@end

@implementation JVCOperationController
@synthesize _aDeviceChannelListData,_iSelectedChannelIndex,_iViewState;
@synthesize _issound,_isTalk,_isLocalVideo,_isPlayBack,_deviceModel;
@synthesize _playBackVideoDataArray,_playBackDateString;
@synthesize _amDeviceListData,_selectedDeviceIndex;
@synthesize showSingeleDeviceLongTap,_isConnectModel;
@synthesize delegate;

JVCCustomOperationBottomView *_operationItemSmallBg;

static const int  JVCOPERATIONCONNECTMAXNUMS  = 16;//

char imageBuffer[1][1280*720*3];
char imageBufferY[1][1280*720*3];
char imageBufferU[1][1920*1080];
char imageBufferV[1][1920*1080];

char capImageBuffer[1][1280*720*3];


OpenALBufferViewcontroller *_openALBufferSound;
AQSController *_audioRecordControler;
char ppszPCMBuf[640];;
int unAllLinkFlag;
AVAudioPlayer *_play;
UIButton *_bSmallTalkBtn;
UIButton *_bSmallVideoBtn;
UIButton *_bSoundBtn;
UIButton *_bYTOBtn;
UIButton *_bSmallCaptureBtn;
UIImageView * capImageView;

OpenALBufferViewcontroller *_openALBufferSound;
JVCRemoteVideoPlayBackVControler *_remoteVideoPlayBackVControler;
unsigned char acFLBuffer[64*1024] = {0};//存放远程回放数据原始值
NSTimer *repeatLinkTimer[JVCOPERATIONCONNECTMAXNUMS];
int linkFlag[JVCOPERATIONCONNECTMAXNUMS];
int _iWindowsSelectedChannelIndex[JVCOPERATIONCONNECTMAXNUMS];



bool _isPlayBackVideo;

char m_cOut[1024]; //板卡语音对讲解码后的数据

int _iPlayBackVideo;
bool _isCapState;
int connectAllFlag;
//splitWindowView *splitWindow;
UIButton *_splitViewBtn;
UIView *_splitViewBgClick;
JVCCustomCoverView *_splitViewCon;
bool _isConnectdevcieOpenDecoder;




#define CONNECTTURNFLAG @"(TURN)"



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    
    [_strSaveVideoPath release];
    
    [_managerVideo removeFromSuperview];
    [_managerVideo release];
    
    [capImageView removeFromSuperview];
    [capImageView release];
    
    [_splitViewBgClick removeFromSuperview];
    [_splitViewBgClick release];
    
    
    [_splitViewBtn removeFromSuperview];
    
    
    [_playBackVideoDataArray release];
    _playBackVideoDataArray=nil;
    
    [_amSelectedImageNameListData release];
    _amSelectedImageNameListData=nil;
    
    [_amUnSelectedImageNameListData release];
    _amUnSelectedImageNameListData=nil;
    
    [_deviceModel release];
    _deviceModel=nil;
    
    [_aDeviceChannelListData release];
    _aDeviceChannelListData=nil;
    
    [scrollview release];
    DDLogVerbose(@"%s----",__FUNCTION__);
    [super dealloc];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_splitViewBtn setHidden:YES];
    [_splitViewCon setHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_isPlayBackVideo) {
        
        if ([self._aDeviceChannelListData count]<=1) {
            
            [_splitViewBtn setHidden:YES];
            [_splitViewCon setHidden:YES];
            
        }else{
            
            [_splitViewBtn setHidden:NO];
            [_splitViewCon setHidden:NO];
            
        }
        
        if (self.navigationController.navigationBarHidden) {
            self.navigationController.navigationBarHidden = NO;
        }
        
    }
    
}


- (void) viewDidLayoutSubviews {
    if (IOS_VERSION>=IOS7) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
    
}

/**
 *  解决状态栏显示问题
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if  (IOS_VERSION >=IOS7) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_VERSION>=IOS7) {
        
        self.automaticallyAdjustsScrollViewInsets =NO;
    }
    
    unAllLinkFlag=0;
    
    self._issound=FALSE;//音频监听
    self._isTalk=FALSE; //语音对讲
    self._isLocalVideo=FALSE;//录像
    
    NSMutableString *mutableString=[[NSMutableString alloc] initWithCapacity:10];
    self._playBackDateString=mutableString;
    [mutableString release];
    
    NSMutableArray * playBackArray = [[NSMutableArray alloc] initWithCapacity:10];
    self._playBackVideoDataArray = playBackArray;
    [playBackArray release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"wav"];
    if (path) {
		if (_play==nil) {
            NSURL *url =  [[NSURL alloc]initFileURLWithPath:path];
			_play= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			[_play prepareToPlay];
			_play.volume = 1.0;
            [url release];
		}
    }
    
    
    /**
     *  返回按钮
     */
    UIImage *image = [UIImage imageNamed:@"nav_back.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    // backBarBtn.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=backBarBtn;
    [backBtn release];
    [backBarBtn release];
    
    /**
     *  标题
     */
    self.navigationItem.title=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Video Display", nil)];
    
    /**
     *  播放窗体
     */
    _managerVideo=[[JVCManagePalyVideoComtroller alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width*0.75)];
    _managerVideo.tag=100;
    _managerVideo._amWheelData=self._aDeviceChannelListData;
    _managerVideo._operationController=self;
    _managerVideo.nSelectedChannelIndex=self._iSelectedChannelIndex;
    _managerVideo.imageViewNums=1;
    [_managerVideo setUserInteractionEnabled:YES];
    _managerVideo.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_managerVideo];
    [_managerVideo initWithLayout];
    
    self.delegate = _managerVideo;
    
    /**
     *  抓拍完成之后图片有贝萨尔曲线动画效果的imageview
     */
    capImageView=[[UIImageView alloc] init];
    capImageView.frame=_managerVideo.frame;
    [self.view addSubview:capImageView];
    [capImageView setHidden:YES];
    //[capImageView release];
    
    
    /**
     *  抓拍、对讲、录像、更多按钮的view
     */
    NSString *pathSamllImage = [UIImage getBundleImagePath:@"smallItem__Normal.png" bundleName:(NSString *)BUNDLENAMEBottom];
    UIImage *_smallItemBgImage = [[UIImage alloc]initWithContentsOfFile:pathSamllImage];
    CGRect frameBottom ;
    
    if (IOS_VERSION>=IOS7) {
        frameBottom = CGRectMake(0.0, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-_smallItemBgImage.size.height-[UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, _smallItemBgImage.size.height);
    }else{
        frameBottom = CGRectMake(0.0, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-_smallItemBgImage.size.height, self.view.frame.size.width, _smallItemBgImage.size.height);
        
    }
    [_smallItemBgImage release];
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:NSLocalizedString(@"Capture", nil),NSLocalizedString(@"megaphone", nil),NSLocalizedString(@"video", nil) ,NSLocalizedString(@"MoreOper", nil), nil];
    
    /**
     *  底部的按钮
     */
    _operationItemSmallBg =  [JVCCustomOperationBottomView shareInstance];
    [_operationItemSmallBg updateViewWithTitleArray:arrayTitle Frame:frameBottom SkinType:skinSelect];
    //[[CustomOperationBottomView alloc] initWithTitleArray:arrayTitle andFrame:frame andSkinType:skinSelect];
    _operationItemSmallBg.BottomDelegate = self;
    [_operationItemSmallBg setBackgroundColor:[UIColor clearColor]];
    _operationItemSmallBg.tag=101;
    [self.view addSubview:_operationItemSmallBg];
    
    /**
     *  多窗口的时候，导航栏上面的三角按钮，用于选中4、9、16窗口
     */
    _splitViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    float _x;
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        _x=203;
    }else
    {
        _x= 225;
    }
    
    UIImage *_splitShow=[UIImage imageNamed:@"splitScreenBtn.png"];
    _splitViewBtn.frame=CGRectMake(_x, (self.navigationController.navigationBar.frame.size.height-_splitShow.size.height-5.0)/2.0+3.0, _splitShow.size.width-5.0, _splitShow.size.height-2.0);
    // NSLog(@"_splitConBtn=%@",_splitViewBtn);
    [_splitViewBtn setShowsTouchWhenHighlighted:YES];
    [_splitViewBtn addTarget:self action:@selector(gotoShowSpltWindow) forControlEvents:UIControlEventTouchUpInside];
    [_splitViewBtn setBackgroundImage:_splitShow forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_splitViewBtn];
    if ([self._aDeviceChannelListData count]<=1) {
        [_splitViewBgClick setHidden:YES];
        [_splitViewBtn setHidden:YES];
    }
    
    /**
     *  中间的语音对讲、云台、远程回放按钮
     */
    
    CGRect frame = CGRectMake(0.0, _managerVideo.frame.origin.y+_managerVideo.frame.size.height, self.view.frame.size.width, _operationItemSmallBg.frame.origin.y-_managerVideo.frame.size.height-_managerVideo.frame.origin.y);
    
    
    [self initOperationControllerMiddleViewwithFrame:frame];
    
    skinSelect = 0;
                                                    
    
}

/**
 *  初始化音频监听、云台、远程回放模块
 */
- (void)initOperationControllerMiddleViewwithFrame:(CGRect )newFrame
{
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Audio", nil),NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"Playback", nil), nil];
    
    JVCOperationMiddleView *_operationBigItemBg =   [JVCOperationMiddleView shareInstance];
    
    [_operationBigItemBg updateViewWithTitleArray:array frame:newFrame skinType:skinSelect];
    
    _operationBigItemBg.delegateOperationMiddle = self;
    
    [self.view addSubview:_operationBigItemBg];
    
    JVCCustomCoverView *ytoView = [JVCCustomCoverView shareInstance];
    ytoView.frame = CGRectMake(_operationBigItemBg.frame.origin.x,_operationBigItemBg.frame.origin.y,_operationBigItemBg.frame.size.width,_operationBigItemBg.frame.size.height);
    ytoView.tag=661;
    ytoView.CustomCoverDelegate=self;
    [self.view addSubview:ytoView];
    [ytoView setHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)gotoShowSpltWindow{
    
    NSMutableArray *_splitItems=[[NSMutableArray alloc] initWithCapacity:10];
    
    [_splitItems addObjectsFromArray:[self getSplitWindowMaxNumbers]];
    
    _splitViewCon= [JVCCustomCoverView shareInstance];
    [self.view.window addSubview:_splitViewCon];
    
    _splitViewCon.frame = CGRectMake(0, _splitViewBtn.frame.origin.y, self.view.frame.size.width, 0.0);
    _splitViewCon.CustomCoverDelegate=self;
    [_splitViewCon updateConverViewWithTitleArray:_splitItems skinType:skinSelect];
    [_splitItems release];
    
}

#pragma mark 返回当前的屏幕显示的模式
-(NSMutableArray*)getSplitWindowMaxNumbers{
    
    NSMutableArray *_windowListData=[NSMutableArray arrayWithCapacity:10];
    if ([self._aDeviceChannelListData count]<=4) {
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        
    }else if([self._aDeviceChannelListData count]<=9){
        
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"nine-Screen", nil)]];
        
    }else {
        
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"nine-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"sixteen-Screen", nil)]];
        
    }
    
    return _windowListData;
    
}



-(void)initwithSoundClass:(OpenALBufferViewcontroller*)openAl aqsController:(AQSController*)aqsController{
    _openALBufferSound=openAl;
    _audioRecordControler=aqsController;
}


#pragma mark
#pragma mark 请求远程回放事件
#pragma mark
-(void)playBackVideo{
    
    // [self changeViewWithSave];
    [self sendSelectDate:[NSDate date]];
    
    
}


-(void)changePlaySate{
    
    _isPlayBackVideo=FALSE;
    
}
//#pragma mark  保存数据（）
//- (void)changeViewWithSave
//{
//    if (_isPlayBackVideo) {
//        
//        _isPlayBackVideo=FALSE;
//        
//        int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//        
//        [channel[channelID] operationZKVideo:JVN_CMD_PLAYSTOP];
//        
//        JVChannel *selectChannel= channel[channelID];
//        
//        if (selectChannel!=nil) {
//            selectChannel.isWaitIFrame=FALSE;
//            selectChannel.isLocalVideoWaitIFrame=FALSE;
//            if (selectChannel.openDecoderFlag) {
//                
//                while (TRUE) {
//                    
//                    if (!selectChannel.UseDecoderFlag) {
//                        
//                        if(!selectChannel.isStandDecoder){
//                            
//                            JVD04_DecodeClose(channelID);
//                            JVD04_DecodeOpen(selectChannel.bmPlayVideoWidth ,selectChannel.bmPlayVideoHeight,channelID);
//                            
//                        }else{
//                            
//                            JVD05_DecodeClose(channelID);
//                            JVD05_DecodeOpen(channelID);
//                            
//                            
//                        }
//                        break;
//                    }
//                    //printf("run back playBackVideo\n");
//                    usleep(200);
//                }
//            }
//            
//            
//        }
//        _isPlayBackVideo=FALSE;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self showPlayBackVideo:_isPlayBackVideo];
//            
//        });
//        
//        [self stopSetting:channelID];
//        [selectChannel operationZKVideo:JVN_CMD_VIDEO];
//        
//    }else{
//        int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//        [self stopSetting:channelID];
//        
//    }
//}

#pragma mark 返回上一级
-(void)gotoBack{
    
    if (_isPlayBackVideo) {
        
//        _isPlayBackVideo=FALSE;
//        
//        int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//        
//        [channel[channelID] operationZKVideo:JVN_CMD_PLAYSTOP];
//        
//        JVChannel *selectChannel= channel[channelID];
//        
//        if (selectChannel!=nil) {
//            selectChannel.isWaitIFrame=FALSE;
//            selectChannel.isLocalVideoWaitIFrame=FALSE;
//            if (selectChannel.openDecoderFlag) {
//                
//                while (TRUE) {
//                    
//                    if (!selectChannel.UseDecoderFlag) {
//                        
//                        if(!selectChannel.isStandDecoder){
//                            
//                            JVD04_DecodeClose(channelID);
//                            JVD04_DecodeOpen(selectChannel.bmPlayVideoWidth ,selectChannel.bmPlayVideoHeight,channelID);
//                            
//                        }else{
//                            
//                            JVD05_DecodeClose(channelID);
//                            JVD05_DecodeOpen(channelID);
//                            
//                            
//                        }
//                        break;
//                    }
//                    //printf("run back playBackVideo\n");
//                    usleep(200);
//                }
//            }
//            
//            
//        }
//        _isPlayBackVideo=FALSE;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self showPlayBackVideo:_isPlayBackVideo];
//            
//        });
//        
//        [self stopSetting:channelID];
//        selectChannel._iWaitICountPic=1;
//        selectChannel._iWaitICount=1;
//        [selectChannel operationZKVideo:JVN_CMD_VIDEO];
//        
//        
//        return;
    }
    
    NSMutableString *_sAltertitle=[NSMutableString stringWithCapacity:10];
    
    if (self._iViewState==0) {
        [_sAltertitle appendFormat:@"%@",NSLocalizedString(@"Disconnecting nowPlease Wait", nil)];
    }else{
        [_sAltertitle appendFormat:@"%@",NSLocalizedString(@"Exiting NowPlease Wait", nil)];
    }
    wheelAlterInfo=[[UIAlertView alloc] initWithTitle:_sAltertitle
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] init];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame=CGRectMake(125.0, 75.0, 30.0,30.0);
    [activity startAnimating];
    [wheelAlterInfo addSubview:activity];
    [activity release];
    [wheelAlterInfo show];
    [wheelAlterInfo release];
    unAllLinkFlag=1;
    
    [NSThread detachNewThreadSelector:@selector(unAllLink) toTarget:self withObject:nil];
    
}

#pragma mark 断开事件

-(void)unAllLink{
    
    [_managerVideo CancelConnectAllVideoByLocalChannelID];
    
	for (int i=0; i<JVCOPERATIONCONNECTMAXNUMS; i++) {
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:i+1];
	}
    
    [self performSelectorOnMainThread:@selector(closeAlterViewAllDic) withObject:nil waitUntilDone:NO];
}


#pragma mark 云台控制
-(void)ytoClick:(UIButton*)button{
    if (_isPlayBackVideo) {
        return;
    }
    [[JVCCustomYTOView shareInstance] showYTOperationView];
    
}

-(void)ytoHidenClick{
    
    [[JVCCustomYTOView shareInstance] HidenYTOperationView];
    
}


#pragma mark -----------------断开指定通道的连接
-(void)disConnectChannel:(NSString*)channelID{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int channelValue=[channelID intValue]-1;
    NSLog(@"run dis 001 %d",channelValue);
	JVC_DisConnect(channelValue+1);
    NSLog(@"run dis 002 %d",channelValue);
	[pool release];
}

-(void)gotoUnAllLink:(NSTimer*)timer{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
	for (int i=0; i<JVCOPERATIONCONNECTMAXNUMS; i++) {
        
//        if (channel[i]!=nil) {
//            
//            return;
//        }
    }
    
    [timer invalidate];
    timer=nil;
    [self performSelectorOnMainThread:@selector(closeAlterViewAllDic) withObject:nil waitUntilDone:NO];
    [pool release];
    
}
-(void)closeAlterViewAllDic{
    
    
    memset(imageBuffer[0], 0, sizeof(imageBuffer[0])) ;
    [wheelAlterInfo dismissWithClickedButtonIndex:0 animated:NO];
    unAllLinkFlag=0;
    
    if (self._iViewState==0||self._iViewState==2) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else if(self._iViewState==1){
        
//        for (UIViewController *v_con in self.navigationController.viewControllers) {
//            if ([v_con isKindOfClass:[settingViewController class]]) {
//                settingViewController *settingMon=(settingViewController*)v_con;
//                [settingMon loginOut];
//            }
//        }
    }else if(self._iViewState==4){
        
        [self.navigationController popToRootViewControllerAnimated:NO];
//        JDCSAppDelegate *delegate = (JDCSAppDelegate*)[UIApplication sharedApplication].delegate;
//        [delegate initLoginVCToRootVC];
        
    }else if(self._iViewState==5){
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
}

#pragma mark 保存本地录像的文件
- (void)saveLocalVideo:(NSString*)urlString{
    
    NSLog(@"urlString==%@",urlString);
    
    if (urlString ==nil) {
        return;
    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:urlString]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"error");
                                    } else {
                                        
                                    }
                                }];
    [library release];
}



-(void)channelAllWaitI{
    
    for (int i=0; i<JVCOPERATIONCONNECTMAXNUMS; i++) {
//        if (channel[i]!=nil) {
//            channel[i].isWaitIFrame=FALSE;
//        }
    }
    
    
    
    
    
}


#pragma mark 播放事件
-(void)playSoundPressed
{
    //点击按钮后开始播放音乐
    //当player有值的情况下并且没有在播放中 开始播放音乐
    if (_play)
    {
        if (![_play isPlaying])
        {
            [_play play];
        }
    }
}

#pragma mark 处理通道轮数问题

-(int)returnChannelID:(int)windowIndexValue{
    
    return windowIndexValue%JVCOPERATIONCONNECTMAXNUMS;
    
}

-(int)returnChannelPage:(int)windowIndexValue{
    return windowIndexValue/JVCOPERATIONCONNECTMAXNUMS;
}
- (void)setScrollviewByIndex:(NSInteger)Index
{
    [_managerVideo  setScrollviewByIndex:Index];
}

-(void)gotoDeviceShowChannels{
    
//    int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//    operationDeviceOfSourceListDatasComtroller *_currentDeviceChannelsView=[[operationDeviceOfSourceListDatasComtroller alloc] init];
//    //NSLog(@"%d",self._aDeviceChannelListData.count);
//    _currentDeviceChannelsView._amDeviceChannelListData=self._aDeviceChannelListData;
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionReveal;
//    transition.subtype = kCATransitionFromTop;
//    transition.delegate = self;
//    _currentDeviceChannelsView._operationView=self;
//    _currentDeviceChannelsView._iSelectedWindowsIndex=_operationController._iSelectedChannelIndex;
//    
//    if (channel[channelID]!=nil||channel[channelID]!=NULL) {
//        _currentDeviceChannelsView._iSelectedChannelIndex=_iWindowsSelectedChannelIndex[channelID];
//    }else{
//        
//        _currentDeviceChannelsView._iSelectedChannelIndex=self._iSelectedChannelIndex;
//    }
//    
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:_currentDeviceChannelsView animated:NO];
//    [_currentDeviceChannelsView release];
}

#pragma mark 打开当前通道视频流
-(void)openCurrentWindowsVideoData{
    
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    int start=_managerVideo._iCurrentPage*_managerVideo.imageViewNums;
//    int end=(_managerVideo._iCurrentPage+1)*_managerVideo.imageViewNums;
//    
//    for (int i=start; i<end; i++) {
//        
//        int ID=i%CONNECTMAXNUMS;
//        if (channel[ID]!=nil) {
//            int _ID=channel[ID].flag*CONNECTMAXNUMS;
//            int channelID=ID+_ID;
//            if (i==channelID) {
//                if (channel[ID].videoState) {
//                    [channel[ID] operationZKVideo:JVN_CMD_VIDEO];
//                    channel[ID].videoState=FALSE;
//                }
//            }
//        }
//    }
//    [pool release];
    
}

-(void)connectSingleDevicesAllChannel{
	
    
    return;
    
    if (unAllLinkFlag!=1) {
        
        [NSThread detachNewThreadSelector:@selector(connectSingleDeviceAllChannelMath) toTarget:self withObject:nil];
        
    }
    
}

-(void)connectSingleDeviceAllChannelMath{
    
    return;
}




-(void)startRepeatConnect:(NSDictionary*)_connectInfo{
    
    
    
    
    
}


/**
 *	窗口停止方法
 *
 *	@param	_channleIDStr	当前窗口的ID
 */
-(void)StopOtherWindowsVideoData:(NSString*)_channleIDStr{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    int start=_managerVideo._iCurrentPage*_managerVideo.imageViewNums;
    int end=(_managerVideo._iCurrentPage+1)*_managerVideo.imageViewNums;
    
    int flag=0;
    
    int channelID=[_channleIDStr intValue];
    
//    for (int i=0; i<CONNECTMAXNUMS; i++) {
//        
//        
//        int _ID=channel[i].flag*CONNECTMAXNUMS;
//        
//        int ID=i+_ID+WINDOWSFLAG;
//        
//        JVCCustomOperationBottomView  *imgView=(JVCCustomOperationBottomView*)[self.view viewWithTag:ID];
//        BOOL checkResult=YES;
//        if (imgView._glView._kxMoveGLView) {
//            checkResult=[imgView._glView._kxMoveGLView isHidden];
//        }
//        if (channel[i]!=nil&&(channel[i].ImageData!=nil||!checkResult)) {
//            
//            
//            if (_managerVideo.imageViewNums>4) {
//                
//                if (!channel[i]._isOnlyIState) {
//                    
//                    [channel[i] operationZKVideo_I:JVN_CMD_ONLYI];
//                    channel[i]._isOnlyIState=YES;
//                }
//                
//            }else{
//                
//                if (channel[i]._isOnlyIState) {
//                    
//                    [channel[i] operationZKVideo_I:JVN_CMD_FULL];
//                    
//                    channel[i]._isOnlyIState=FALSE;
//                }
//                
//            }
//        }
//    }
//    for (int i=start; i<end; i++) {
//        
//        int ID=i%CONNECTMAXNUMS;
//        if (ID==channelID) {
//            if (channel[ID]!=nil) {
//                int _ID=channel[ID].flag*CONNECTMAXNUMS;
//                int channelID=ID+_ID;
//                if (i==channelID) {
//                    if (channel[ID].videoState) {
//                        [channel[ID] operationZKVideo:JVN_CMD_VIDEO];
//                        channel[ID].videoState=FALSE;
//                        // NSLog(@"run hahha vieo stop....................");
//                    }
//                }
//                flag=1;
//                break;
//            }
//        }
//    }
    
//    if (0==flag) {
//        if(channel[channelID]!=nil){
//            if (!channel[channelID].videoState) {
//                [channel[channelID] operationZKVideo:JVN_CMD_VIDEOPAUSE];
//                channel[channelID].videoState=TRUE;
//                // NSLog(@"run hahha vieo stop....................%d",channelID);
//            }
//        }
//    }
    
    [pool release];
    
}


#pragma mark 按照所选的索引的连接事件
-(void)connectSingleChannel:(int)_iWindowsIndex selectedChannel:(int)selectedChannel{

    
}


-(void)connectSingleScrollChannel:(int)_iWindowsIndex selectedChannel:(int)selectedChannel{
    
    
}


-(void)repeatLink:(NSTimer*)repTimer{
    
    NSDictionary *dic=(NSDictionary*)[repTimer userInfo];
    
    JVCDeviceModel *model=(JVCDeviceModel*)[dic valueForKey:@"linkModel"];
    
//    int channelID = [model.deleteChannle intValue];
//    int ID=[self returnChannelID:channelID];
//    
//    linkFlag[ID]=1;
//    
//    if (channel[ID]!=nil) {
//        
//        if (channel[ID]._iSelectSourceModelIndexValue!=_iWindowsSelectedChannelIndex[ID]) {
//            
//            [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:self withObject:[NSString stringWithFormat:@"%d",ID+1]];
//        }
//        
//    }else{
//        
//        [repeatLinkTimer[ID] invalidate];
//        repeatLinkTimer[ID]=nil;
//        [self repeatWheellink:model channID:channelID];
//    }
}

-(void)repeatWheellink:(id)object channID:(int)chanID{
    
//	int channelID=chanID;
//	monitorConnectionSingleImageView *linkImageview=(monitorConnectionSingleImageView*)[self.view viewWithTag:WINDOWSFLAG+channelID];
//	int flag=channelID/CONNECTMAXNUMS;
//    
//	int ID=channelID%CONNECTMAXNUMS;
//    linkFlag[ID]=0;
//	sourceModel *model=(sourceModel*)object;
//	[linkImageview startActivity:[NSString stringWithFormat:@"%@-%@",model.yunShiTongNum,model.channelNumber]  isConnectType:model.editByUser];
//	channel[ID] =[[JVChannel alloc] initWithID:ID isTCP:0];
//	channel[ID].flag=flag;
//    channel[ID]._iSelectSourceModelIndexValue=_iWindowsSelectedChannelIndex[ID];
//    
//	NSString *password=model.password;
//	if (model.passwordState==1) {
//		password=@"";
//	}
//	UIDevice *device=[UIDevice currentDevice];
//	channel[ID].systemVersion=[[device systemVersion] floatValue];
//	if (model.linkType==0) {
//		int jj=0;
//		NSString *yst=model.yunShiTongNum;
//		for (jj=0; jj<yst.length; jj++) {
//			unsigned char c=[yst characterAtIndex:jj];
//			if (c<='9' && c>='0') {
//				break;
//			}
//		}
//		channel[ID] .byTCP=model.byTCP;
//		[channel[ID] connectByYST:[yst substringToIndex:jj] ystNum:[[yst substringFromIndex:jj] intValue] channel:[model.channelNumber intValue] passName:model.userName passWord:password localTry:model.localTry];
//		
//	}else {
//		channel[ID] .byTCP=model.byTCP;
//		[channel[ID] connectByIP:model.ip remotePort:[model.port intValue] channel:[model.channelNumber intValue] passName:model.userName passWord:password];
//	}
}


#pragma mark 最下面的操作按钮控制方法
-(void)smallBtnTouchUpInside:(UIButton*)sender{
    //sender.selected=TRUE;
    
}

#define RGB_SMALLITEM_UN_R  180.0
#define RGB_SMALLITEM_UN_G  180.0
#define RGB_SMALLITEM_UN_B  184.0
#define RGB_SMALLITEM_R 40.0
#define RGB_SMALLITEM_G 156.0
#define RGB_SMALLITEM_B 255.0

#define SMALLBTNFLAGVALUE 100
#define RGBVALUE 255.0

#pragma mark 设置默认的小功能按钮的背景样式
-(void)unSelectSmallButtonStyle:(UIButton*)unSelectedButton{
    
}

-(void)selectSmallButtonStyle:(UIButton*)selectedButton{

}

-(void)unSelectBigButtonStyle:(UIButton*)selectedButton{
    UIImage *bigImage=[UIImage imageNamed:[_amUnSelectedImageNameListData objectAtIndex:selectedButton.tag-SMALLBTNFLAGVALUE]];
    UIImage *_bigItemImage=[UIImage imageNamed:@"operation_bigItemBtnBg.png"];
    [selectedButton setBackgroundImage:_bigItemImage forState:UIControlStateNormal];
    [selectedButton setImage:bigImage forState:UIControlStateNormal];
    
    
}

-(void)selectBigButtonStyle:(UIButton*)selectedButton{
    UIImage *bigImage=[UIImage imageNamed:[_amSelectedImageNameListData objectAtIndex:selectedButton.tag-SMALLBTNFLAGVALUE]];
    UIImage *_bigItemImage=[UIImage imageNamed:@"operation_bigItemBtnBg.png"];
    [selectedButton setBackgroundImage:_bigItemImage forState:UIControlStateNormal];
    [selectedButton setImage:bigImage forState:UIControlStateNormal];
}




#pragma mark 保存本地抓拍的图片
-(void)saveLocalChannelPhoto{
//    if (_isCapState) {
//        
//        return;
//    }
//    
//    int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//    
//    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
//        
//        if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [OperationSet showText:NSLocalizedString(@"pictureLibraynoAutor", nil) andPraent:self andTime:1 andYset:150];
//                [self unSelectSmallButtonStyle:_bSmallCaptureBtn];
//                
//                
//                // NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
//            });
//            
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [OperationSet showText:NSLocalizedString(@"picturelibrayError", nil) andPraent:self andTime:1 andYset:150];
//                [self unSelectSmallButtonStyle:_bSmallCaptureBtn];
//                //   NSLog(@"相册访问失败.");
//            });
//            
//            
//            
//        }
//        
//    };
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    NSUInteger groupTypes =ALAssetsGroupFaces;// ALAssetsGroupAlbum;// | ALAssetsGroupEvent | ALAssetsGroupFaces;
//    [library enumerateGroupsWithTypes:groupTypes usingBlock:nil failureBlock:failureblock];
//    
//    [library writeImageDataToSavedPhotosAlbum:channel[channelID].ImageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (error) {
//        } else {
//            _isCapState=YES;
//            UIImageView *imgView=capImageView;
//            [self.view bringSubviewToFront:imgView];
//            UIImage *image = [UIImage imageWithData:(NSData *)channel[channelID].ImageData];
//            [imgView setImage:image];
//            [capImageView setHidden:NO];
//            [UIView beginAnimations:@"superView" context:nil];
//            [UIView setAnimationDuration:0.4f];
//            imgView.frame=CGRectMake((imgView.frame.size.width-_bSmallCaptureBtn.frame.size.width)/2.0, (imgView.frame.size.height-_bSmallCaptureBtn.frame.size.height)/2., _bSmallCaptureBtn.frame.size.width, _bSmallCaptureBtn.frame.size.height);
//            [UIView commitAnimations];
//            [self performSelector:@selector(capAnimations) withObject:nil afterDelay:0.3f];
//            
//        }
//    }];
//    [library release];
    
    
}

-(void)capAnimations{
    
    UIImageView *imgView=capImageView;
    [self.view bringSubviewToFront:imgView];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPoint  startPoint=imgView.frame.origin;
    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
    
    
    CGPathAddQuadCurveToPoint(thePath, NULL,self.view.frame.size.width/3,10.0 , _bSmallCaptureBtn.frame.origin.x+_bSmallCaptureBtn.frame.size.width/2.0, self.view.frame.size.height- _bSmallCaptureBtn.frame.size.height);
    //复制代码注：startPoint是起点，endPoint是终点，150，30是x,y轴的控制点，自行调整数值可以出现理想弧度效果
    
    bounceAnimation.path = thePath;
    
    bounceAnimation.duration =0.7;
    
    
    //缩放
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    transform.duration = 10.0f;
    transform.removedOnCompletion = NO;
    transform.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5,0.5, 1)];
    transform.byValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5,0.5, 1)];
    transform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 0.7f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    group.animations = [NSArray arrayWithObjects:bounceAnimation,transform,nil];
    [imgView.layer addAnimation:group forKey:@"AddAnimation"];
    
    [self performSelector:@selector(hideencapAnimations) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(stopcapAnimations) withObject:nil afterDelay:0.7f];
    CFRelease(thePath);
    
}

-(void)hideencapAnimations{
    
    [self.view bringSubviewToFront:_managerVideo];
    
}

-(void)stopcapAnimations{
    
    [self playSoundPressed];
    capImageView.frame=_managerVideo.frame;
    [capImageView setHidden:YES];
    _isCapState=NO;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


/**
 *  用户名或密码错误后，要跳转到相应的节目
 *
 *  @param sender
 */
- (void)showAlertWithUserOrPassWordError
{
    
    if ( _managerVideo.imageViewNums == 1) {//只有单屏的时候才显示
        
        if (!bStateModifyDeviceInfo) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALANGER(@"Connection Failed ID_and_modify_user_and password") message:nil delegate:self cancelButtonTitle:LOCALANGER(@"Cancel") otherButtonTitles:LOCALANGER(@"Sure"), nil];
            alertView.tag = 19384324;
            [alertView show];
            [alertView release];
            bStateModifyDeviceInfo=YES;
        }
        
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 19384324) {
        
        if (buttonIndex == 0) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else{///区分本地跟账号
            
            JVCDeviceModel *model=[self._aDeviceChannelListData objectAtIndex:iModifyIndex];
            
            /**
             *  根据通道的云视通号，获取设备的云视通号
             */
//            JVCDeviceModel *modelDevice =[[jvcdevice sharedDLCCObj]  getSouchModelByYstNum:model.yunShiTongNum];
//            if ([JVCSystemUtility shareSystemUtilityInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
//                
//                LocalWlanChangeNameAndPw *modifyUserAndPassWord = [[LocalWlanChangeNameAndPw alloc] init];
//                modifyUserAndPassWord.mModel =modelDevice;
//                modifyUserAndPassWord.modifyDelegate = self;
//                [self.navigationController pushViewController:modifyUserAndPassWord animated:YES];
//                [modifyUserAndPassWord release];
//                
//            }else{
//                
//                WLanChangNameAndPW *modifyUserAndPassWord = [[WLanChangNameAndPW alloc] init];
//                modifyUserAndPassWord.mModel =modelDevice;
//                modifyUserAndPassWord.modifyDelegate = self;
//                [self.navigationController pushViewController:modifyUserAndPassWord animated:YES];
//                [modifyUserAndPassWord release];
//                
//            }
            
        }
        
        bStateModifyDeviceInfo=NO ;
        
        
    }
}


-(void)openglRefresh:(id)sender{
//    if (1==unAllLinkFlag) {
//        return;
//    }
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    CallBackMsg *callBackMsg= (CallBackMsg *)sender;
//    
//    if (1==channel[callBackMsg.channelID].changeDecodeFlag) {
//        [pool release];
//        return;
//    }
//    
//    int _ID=channel[callBackMsg.channelID].flag*CONNECTMAXNUMS;
//    int channelID=callBackMsg.channelID+_ID+WINDOWSFLAG;
//    JVChannel *selectChannel=channel[callBackMsg.channelID];
//    monitorConnectionSingleImageView *imgView=(monitorConnectionSingleImageView*)[self.view viewWithTag:channelID];
//    int decoderWidth=channel[callBackMsg.channelID].bmWidth;
//    int decoderHeight=channel[callBackMsg.channelID].bmHeight;
//    
//    if (selectChannel._iWaitICountPic>0) {
//        
//        selectChannel._iWaitICountPic--;
//    }else{
//        
//        if([imgView getActivity]){
//            
//            [imgView stopActivity:@""];
//        }
//        
//        [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:decoderWidth decoderFrameHeight:decoderHeight];
//        
//        if (channel[callBackMsg.channelID].ImageData==nil||channel[callBackMsg.channelID].ImageData==NULL)  {
//            
//            int ver=[[[UIDevice currentDevice] systemVersion] intValue];
//            yuv_rgb(callBackMsg.channelID,(unsigned int*)(capImageBuffer[0]+66),ver);
//            CreateBitmap((unsigned char *)capImageBuffer[0],channel[callBackMsg.channelID].bmWidth,channel[callBackMsg.channelID].bmHeight,ver);
//            NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[callBackMsg.channelID].bmWidth*channel[callBackMsg.channelID].bmHeight*2+66];
//            channel[callBackMsg.channelID].ImageData=d;
//            [channel[callBackMsg.channelID] stopTimer];
//            
//        }
//        
//    }
//    
//    
//    [NSThread detachNewThreadSelector:@selector(StopOtherWindowsVideoData:) toTarget:self withObject:[NSString stringWithFormat:@"%d",callBackMsg.channelID]];
//    [pool release];
    
    
}

-(void)openglPlayBackRefresh:(id)sender{
    
//    if (1==unAllLinkFlag) {
//        return;
//    }
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    CallBackMsg *callBackMsg= (CallBackMsg *)sender;
//    
//    if (1==channel[callBackMsg.channelID].changeDecodeFlag) {
//        [pool release];
//        return;
//    }
//    
//    int _ID=channel[callBackMsg.channelID].flag*CONNECTMAXNUMS;
//    int channelID=callBackMsg.channelID+_ID+WINDOWSFLAG;
//    JVChannel *selectChannel=channel[callBackMsg.channelID];
//    monitorConnectionSingleImageView *imgView=(monitorConnectionSingleImageView*)[self.view viewWithTag:channelID];
//    int decoderWidth=channel[callBackMsg.channelID].bmPlayVideoWidth;
//    int decoderHeight=channel[callBackMsg.channelID].bmPlayVideoHeight;
//    if([imgView getActivity]){
//        
//        [imgView stopActivity:@""];
//    }
//    if (selectChannel._iWaitICountPic>0) {
//        
//        selectChannel._iWaitICountPic--;
//    }else{
//        
//        
//        [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:decoderWidth decoderFrameHeight:decoderHeight];
//        
//        if (channel[callBackMsg.channelID].ImageData==nil||channel[callBackMsg.channelID].ImageData==NULL)  {
//            
//            int ver=[[[UIDevice currentDevice] systemVersion] intValue];
//            yuv_rgb(callBackMsg.channelID,(unsigned int*)(capImageBuffer[0]+66),ver);
//            CreateBitmap((unsigned char *)capImageBuffer[0],channel[callBackMsg.channelID].bmWidth,channel[callBackMsg.channelID].bmHeight,ver);
//            NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[callBackMsg.channelID].bmWidth*channel[callBackMsg.channelID].bmHeight*2+66];
//            channel[callBackMsg.channelID].ImageData=d;
//            [channel[callBackMsg.channelID] stopTimer];
//            
//        }
//        
//    }
//    
//    
//    [NSThread detachNewThreadSelector:@selector(StopOtherWindowsVideoData:) toTarget:self withObject:[NSString stringWithFormat:@"%d",callBackMsg.channelID]];
//    [pool release];
    
    
}


#pragma mark ----------－图像刷新方法
-(void) refreshImgView:(id)sender{
//    if (1==unAllLinkFlag) {
//        return;
//    }
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    CallBackMsg *callBackMsg= (CallBackMsg *)sender;
//    if (1==channel[callBackMsg.channelID].changeDecodeFlag) {
//        [pool release];
//        return;
//    }
//    
//    int _ID=channel[callBackMsg.channelID].flag*CONNECTMAXNUMS;
//    int channelID=callBackMsg.channelID+_ID+WINDOWSFLAG;
//    
//    monitorConnectionSingleImageView *imgView=(monitorConnectionSingleImageView*)[self.view viewWithTag:channelID];
//    if([imgView getActivity]){
//        
//        [imgView stopActivity:@""];
//    }
//    
//    UIImage *image = [UIImage imageWithData:(NSData *)callBackMsg.param];
//    
//    if(channel[callBackMsg.channelID].ImageData==nil||channel[callBackMsg.channelID].ImageData==NULL){
//        channel[callBackMsg.channelID].ImageData=callBackMsg.param;
//        [channel[callBackMsg.channelID] stopTimer];
//        
//    }else{
//        ///[channel[callBackMsg.channelID].ImageData release];
//        channel[callBackMsg.channelID].ImageData=callBackMsg.param;
//        
//    }
//    
//    if (channel[callBackMsg.channelID]==nil) {
//        //[NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:self withObject:[NSString stringWithFormat:@"%d",callBackMsg.channelID+1]];
//        [imgView setImage:nil];
//    }else {
//        if (image!=nil) {
//            [imgView setImage:image];
//        }
//    }
//    memset(imageBuffer[0], 0, sizeof(imageBuffer[0]));
//    [NSThread detachNewThreadSelector:@selector(StopOtherWindowsVideoData:) toTarget:self withObject:[NSString stringWithFormat:@"%d",callBackMsg.channelID]];
//    [pool release];
    
    
}

#pragma mark 控制云台的操作
-(void)ytCTL:(int)type goOn:(int)goOnFlag{
	int channelID=[self returnChannelID:self._iSelectedChannelIndex];
	//if (channel[channelID]!=nil) {
    //[channel[channelID] ytCTL:type goOn:goOnFlag];
	//}
    
    unsigned char data[4]={0};
	memcpy(&data[0],&type,4);
    
//	JVC_SendData(1, JVN_CMD_YTCTRL, (unsigned char *)data, 4);
    
    
}

#pragma mark 前往设置界面
-(void)gotoSettingView{
    
    // [self changeViewWithSave];
//    settingViewController *_setting=[[settingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:_setting animated:YES];
//    [_setting release];
    
    
}



-(void)changeBtnState:(NSTimer*)timer{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_bSmallTalkBtn setEnabled:YES];
    });
    [timer invalidate];
}

#pragma mark 停止本地录像和音频监听、语音对讲
-(void)stopSetting:(int)nLocalChannel{
    
//    if (self._isTalk) {
//        
//        self._isTalk=FALSE;
//        [self performSelectorOnMainThread:@selector(unSelectSmallButtonStyle:) withObject:_bSmallTalkBtn waitUntilDone:YES];
//        [_audioRecordControler stopRecord];
////        [channel[nLocalChannel] operationZKVideo:JVN_CMD_CHATSTOP];
//        while (TRUE) {
//            
//            if (channel[nLocalChannel]._isUseDecodeSound) {
//                
//                if (!channel[nLocalChannel]._isStartingSound) {
//                    
//                    JAD_DecodeClose(0);
//                    
//                    channel[nLocalChannel]._isUseDecodeSound=FALSE;
//                    break;
//                }
//                usleep(200);
//            }else{
//                break;
//            }
//        }
//        [_openALBufferSound stopSound];
//        [_openALBufferSound cleanUpOpenALMath];
//        
//        
//    }
//    if (self._isLocalVideo) {
//        
//        //[self operationPlayVideo:_bSmallVideoBtn];
//        [self performSelectorOnMainThread:@selector(operationPlayVideo:) withObject:_bSmallVideoBtn waitUntilDone:YES];
//    }
//    if (self._issound) {
//        
//        self._issound=FALSE;
//        
//        if (!iPhone5) {
//            
//            //[self unSelectBigButtonStyle:_bSoundBtn];
//            [self performSelectorOnMainThread:@selector(unSelectBigButtonStyle:) withObject:_bSoundBtn waitUntilDone:YES];
//            
//        }else{
//            
//            [self performSelectorOnMainThread:@selector(updateBigOperationView) withObject:nil waitUntilDone:YES];
//            
//        }
//        
//        while (TRUE) {
//            
//            if (channel[nLocalChannel]._isUseDecodeSound) {
//                
//                if (!channel[nLocalChannel]._isStartingSound) {
//                    
//                    JAD_DecodeClose(0);
//                    channel[nLocalChannel]._isUseDecodeSound = FALSE;
//                    break;
//                }
//                usleep(200);
//            }else{
//                break;
//            }
//        }
//        
//        [_openALBufferSound stopSound];
//        [_openALBufferSound cleanUpOpenALMath];
//        
//    }
}

-(void)updateBigOperationView{
    
    //    operationBigView._isPlaySound=FALSE;
    //    [operationBigView.tableView reloadData];
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
    
    [self removHelpView];
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    
    [self removHelpView];
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self shouldAutorotate];
    [self shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        
        [self changeRotateFromInterfaceOrientationFrame:YES];
        
    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        
        [self changeRotateFromInterfaceOrientationFrame:NO];
        
    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        
        [self changeRotateFromInterfaceOrientationFrame:NO];
    }else if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        
        [self changeRotateFromInterfaceOrientationFrame:YES];
    }
    
}


-(void)changeRotateFromInterfaceOrientationFrame:(BOOL)IsRotateFrom{
    
    if (IsRotateFrom) {
        
        self.navigationController.navigationBarHidden = NO;
        _managerVideo.frame=CGRectMake( _managerVideo.frame.origin.x,  _managerVideo.frame.origin.y, 320.0, 320*0.75);
        
        [_managerVideo changeContenView];
        [self.view bringSubviewToFront:_managerVideo];
        UIView *_smallView=(UIView*)[self.view viewWithTag:101];
        [self.view bringSubviewToFront:_smallView];
        
    }else{
        
        float _width=480.0;
        if (iphone5) {
            _width=568.0;
        }
        if (_splitViewCon.frame.size.height>0) {
            [self gotoShowSpltWindow];
        }
        self.navigationController.navigationBarHidden = YES;
        _managerVideo.frame=CGRectMake( _managerVideo.frame.origin.x,  _managerVideo.frame.origin.y, _width, 300.0);
        
        [_managerVideo changeContenView];
        [self.view bringSubviewToFront:_managerVideo];
    }
}

#pragma mark 返回远程回放的状态
-(BOOL)returnIsplayBackVideo{
    
    return _isPlayBackVideo;
    
}

-(void)sendPlayBackSEEK:(int)frameNumber{
    
//    int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//    if (channel[channelID]!=nil) {
//        
//        channel[channelID].isWaitIFrame=YES;
//        [channel[channelID] playBackVideoOperation:frameNumber];
//    }
//    
}


#pragma mark 判断当前是否存在一些特殊功能的开启《音频监听、远程回放等功能》
-(BOOL)returnOperationState{
    
    if (self._isLocalVideo||self._issound||_isPlayBackVideo||self._isTalk) {
        return TRUE;
    }
    
    return NO;
    
}


/**
 *	获取当前窗口GLView的是否可见
 *
 *	@return	获取当前窗口GLView的是否可见
 */
-(BOOL)isCheckCurrentSingleViewGlViewHidden{
    
    
     JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)[self.view viewWithTag:WINDOWSFLAG+self._iSelectedChannelIndex];
    
    return [singleView._glView._kxMoveGLView isHidden];
    
}

-(void)responseZkOperation:(int)channelID{
    
    
    
    
}


-(void)requestDeviceRemoteData:(NSString*)channelID{
    
    
//    int chanID=[channelID intValue];
//    if (channel[chanID]!=nil) {
//        
//        usleep(500*1000);
//        [channel[chanID] getFrameRateInfo];
//        
//    }
	
}

-(void)getFrameRateInfo:(NSString*)channelID{
    
    
//    int chanID=[channelID intValue];
//    if (channel[chanID]!=nil&&channel[chanID].connectDeviceType==4) {
//        
//        usleep(500*1000);
//        [channel[chanID] operationZKVideo:JVN_REQ_TEXT];
//    }
    
    
}

/**
 *  设备与其他分控语音对讲的时候，本设备再对讲的话收到的返回值的提示
 */
- (void)showAlert:(NSString *)alertString
{
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:alertString];
}

- (void)removHelpView
{
//    if (isShowHelper) {
////        [_helpImageView RemoveHelper];
//    }
}

/**
 *  播放界面的关闭,yes 正常情况下得点击取消帮助  no可能是旋转屏幕以及其他的操作
 */
- (void)HelpImageViewCallBackInOperationPlay
{
    
//    if (isShowHelper) {
//        
//        [_helpImageView.view removeFromSuperview];
//        
//        [_helpImageView  release];
//        _helpImageView = nil;
//        
//        
//        [OperationSet setAppInfoPish:@"yes" andKey:APP_Help_YT];
//        isShowHelper = NO;
//        
//    }
    
}
/**
 *  修改完之后的返回事件,连接视频的时候，用户名密码不正确，跳转到修改用户名密码界面，修改完成之后的回调
 */
- (void)modifyDeviceInfoCallBack
{
    [self connectSingleScrollChannel:iModifyIndex selectedChannel:iModifyIndex];
    
}



#pragma mark ********************************************
#pragma mark ********************************************
#pragma mark 切换窗口的布局
-(void)changeSplitView:(int)_splitWindows{
    
    if ([self._aDeviceChannelListData count]>1) {
        
        // [self gotoShowSpltWindow];
        
        if (_splitWindows>1) {
            
            int channelID=[self returnChannelID:self._iSelectedChannelIndex];
            [self stopSetting:channelID];
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(splitViewWindow:)]) {
            
            [self.delegate splitViewWindow:_splitWindows];
        }
        
    }
    
}

#pragma mark －－－－－－－－－－－－－－语音对讲、抓拍、本地录像、更多处理模块

/**
 *  bottom按钮按下的事件回调
 */
- (void)customBottomPressCallback:(NSUInteger )buttonPress
{
    /**
     *  判断画面是否显示出来
     */
    if (![self judgeOpenVideoPlaying]) {
        
        return;
    }
    
    UIButton *btn = [_operationItemSmallBg getButtonWithIndex:buttonPress];
    
    switch (buttonPress) {
            
        case BUTTON_TYPE_CAPTURE:
            
            [self smallCaptureTouchUpInside:btn];
            break;
            
        case BUTTON_TYPE_TALK:
            
            [self chatRequest:btn];
            break;
            
        case BUTTON_TYPE_VIDEO:
        {
            btn.selected = !btn.selected;
            
            [self operationPlayVideo:btn];
            
        }
            break;
            
        case BUTTON_TYPE_MORE:
            [self gotoSettingView];
            break;
            
        default:
            break;
    }
}

#pragma mark 保存图片
-(void)smallCaptureTouchUpInside:(UIButton*)button{
    
    //    int ID=[self returnChannelID:self._iSelectedChannelIndex];
    //
    //
    //    if (channel[ID]!=nil) {
    //
    //        if(channel[ID].isStandDecoder){
    //
    //            if (![self isCheckCurrentSingleViewGlViewHidden]) {
    //
    //                channel[ID]._iCapturePic=TRUE;
    //            }
    //
    //        }else if (channel[ID].ImageData!=nil){
    //
    //            [self saveLocalChannelPhoto];
    //
    //        }
    //    }
    
    
    /**
     *  保存照片失败的事件
     */
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        
        
        if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil)];
                [self unSelectSmallButtonStyle:_bSmallCaptureBtn];
                
                // NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"picturelibrayError", nil)];
                
                [self unSelectSmallButtonStyle:_bSmallCaptureBtn];
                //   NSLog(@"相册访问失败.");
            });
            
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group,BOOL *stop){
        
        [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper].ystNWRODelegate = self;
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_CaptureImage remoteOperationCommand:-1];
        
        // [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_CaptureImage remoteOperationCommand:-1];
    };
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSUInteger groupTypes =ALAssetsGroupFaces;// ALAssetsGroupAlbum;// | ALAssetsGroupEvent | ALAssetsGroupFaces;
    [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureblock];
    
    
    [library release];
    
}


/**
 *  开启语音对讲
 *
 *  @param button 语音对讲的按钮
 */
-(void)chatRequest:(UIButton*)button{
    
    
    
    JVCCloudSEENetworkHelper        *ystNetWorkObj   = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    OpenALBufferViewcontroller *openAlObj       = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    
    ystNetWorkObj.ystNWADelegate    = self;
    
    if (!button.selected) {
        
        [openAlObj initOpenAL];
        [ystNetWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_VoiceIntercom remoteOperationCommand:JVN_REQ_CHAT];
    }else {
        
        [ystNetWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_VoiceIntercom remoteOperationCommand:JVN_CMD_CHATSTOP];
        
        [openAlObj stopSound];
        [openAlObj cleanUpOpenALMath];
        
        /**
         *  使选中的button变成默认
         */
        [[JVCCustomOperationBottomView  shareInstance] setAllButtonUnselect];
    }
}

#pragma mark ystNetWorkHelpRemoteOperationDelegate  抓拍图片的委托代理

/**
 *  抓拍图片的委托代理
 *
 *  @param imageData 图片的二进制数据
 */
- (void)captureImageCallBack:(NSData *)imageData {
    
    [imageData retain];
    DDLogInfo(@"captureImageCallBack");
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imgView=capImageView;
                [self.view bringSubviewToFront:imgView];
                UIImage *image = [UIImage imageWithData:imageData];
                [imgView setImage:image];
                [capImageView setHidden:NO];
                [UIView beginAnimations:@"superView" context:nil];
                [UIView setAnimationDuration:0.4f];
                imgView.frame=CGRectMake((imgView.frame.size.width-_bSmallCaptureBtn.frame.size.width)/2.0, (imgView.frame.size.height-_bSmallCaptureBtn.frame.size.height)/2., STARTHEIGHTITEM, STARTHEIGHTITEM);
                [UIView commitAnimations];
                [imageData release];
                
                //                [self performSelector:@selector(capAnimations) withObject:nil afterDelay:0.3f];
                [self capAnimations];
                
            });
        }
    }];
    [library release];
    
}

/**
 *  打开采集音频模块
 *
 *  @param nAudioBit                采集的位数
 *  @param nAudioCollectionDataSize 采集数据的大小
 */
-(void)OpenAudioCollectionCallBack:(int)nAudioBit nAudioCollectionDataSize:(int)nAudioCollectionDataSize{
    
    AQSController *aqsControllerObj = [AQSController shareAQSControllerobjInstance];
    
    aqsControllerObj.delegate       = self;
    
    [[AQSController shareAQSControllerobjInstance] record:nAudioCollectionDataSize mChannelBit:nAudioBit];
    
}

#pragma mark AQSController Delegate

/**
 *  发送音频数据的回调函数
 *
 *  @param audionData    采集的音频数据
 *  @param audioDataSize 采集的音频数据大小
 */
-(void)receiveAudioDataCallBack:(char *)audionData audioDataSize:(long)audioDataSize{
    
    DDLogVerbose(@"audioDataSize=%ld",audioDataSize);
    [[JVCCloudSEENetworkHelper  shareJVCCloudSEENetworkHelper] RemoteSendAudioDataToDevice:_managerVideo.nSelectedChannelIndex+1 Audiodata:audionData nAudiodataSize:audioDataSize];
}


#pragma mark  operationMiddleViewDelegate  音频监听 云台 远程回放 处理模块

/**
 *   iphone4、4s中间的那块音频监听 云台 远程回放
 *
 *  @param buttonType 选中的那个button
 */
- (void)operationMiddleViewButtonCallback:(int)buttonType
{
    DDLogInfo(@"%s====%d",__FUNCTION__,buttonType);
    
    [self MiddleBtnClickWithIndex:buttonType];
    
}

/**
 * 按下事件的执行方法
 *
 *  @param index btn的index
 */
- (void)MiddleBtnClickWithIndex:(int )index
{
    /**
     *  判断画面是否显示出来
     */
    if (![self judgeOpenVideoPlaying]) {
        
        return;
    }
    
    switch (index) {
            
        case TYPEBUTTONCLI_SOUND:{
            
//            ystNetWorkHelper *ystNetworkObj = [ystNetWorkHelper shareystNetWorkHelperobjInstance];
            JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            ystNetworkObj.ystNWADelegate    =  self;
            [self audioButtonClick:NO];
            
        }
            break;
        case TYPEBUTTONCLI_YTOPERATION:
            [self ytoClick:nil];
            break;
            
        case TYPEBUTTONCLI_PLAYBACK:
            [self remotePlaybackClick];
            break;
            
        default:
            break;
    }
}

/**
 *  音频监听功能（关闭）
 *
 *  @param bState YES:(对讲模式下)  NO：音频监听模式下
 */
-(void)audioButtonClick:(BOOL)bState{
    
    OpenALBufferViewcontroller *openAlObj     = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    JVCCloudSEENetworkHelper           *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    /**
     *  如果是选中状态，置为非选中状态，如果是非选中状态，置为非选中状态
     */
    if ([[JVCOperationMiddleView  shareInstance] getAudioBtnState]) {
        
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:nil];
        
        [openAlObj stopSound];
        [openAlObj cleanUpOpenALMath];
        
        [[JVCOperationMiddleView  shareInstance] setButtonSunSelect];
        
    }else{
        
        if (!bState) {
            
            [openAlObj initOpenAL];
            [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:nil];
            
            [[JVCOperationMiddleView shareInstance] setSelectButtonWithIndex:0 skinType:skinSelect];
            
            [[JVCOperationMiddleView shareInstance] setSelectButtonWithIndex:0 skinType:skinSelect];
            
        }
    }
}

/**
 *  远程回放检索的事件
 */
-(void)remotePlaybackClick {
    
    [self playBackSendPlayVideoDate:[NSDate date]];
    
}

/**
 *  远程回放检索组合日期远程发送给设备
 *
 *  @param date 检索的日期
 */
-(void)playBackSendPlayVideoDate:(NSDate*)date{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
        
        NSDateFormatter *formatter    = [[NSDateFormatter alloc] init];
        
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSCalendar       *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSInteger         unitFlags   = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *comps       = [calendar components:unitFlags fromDate:date];
        
        int               year        = [comps year];
        int               month       = [comps month];
        int               day         = [comps day];
        
        NSString         *dateStr     = [[NSString alloc] initWithFormat:@"%04d%02d%02d000000%04d%02d%02d000000",year, month, day,year, month, day];
        
        [formatter  release];
        [calendar  release];
        
        JVCCloudSEENetworkHelper  *ystNetworkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetworkHelperObj.ystNWRODelegate    = self;
        
        [ystNetworkHelperObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:JVN_REQ_CHECK remoteOperationCommandData:(char *)[dateStr UTF8String] nRequestCount:4];
        
        [dateStr release];
        
        
        
        
    });
}

/**
 *  接收远程回放检索的视频文件列表
 *
 *  @param playbackSearchFileListMArray 视频文件列表
 */
-(void)remoteplaybackSearchFileListInfoCallBack:(NSMutableArray *)playbackSearchFileListMArray{
    
    
    DDLogVerbose(@"%s----list=%@",__FUNCTION__,playbackSearchFileListMArray);
    
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteRequestSendPlaybackVideo:_managerVideo.nSelectedChannelIndex+1 requestPlayBackFileInfo:[playbackSearchFileListMArray objectAtIndex:0] requestPlayBackFileDate:[NSDate date] requestPlayBackFileIndex:0];
    
}

#pragma mark 云台操作的回调

/**
 *  云台操作的回调
 *
 *  @param YTJVNtype 云台控制的命令
 */
- (void)YTOperationDelegateCallBackWithJVNYTCType:(int )YTJVNtype
{
    DDLogInfo(@"==%s===%d",__FUNCTION__,YTJVNtype);
    
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_YTO remoteOperationCommand:YTJVNtype];
}

#pragma mark 点击4、9、16分屏的回调
/**
 *  点击4、9、16分屏的回调
 *
 *  @param screanNum 分屏num
 */
- (void)customCoverViewButtonCkickCallBack:(int)screanNum
{
    DDLogInfo(@"%s====%d",__FUNCTION__,screanNum);
    
    if (screanNum == SCREAN_ONE) {//点击的背景，关闭
        [self gotoShowSpltWindow];
    }else{
        
        [self changeSplitView:(screanNum+2)*(screanNum+2)];
        
    }
}

#pragma mark 关闭音频监听、对讲、录像的功能

/**
 *  关闭音频监听、对讲、录像的功能
 */
- (void)closeAudioAndTalkAndVideoFuction
{
    
    /**
     *  关闭录像
     */
    UIButton *btn = [_operationItemSmallBg getButtonWithIndex:2];//获取录像的按钮
    if (btn.selected) {
        
        btn.selected = NO;
        [self operationPlayVideo:btn];
    }
    
    /**
     *  关闭音频监听
     */
    [self stopAudioMonitor];
    
    /**
     *  关闭对讲
     */
}

#pragma mark 开启本地录像
-(void)operationPlayVideo:(UIButton*)button{
    
    if (button.selected) {
        
        /**
         *  保存录像的回调
         */
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil)];
                    
                    [self unSelectSmallButtonStyle:button];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"picturelibrayError", nil)];
                    
                    //   NSLog(@"相册访问失败.");
                    [self unSelectSmallButtonStyle:button];
                });
                
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group,BOOL *stop){
            
            NSString *documentPaths = NSTemporaryDirectory();
            
            NSString *filePath = [documentPaths stringByAppendingPathComponent:@"LocalValue"];
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
            }
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYYMMddHHmmssSSSS"];
            NSString *videoPath =[NSString stringWithFormat:@"%@/%@.mp4",filePath,[df stringFromDate:[NSDate date]]];
            [df release];
            
            [_strSaveVideoPath  release];
            _strSaveVideoPath= nil;
            
            _strSaveVideoPath = [videoPath retain];
            
          //  [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] runLocalVideoReturnUILocalVideo:_managerVideo.nSelectedChannelIndex+1 saveLocalVideoPath:videoPath];
            
        };
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSUInteger groupTypes =ALAssetsGroupFaces;// ALAssetsGroupAlbum;// | ALAssetsGroupEvent | ALAssetsGroupFaces;
        [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureblock];
        
    }else{
        
        //        [[ystNetWorkHelper shareystNetWorkHelperobjInstance] runLocalVideoReturnUILocalVideo:_managerVideo.nSelectedChannelIndex+1 saveLocalVideoPath:_strSaveVideoPath];
        
        [self saveLocalVideo:_strSaveVideoPath];
    }
}


/**
 *  停止音频监听
 */
- (void)stopAudioMonitor
{
    if ([[JVCOperationMiddleView shareInstance] getAudioBtnState]) {
        
        [self MiddleBtnClickWithIndex:TYPEBUTTONCLI_SOUND];
        
        [[JVCOperationMiddleView shareInstance] setButtonSunSelect];
        
    }
    
}

#pragma mark  语音对讲的回调
/**
 *  语音对讲的回调
 *
 *  @param VoiceInterState 对讲的状态
 */
-(void)VoiceInterComCallBack:(int)VoiceInterState
{
    return;
    DDLogInfo(@"音频对讲的回调=%s===%d",__FUNCTION__,VoiceInterState);
    /**
     *  使选中的button变成莫仍
     */
    [[JVCCustomOperationBottomView shareInstance] setAllButtonUnselect];
    
    AQSController  *aqControllerobj = [AQSController shareAQSControllerobjInstance];
    
    switch (VoiceInterState) {
            
        case VoiceInterStateType_Succeed:{
            //打开语音对讲
            [self performSelectorOnMainThread:@selector(OpenChatVoice) withObject:self waitUntilDone:NO];
            
        }
            break;
//        case VoiceInterStateType_Stop:{
//            
//            [aqControllerobj stopRecord];
//        }
            
            break;
            
        default:
            break;
    }
    NSLog(@"%s===语音对讲的回调=%d",__FUNCTION__,VoiceInterState);
}

/**
 *  打开语音对讲
 */
- (void)OpenChatVoice
{
    //判断是否开启音频监听、如果打开关闭音频监听
    [self audioButtonClick:YES];
    
    /**
     *  选中对讲button
     */
    [[JVCCustomOperationBottomView shareInstance] setbuttonSelectStateWithIndex:1 andSkinType:skinSelect];
}

#pragma mark ystNetWorkHelper 

/**
 *  ystNetWorkAudioDelegate ystNetWorkAudioDelegate
 *
 *  @param soundBuffer     音频数据
 *  @param soundBufferSize 音频数据大小
 *  @param soundBufferType 音频数据类型 YES：16bit NO：8bit
 */
-(void)playVideoSoundCallBackMath:(char *)soundBuffer soundBufferSize:(int)soundBufferSize soundBufferType:(BOOL)soundBufferType{
    
    [[OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance] openAudioFromQueue:(short *)soundBuffer dataSize:soundBufferSize monoValue:soundBufferType];
    
}

/**
 *  判断是否打开远程配置
 *
 *  @return yes 打开  no 取消
 */
- (BOOL)judgeOpenVideoPlaying
{
    return [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] checknLocalChannelExistConnect:_managerVideo.nSelectedChannelIndex+1];
}

@end




