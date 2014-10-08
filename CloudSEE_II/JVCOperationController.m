//
//  JVCOperationController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationController.h"
#import "JVCCustomOperationBottomView.h"
#import "JVCOperationMiddleViewIphone5.h"
#import "OpenALBufferViewcontroller.h"
#import "JVCManagePalyVideoComtroller.h"
#import "JVCRemoteVideoPlayBackVControler.h"
#import "JVCCustomCoverView.h"
#import "JVCOperationMiddleView.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCCustomYTOView.h"
#import "JVCDeviceSourceHelper.h"
#import "JVNetConst.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "GlView.h"

#import<AssetsLibrary/AssetsLibrary.h>

#define STARTHEIGHTITEM  40

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
@synthesize _playBackVideoDataArray,_playBackDateString,_isConnectdevcieType;
@synthesize _amDeviceListData,_selectedDeviceIndex;
@synthesize showSingeleDeviceLongTap,_isConnectModel;
@synthesize delegate;

JVCOperationController *_operationController;
JVCCustomOperationBottomView *_operationItemSmallBg;

#define CONNECTMAXNUMS 16

char imageBuffer[1][1280*720*3];
char imageBufferY[1][1280*720*3];
char imageBufferU[1][1920*1080];
char imageBufferV[1][1920*1080];

char capImageBuffer[1][1280*720*3];


OpenALBufferViewcontroller *_openALBufferSound;
AQSController *_audioRecordControler;
char ppszPCMBuf[640];;
int windowsPageNums;
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
NSTimer *repeatLinkTimer[CONNECTMAXNUMS];
int linkFlag[CONNECTMAXNUMS];
int _iWindowsSelectedChannelIndex[CONNECTMAXNUMS];



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


bool _isAllLinkFlag;

bool isShowHelper;

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
    
    if (IOS_VERSION>=7.0) {
        
        self.automaticallyAdjustsScrollViewInsets =NO;
    }
    
    _isAllLinkFlag=FALSE;
    unAllLinkFlag=0;
    isShowHelper = NO;
    
    self._isConnectdevcieType=FALSE;
    _isConnectdevcieOpenDecoder=FALSE;
    self._issound=FALSE;
    self._isTalk=FALSE;
    self._isLocalVideo=FALSE;
    windowsPageNums=1;
    _operationController=self;
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
    
    _amUnSelectedImageNameListData=[[NSMutableArray alloc] initWithCapacity:10];
    
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"smallCaptureUnselectedBtn.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"megaphoneUnselected.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"videoUnselected.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"moreUnselected.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"audioListener.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"ytoBtn.png"]];
    [_amUnSelectedImageNameListData addObject:[NSString stringWithFormat:@"%@",@"playBackVideo.png"]];
    
    _amSelectedImageNameListData=[[NSMutableArray alloc] initWithCapacity:10];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"smallCaptureSelectedBtn_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"megaphoneSelected_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"videoSelected_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"moreSelected_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"audioListennerSelected_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"ytoSelectedBtn_%d.png",0]];
    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"playBackVideoSelected_%d.png",0]];
    
    
    /**
     *  返回按钮
     */
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
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
    [capImageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:capImageView];
    [capImageView setHidden:YES];
    //[capImageView release];
    
    
    /**
     *  抓拍、对讲、录像、更多按钮的view
     */
    UIImage *_smallItemBgImage=[UIImage imageNamed:@"smallItem__Normal.png"];
    CGRect frameBottom ;
    
    if (IOS_VERSION>=7.0) {
        frameBottom = CGRectMake(0.0, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-_smallItemBgImage.size.height-20, self.view.frame.size.width, _smallItemBgImage.size.height);
    }else{
        frameBottom = CGRectMake(0.0, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-_smallItemBgImage.size.height, self.view.frame.size.width, _smallItemBgImage.size.height);
        
    }
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
    skinSelect = 0;
    
    //    [_amSelectedImageNameListData removeAllObjects];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"smallCaptureSelectedBtn_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"megaphoneSelected_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"videoSelected_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"moreSelected_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"audioListennerSelected_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"ytoSelectedBtn_%d.png",delegate.selectSkin]];
    //    [_amSelectedImageNameListData addObject:[NSString stringWithFormat:@"playBackVideoSelected_%d.png",delegate.selectSkin]];
    //
    //    /**
    //     *  判断是不是要显示帮助
    //     */
    //    [self judgeShowFirsthelpView];
    //
    //    //[_bSoundBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ytoSelectedBtn_%d.png",delegate.selectSkin] ]forState:UIControlStateHighlighted];
    //    [_bYTOBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ytoSelectedBtn_%d.png",delegate.selectSkin]] forState:UIControlStateHighlighted];
    //
    //    UIButton *_bPlayBackVideoBtn=(UIButton *)[self.view viewWithTag:99977];
    //    [_bPlayBackVideoBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"playBackVideoSelected_%d.png",delegate.selectSkin]] forState:UIControlStateHighlighted];
    //
    //    UIImage *_smallItemBgImage=[UIImage imageNamed:[NSString stringWithFormat: @"smallItem_Hover_%d.png",delegate.selectSkin]];
    //    [_bSmallTalkBtn setBackgroundImage:_smallItemBgImage forState:UIControlStateHighlighted];
    //    [_bSmallVideoBtn setBackgroundImage:_smallItemBgImage forState:UIControlStateHighlighted];
    //    [self unSelectSmallButtonStyle:_bSmallCaptureBtn];
    //    if (self._issound) {
    //        [_bSoundBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"audioListennerSelected_%d.png",delegate.selectSkin]] forState:UIControlStateNormal];
    //    }
    //    if (self._isLocalVideo) {
    //        [self selectSmallButtonStyle:_bSmallVideoBtn];
    //    }else{
    //        [self unSelectSmallButtonStyle:_bSmallVideoBtn];
    //    }
    //
    //    if (self._isTalk) {
    //        [self selectSmallButtonStyle:_bSmallTalkBtn];
    //    }else{
    //        [self unSelectSmallButtonStyle:_bSmallTalkBtn];
    //    }
    //
    //    [self unSelectSmallButtonStyle:_bSmallMoreBtn];
    
    
    //
    //    if (_splitViewCon) {
    //        [_splitViewCon setSelectBg];
    //    }
    //
    //    [operationBigView reloadTableData];
    
}


//- (void)judgeShowFirsthelpView
//{
//    isShowHelper = YES;
//    NSMutableDictionary *tAppDic = [NSMutableDictionary dictionaryWithContentsOfFile:[OperationSet getAppInfoPlistPath]];
//    if([[tAppDic objectForKey:APP_Help_YT] isEqualToString:@"no"])
//    {
//        _helpImageView = [[HelpViewController alloc] init];
//        _helpImageView.delegateImageHelp = self;
//        [self.view addSubview:_helpImageView.view];
//        [self.view bringSubviewToFront:_helpImageView.view];
//        [_helpImageView initHelpImageViewInOperationPlayingVC:_aDeviceChannelListData];
//    }
//}
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



//-(void)playBackSendPlayVideoData:(NSDate*)date{
//    
//    int channleID=[self returnChannelID:self._iSelectedChannelIndex];
//    //远程回放请求
//    char pBuf[29] = {0};
//    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
//    
//    [formatter setTimeStyle:NSDateFormatterMediumStyle];
//    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    // NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
//    NSInteger unitFlags = NSYearCalendarUnit |
//    NSMonthCalendarUnit |
//    NSDayCalendarUnit |
//    NSWeekdayCalendarUnit |
//    NSHourCalendarUnit |
//    NSMinuteCalendarUnit |
//    NSSecondCalendarUnit;
//    //int week=0;
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
//    //int week = [comps weekday];
//    int year=[comps year];
//    int month = [comps month];
//    int day = [comps day];
//    NSString *dateStr = [[NSString alloc] initWithFormat:@"%04d%02d%02d000000%04d%02d%02d000000",year, month, day,year, month, day];
//    memset(&pBuf, 0, 29);
//    sprintf(pBuf, [dateStr UTF8String], 29);
//    //    JVC_SendData(channleID+1,JVN_CMD_PLAYSTOP,NULL,0);
//    //    sleep(0.5);
//	JVC_SendData(channel[channleID].nChannel+1,JVN_REQ_CHECK,pBuf,28);
//    
//    //    sleep(0.5);
//    
//    [dateStr release];
//    
//    
//}


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
            
//            [[ystNetWorkHelper shareystNetWorkHelperobjInstance] runLocalVideoReturnUILocalVideo:_managerVideo.nSelectedChannelIndex+1 saveLocalVideoPath:videoPath];
            
        };
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSUInteger groupTypes =ALAssetsGroupFaces;// ALAssetsGroupAlbum;// | ALAssetsGroupEvent | ALAssetsGroupFaces;
        [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureblock];
        
    }else{
        
//        [[ystNetWorkHelper shareystNetWorkHelperobjInstance] runLocalVideoReturnUILocalVideo:_managerVideo.nSelectedChannelIndex+1 saveLocalVideoPath:_strSaveVideoPath];
        
        [self saveLocalVideo:_strSaveVideoPath];
    }
}

//-(void)smallCaptureTouchDown:(UIButton*)button{
//
//    [self selectSmallButtonStyle:button];
//
//
//
//}

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

-(UIImage*)convertViewToImage:(UIView*)v{
    
    
    
    UIGraphicsBeginImageContext(v.bounds.size);
    
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
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
    
	for (int i=0; i<CONNECTMAXNUMS; i++) {
        
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
    
	for (int i=0; i<CONNECTMAXNUMS; i++) {
        
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
    
    for (int i=0; i<CONNECTMAXNUMS; i++) {
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
    
    return windowIndexValue%CONNECTMAXNUMS;
    
}

-(int)returnChannelPage:(int)windowIndexValue{
    return windowIndexValue/CONNECTMAXNUMS;
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
#pragma mark 远程回放播放视频
-(void)playBackDisplay:(int)selecetedIndex playBackDate:(NSDate*)date{
    
//    _iPlayBackVideo=selecetedIndex;
//    int channelID=[self returnChannelID:self._iSelectedChannelIndex];
//    JVChannel *selectChannel= channel[channelID];
//    if (!selectChannel) {
//        return;
//    }else if(selectChannel){
//        
//        NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
//        [formatter setTimeStyle:NSDateFormatterMediumStyle];
//        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//        //        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
//        NSInteger unitFlags = NSYearCalendarUnit |
//        NSMonthCalendarUnit |
//        NSDayCalendarUnit |
//        NSWeekdayCalendarUnit |
//        NSHourCalendarUnit |
//        NSMinuteCalendarUnit |
//        NSSecondCalendarUnit;
//        //int week=0;
//        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
//        //int week = [comps weekday];
//        int year=[comps year];
//        int month = [comps month];
//        int day = [comps day];
//        
//        
//        NSMutableDictionary *dic = [_playBackVideoDataArray objectAtIndex:selecetedIndex];
//        //NSLog(@"%@",dic);
//        char acBuff[50] = {0};
//        char acChn[3] = {0};
//        char acTime[10] = {0};
//        char acDisk[2] = {0};
//        if (selectChannel.IsStartCode) {
//            
//            
//            if (selectChannel.connectDeviceType==4||selectChannel.connectDeviceType==1) {
//                sprintf(acChn, "%s",[[dic valueForKey:@"remoteChannel"] UTF8String]);
//                sprintf(acTime, "%s",[[dic valueForKey:@"date"] UTF8String]);
//                //                char *diskc  = (char *) [[dic valueForKey:@"disk"] substringFromIndex:4];
//                //                int a;
//                //                a=(int)*diskc;
//                //                sprintf(acDisk, "%s",(a-1)*10);
//                sprintf(acBuff, "./rec/%02d/%04d%02d%02d/%c%c%c%c%c%c%c%c%c.mp4",acFLBuffer[selecetedIndex*2]-'C',year, month, day,acFLBuffer[selecetedIndex*2+1],acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]);
//                
//                
//            }else if(selectChannel.connectDeviceType==0){
//                
//                sprintf(acChn, "%s",[[dic valueForKey:@"remoteChannel"] UTF8String]);
//                sprintf(acTime, "%s",[[dic valueForKey:@"date"] UTF8String]);
//                sprintf(acDisk, "%s",[[dic valueForKey:@"disk"] UTF8String]);
//                sprintf(acBuff, "%c:\\JdvrFile\\%04d%02d%02d\\%c%c%c%c%c%c%c%c.mp4",acDisk[0],year, month, day,acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]
//                        );
//                //  NSLog(@"%s",acBuff);
//            }
//            
//            //            else{
//            //
//            //
//            //
//            //            }
//            //            sprintf(acBuff, "%c:\\JdvrFile\\%04d%02d%02d\\%c%c%c%c%c%c%c%c.mp4",acDisk[0],year, month, day,acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]
//            //                    );
//            //printf("url: %s\n",acBuff);
//        }else if(selectChannel.connectDeviceType==0){
//            sprintf(acChn, "%s",[[dic valueForKey:@"remoteChannel"] UTF8String]);
//            sprintf(acTime, "%s",[[dic valueForKey:@"date"] UTF8String]);
//            sprintf(acDisk, "%s",[[dic valueForKey:@"disk"] UTF8String]);
//            sprintf(acBuff, "%c:\\JdvrFile\\%04d%02d%02d\\%c%c%c%c%c%c%c%c.sv4",acDisk[0],year, month, day,acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]
//                    );
//            //printf("url: %s\n",acBuff);
//            
//        }else if(selectChannel.connectDeviceType==1 ||selectChannel.connectDeviceType==4){
//            sprintf(acChn, "%s",[[dic valueForKey:@"remoteChannel"] UTF8String]);
//            sprintf(acTime, "%s",[[dic valueForKey:@"date"] UTF8String]);
//            sprintf(acBuff, "./rec/%02d/%04d%02d%02d/%c%c%c%c%c%c%c%c%c.sv5",acFLBuffer[2*2]-'C',year, month, day,acFLBuffer[2*2+1],acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]);
//            printf("url: %s\n",acBuff);
//        }else if(selectChannel.connectDeviceType==2 ||selectChannel.connectDeviceType==3){
//            sprintf(acChn, "%s",[[dic valueForKey:@"remoteChannel"] UTF8String]);
//            sprintf(acTime, "%s",[[dic valueForKey:@"date"] UTF8String]);
//            sprintf(acDisk, "%s",[[dic valueForKey:@"disk"] UTF8String]);
//            sprintf(acBuff, "%c:\\JdvrFile\\%04d%02d%02d\\%c%c%c%c%c%c%c%c.sv6",acDisk[0],year, month, day,acChn[0],acChn[1],acTime[0],acTime[1],acTime[3],acTime[4],acTime[6],acTime[7]
//                    );
//            //printf("url: %s\n",acBuff);
//            
//        }
//        
//        JVC_SendData(channelID+1,JVN_CMD_PLAYSTOP,NULL,0);
//        usleep(50000);
//        JVC_SendData(channelID+1,JVN_REQ_PLAY,(unsigned char*)acBuff,strlen(acBuff));
//    }
}


#pragma mark 视频流回调函数
void deliverDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize,int nWidth,int nHeight){
    
//    if (1==unAllLinkFlag||_isPlayBackVideo||nLocalChannel>CONNECTMAXNUMS) {
//        return;
//    }
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    if (nSize>0) {
//        
//        JVChannel *selectChannel= channel[nLocalChannel-1];
//        
//        if (selectChannel==nil) {
//            
//            [pool release];
//            return;
//        }
//        
//        if (uchType==JVN_DATA_I || uchType==JVN_DATA_B || uchType==JVN_DATA_P) {
//            
//            if (1==selectChannel.changeDecodeFlag) {
//                [pool release];
//                return;
//            }
//            
//            int ver=[[[UIDevice currentDevice] systemVersion] intValue];
//            
//            int startCode = 0;
//            
//			memcpy(&startCode, pBuffer, 4);
//            
//            if (startCode==0x0453564A ||startCode==0x0953564A) {//非准解马流
//                
//                unsigned int i_data =*(unsigned int *)(pBuffer+4);
//                unsigned int uType = i_data & 0xF;
//                
//                if (uType>4) {
//                    [pool release];
//                    return;
//                }
//                
//                unsigned int nLen = (i_data>>4) & 0xFFFFF;
//                //等待i针
//                if (!selectChannel.isWaitIFrame) {
//                    
//                    if (uType==JVN_DATA_I) {
//                        if (selectChannel.bmWidth>0&&selectChannel.bmHeight>0) {
//                            
//                            selectChannel.isWaitIFrame=TRUE;
//                            JVD04_DecodeOpen(selectChannel.bmWidth ,selectChannel.bmHeight,nLocalChannel-1);
//                            selectChannel.openDecoderFlag=true;
//                        }else{
//                            [pool release];
//                            return;
//                        }
//                        
//                    }else{
//                        selectChannel.isWaitIFrame=FALSE;
//                        [pool release];
//                        return;
//                    }
//                }
//                
//                if (!selectChannel.openDecoderFlag) {
//                    [pool release];
//                    return;
//                }
//                selectChannel.UseDecoderFlag=TRUE;
//                int ret1=JVD04_DecodeOneFrame((unsigned char*)pBuffer+8,imageBuffer[0],nLen, nLocalChannel-1, uType,ver);
//                selectChannel.UseDecoderFlag=FALSE;
//                if (ret1==0) {
//                    
//                    selectChannel.tryCount=0;
//                    NSData *d=[NSData dataWithBytes:imageBuffer[0] length:selectChannel.bmWidth*selectChannel.bmHeight*2+66];
//                    //memset(imageBuffer[0], 0, sizeof(imageBuffer[0]));
//                    CallBackMsg *m=[[CallBackMsg alloc] init];
//                    m.channelID=nLocalChannel-1;
//                    m.param=d;
//                    [_operationController performSelectorOnMainThread:@selector(refreshImgView:) withObject:m waitUntilDone:YES];
//                    [m release];
//                }else{
//                    
//                    selectChannel.tryCount++;
//                    if (selectChannel.tryCount>=TRYCOUNTMAX) {
//                        selectChannel.changeDecodeFlag=1;
//                        selectChannel.tryCount=0;
//                        selectChannel.isWaitIFrame=FALSE;
//                        if (selectChannel.openDecoderFlag) {
//                            
//                            selectChannel.openDecoderFlag=FALSE;
//                            
//                            while (TRUE) {
//                                
//                                if (!selectChannel.UseDecoderFlag) {
//                                    
//                                    if(selectChannel.isStandDecoder){
//                                        JVD05_DecodeClose(nLocalChannel-1);
//                                    }
//                                    break;
//                                    
//                                }
//                                usleep(200);
//                            }
//                        }
//                        selectChannel.tryCount=222;
//                        
//                    }
//                    [pool release];
//                    return;
//                }
//                
//            }else{
//                
//                if (!selectChannel.openDecoderFlag) {
//                    
//                    if (selectChannel.bmWidth>0&&selectChannel.bmHeight>0) {
//                        
//                        memset(imageBufferY[0], 0, sizeof(imageBufferY[0]));
//                        memset(imageBufferU[0], 0, sizeof(imageBufferU[0]));
//                        memset(imageBufferV[0], 0, sizeof(imageBufferV[0]));
//                        
//                        JVD05_DecodeOpen(nLocalChannel-1);
//                        selectChannel.openDecoderFlag=TRUE;
//                    }
//                }
//                
//                if (!selectChannel.openDecoderFlag) {
//                    [pool release];
//                    return;
//                }
//                
//                int  ret=-1;
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    if (!selectChannel.isWaitIFrame) {
//                        
//                        if (uchType==JVN_DATA_I) {
//                            
//                            selectChannel._iWaitICount--;
//                            
//                            if (selectChannel._iWaitICount<=0) {
//                                
//                                selectChannel.isWaitIFrame=TRUE;
//                                
//                            }else{
//                                
//                                [pool release];
//                                return;
//                            }
//                            
//                        }else{
//                            
//                            [pool release];
//                            return;
//                            
//                        }
//                    }
//                    
//                    if ([_operationController isKindOfBufInStartCode:pBuffer]) {
//                        
//                        pBuffer=pBuffer+8;
//                        nSize=nSize-8;
//                    }
//                    
//                    
//                    if (selectChannel.IsLocalVideo) {
//                        
//                        if (!selectChannel.isLocalVideoWaitIFrame) {
//                            
//                            if (uchType==JVN_DATA_I) {
//                                selectChannel.isLocalVideoWaitIFrame=TRUE;
//                                JP_PackageOneFrame((unsigned char*)pBuffer, nSize, nLocalChannel-1);
//                                
//                            }
//                            
//                        }else{
//                            if (uchType!=JVN_DATA_B) {
//                                JP_PackageOneFrame((unsigned char*)pBuffer, nSize, nLocalChannel-1);
//                            }else{
//                                int tempSize = nSize;
//                                unsigned char pp[tempSize];
//                                memset(pp, 0, tempSize);
//                                JP_PackageOneFrame(pp ,nSize, nLocalChannel - 1,0,0);
//                            }
//                        }
//                        
//                    }
//                    if (_operationController._isConnectdevcieType) {
//                        
//                        if (uchType!=JVN_DATA_I) {
//                            [pool release];
//                            return;
//                        }
//                    }
//                    selectChannel.UseDecoderFlag=TRUE;
//                    
//                    ret = JVD05_DecodeOneFrame(nLocalChannel-1,nSize,pBuffer,imageBufferY[0],imageBufferU[0],imageBufferV[0],0,ver,0);
//                    
//                    if (channel[nLocalChannel-1]._iCapturePic) {
//                        
//                        yuv_rgb(nLocalChannel-1,(unsigned int*)(capImageBuffer[0]+66),ver);
//                        CreateBitmap((unsigned char *)capImageBuffer[0],channel[nLocalChannel-1].bmWidth,channel[nLocalChannel-1].bmHeight,ver);
//                        NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[nLocalChannel-1].bmWidth*channel[nLocalChannel-1].bmHeight*2+66];
//                        channel[nLocalChannel-1].ImageData=d;
//                        [_operationController performSelectorOnMainThread:@selector(saveLocalChannelPhoto) withObject:nil waitUntilDone:NO];
//                        
//                    }
//                    selectChannel.UseDecoderFlag=FALSE;
//                    
//                    
//                    
//                }
//                else{
//                    
//                    JVS_FRAME_HEADER *jvs_header=(JVS_FRAME_HEADER*)pBuffer;
//                    
//                    if (!selectChannel.isWaitIFrame) {
//                        
//                        if (jvs_header->nFrameType==JVN_DATA_I) {
//                            
//                            if (selectChannel._iWaitICount<=0) {
//                                
//                                selectChannel.isWaitIFrame=TRUE;
//                                
//                            }else{
//                                
//                                selectChannel._iWaitICount--;
//                                [pool release];
//                                return;
//                            }
//                            
//                        }else{
//                            
//                            [pool release];
//                            return;
//                        }
//                    }
//                    if (selectChannel.IsLocalVideo) {
//                        
//                        if (!selectChannel.isLocalVideoWaitIFrame) {
//                            
//                            if (jvs_header->nFrameType==JVN_DATA_I) {
//                                
//                                selectChannel.isLocalVideoWaitIFrame=TRUE;
//                                
//                                JP_PackageOneFrame((unsigned char*)pBuffer+8, jvs_header->nFrameLens, nLocalChannel-1);
//                            }
//                            
//                        }else{
//                            
//                            if (jvs_header->nFrameType!=JVN_DATA_B) {
//                                
//                                JP_PackageOneFrame((unsigned char*)pBuffer+8, jvs_header->nFrameLens, nLocalChannel-1);
//                                
//                            }else{
//                                int tempSize = nSize;
//                                unsigned char pp[tempSize];
//                                memset(pp, 0, tempSize);
//                                JP_PackageOneFrame(pp ,nSize, nLocalChannel - 1,0,0);
//                            }
//                        }
//                        
//                    }
//                    if (_operationController._isConnectdevcieType) {
//                        
//                        if (jvs_header->nFrameType!=JVN_DATA_I) {
//                            [pool release];
//                            return;
//                        }
//                    }
//                    
//                    selectChannel.UseDecoderFlag=TRUE;
//                    
//                    ret = JVD05_DecodeOneFrame(nLocalChannel-1,jvs_header->nFrameLens,pBuffer+8,imageBufferY[0],imageBufferU[0],imageBufferV[0],0,ver,0);
//                    if (channel[nLocalChannel-1]._iCapturePic) {
//                        
//                        yuv_rgb(nLocalChannel-1,(unsigned int*)(capImageBuffer[0]+66),ver);
//                        CreateBitmap((unsigned char *)capImageBuffer[0],channel[nLocalChannel-1].bmWidth,channel[nLocalChannel-1].bmHeight,ver);
//                        NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[nLocalChannel-1].bmWidth*channel[nLocalChannel-1].bmHeight*2+66];
//                        channel[nLocalChannel-1].ImageData=d;
//                        [_operationController performSelectorOnMainThread:@selector(saveLocalChannelPhoto) withObject:nil waitUntilDone:NO];
//                        
//                    }
//                    selectChannel.UseDecoderFlag=FALSE;
//                    
//                }
//                if (ret==0) {
//                    
//                    selectChannel.tryCount=0;
//                    
//                    CallBackMsg *m=[[CallBackMsg alloc] init];
//                    m.channelID=nLocalChannel-1;
//                    
//                    
//                    [_operationController performSelectorOnMainThread:@selector(openglRefresh:) withObject:m waitUntilDone:YES];
//                    [m release];
//                    
//                    
//                }else{
//                    
//                    selectChannel.tryCount++;
//                    if (selectChannel.tryCount>=TRYCOUNTMAX) {
//                        selectChannel.changeDecodeFlag=1;
//                        selectChannel.tryCount=0;
//                        selectChannel.isWaitIFrame=FALSE;
//                        if (selectChannel.openDecoderFlag) {
//                            
//                            selectChannel.openDecoderFlag=FALSE;
//                            
//                            while (TRUE) {
//                                
//                                if (!selectChannel.UseDecoderFlag) {
//                                    
//                                    if(selectChannel.isStandDecoder){
//                                        JVD05_DecodeClose(nLocalChannel-1);
//                                    }
//                                    
//                                    break;
//                                    
//                                }
//                                usleep(200);
//                            }
//                        }
//                        selectChannel.tryCount=222;
//                        [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel]];
//                    }
//                    
//                    
//                }
//            }
//			
//        } else if(uchType==JVN_DATA_O){
//            
//            
//            if (pBuffer[0]!=0) {
//                
//                [pool release];
//                return;
//            }
//            
//            
//            if ([_operationController IsFILE_HEADER_EX:pBuffer dwSize:nSize]) {
//                
//                
//                JVS_FILE_HEADER_EX *fileHeader;
//                fileHeader = malloc(sizeof(JVS_FILE_HEADER_EX));
//                memset(fileHeader, 0, sizeof(JVS_FILE_HEADER_EX));
//                memcpy(fileHeader, pBuffer+2, sizeof(JVS_FILE_HEADER_EX));
//                
//                selectChannel._dPlayVideoframeFrate = ((double)fileHeader->wFrameRateNum)/((double)fileHeader->wFrameRateDen);
//                selectChannel._iAudioType=fileHeader->wAudioCodecID;
//                
//                free(fileHeader);
//                
//            }
//            int startCode = 0;
//            int width = 0;
//            int height = 0;
//            
//            memcpy(&startCode, pBuffer+2, 4);
//            memcpy(&width, pBuffer+6, 4);
//            memcpy(&height, pBuffer+10, 4);
//            
//            if (startCode==JVN_NVR_STARTCODE) {
//                
//                memcpy(&startCode, pBuffer+26, 4);
//            }
//            selectChannel.connectDeviceType = 0; //软卡
//            if (startCode==0x0553564A||startCode==0x0553564A) {//判断是dvr
//                selectChannel.connectDeviceType = 1;//DVR
//            }else if(startCode==0x0753564A){//判断951
//                selectChannel.connectDeviceType = 3; //硬卡
//            }else if(startCode==0x0653564A){//判断950
//                selectChannel.connectDeviceType = 2; //硬卡
//            }else if(startCode==0x1053564A ||startCode==0x1153564A){  //IPC
//                selectChannel.connectDeviceType = 4;
//            }
//            selectChannel.connectStartCode=startCode;
//            
//            // NSLog(@"init with o zhen");
//            if (selectChannel.connectStartCode==JVN_DSC_960CARD) {
//                
//                if (![_operationController IsFILE_HEADER_EX:pBuffer dwSize:nSize]){
//                    
//                    int version = 0;
//                    int frameType =0;
//                    int frameRate = 0;
//                    memcpy(&version, pBuffer+34, 1);
//                    memcpy(&frameType, pBuffer+35, 1);
//                    memcpy(&frameRate, pBuffer+36, 4);
//                    selectChannel._dPlayVideoframeFrate = (double)frameRate/10000;
//                    
//                }
//                
//            }
//            
//            //[NSThread detachNewThreadSelector:@selector(getFrameRateInfo:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel-1]];
//            if (startCode==0x0453564A ||startCode==0x0953563A) {
//                
//                if (selectChannel.bmWidth!=width||selectChannel.bmHeight!=height) {
//                    selectChannel.bmWidth=width;
//                    selectChannel.bmHeight=height;
//                    selectChannel.isWaitIFrame=FALSE;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel.iFrameCount=0;
//                    selectChannel.isStandDecoder=FALSE;
//                    selectChannel.changeDecodeFlag=1;
//                    if (selectChannel.openDecoderFlag) {
//                        selectChannel.openDecoderFlag=FALSE;
//                        while (TRUE) {
//                            
//                            if (!selectChannel.UseDecoderFlag) {
//                                
//                                if(!selectChannel.isStandDecoder){
//                                    JVD04_DecodeClose(nLocalChannel-1);
//                                }
//                                break;
//                                
//                            }
//                            usleep(200);
//                        }
//                        selectChannel.changeDecodeFlag=0;
//                    }else{
//                        selectChannel.changeDecodeFlag=0;
//                    }
//                }
//                
//            }else if(0x564a0000==startCode||width>1280||height>720){
//                
//                [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [OperationSet showText:NSLocalizedString(@"Not_720p", nil) andPraent:_operationController andTime:1.0 andYset:120.0];
//                    
//                    
//                });
//                [pool release];
//                return;
//                
//            }else{
//                
//                
//                if (selectChannel.bmWidth!=width||selectChannel.bmHeight!=height) {
//                    
//                    if (startCode==JVN_DSC_960CARD) {
//                        
//                        selectChannel.IsStartCode=YES;
//                    }else{
//                        selectChannel.IsStartCode=NO; ///
//                    }
//                    
//                    if ([_operationController IsFILE_HEADER_EX:pBuffer dwSize:nSize]) {
//                        
//                        selectChannel.IsStartCode=YES;
//                        
//                        
//                    }
//                    
//                    selectChannel.bmWidth=width;
//                    selectChannel.bmHeight=height;
//                    selectChannel.iFrameCount=0;
//                    selectChannel.isStandDecoder=YES;
//                    selectChannel.isWaitIFrame=FALSE;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel.changeDecodeFlag=1;
//                    
//                    if (selectChannel.openDecoderFlag) {
//                        
//                        selectChannel._iWaitICount=WAITIMAXCOUNT;
//                        
//                        selectChannel.openDecoderFlag=FALSE;
//                        while (TRUE) {
//                            
//                            if (!selectChannel.UseDecoderFlag) {
//                                
//                                if(selectChannel.isStandDecoder){
//                                    JVD05_DecodeClose(nLocalChannel-1);
//                                }
//                                break;
//                            }
//                            usleep(200);
//                        }
//                        selectChannel.changeDecodeFlag=0;
//                    }else{
//                        selectChannel.changeDecodeFlag=0;
//                    }
//                    
//                    if (selectChannel.IsLocalVideo) {
//                        
//                        
//                        
//                        [_operationController performSelectorOnMainThread:@selector(operationPlayVideo:) withObject:_bSmallVideoBtn waitUntilDone:YES];
//                        [_operationController performSelectorOnMainThread:@selector(operationPlayVideo:) withObject:_bSmallVideoBtn waitUntilDone:YES];
//                    }
//                    
//                }
//                
//            }
//        }else if(uchType==JVN_DATA_A){
//            
//            //--------------------播放声音方法
//            if (!_operationController._issound) {
//                [pool release];
//                return;
//            }
//            
//            if (selectChannel.connectDeviceType==2||selectChannel.connectDeviceType==3||selectChannel.connectDeviceType==0) {
//                
//                if(selectChannel.IsStartCode) {
//                    
//                    unsigned char *audioPcmBuf = NULL;
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf, audioPcmBuf, 320);
//                    
//                    
//                    JAD_DecodeOneFrame(0, pBuffer+21,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf+320, audioPcmBuf, 320);
//                    [_openALBufferSound openAudioFromQueue:(short*)(ppszPCMBuf) dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                }else{
//                    
//                    if (nSize>3) {
//                        
//                        if ([_operationController isKindOfBufInStartCode:pBuffer]) {
//                            
//                            int startCode = 0;
//                            memcpy(&startCode, pBuffer, 4);
//                            
//                            if (startCode==JVN_DSC_9800CARD) {
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:YES];
//                                
//                            }else if(startCode==JVSC951_STARTCOODE){
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                                
//                            }else{
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                            }
//                            
//                        }
//                        
//                        
//                    }
//                    
//                }
//                
//                
//            }else if (selectChannel.connectDeviceType==1){
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    unsigned char *audioPcmBuf = NULL;
//                    
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                    [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                    
//                }else{
//                    
//                    [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                }
//            }else if (selectChannel.connectDeviceType==4){
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    if ([_operationController isKindOfBufInStartCode:pBuffer]) {
//                        
//                        pBuffer=pBuffer+8;
//                    }
//                    unsigned char *audioPcmBuf = NULL;
//                    
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    
//                    memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                    [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                }
//                
//            }
//            
//        }else if(uchType==JVN_RSP_PLAYE||uchType==JVN_RSP_PLAYOVER||uchType==JVN_RSP_PLTIMEOUT){//文件回放失败
//            [channel[nLocalChannel-1] operationZKVideo:JVN_CMD_VIDEO];
//            
//        }
//    }else {
//        
//        if (channel[nLocalChannel-1].tryCount>=TRYCOUNTMAX) {
//            channel[nLocalChannel-1].tryCount++;
//            
//            if (channel[nLocalChannel-1].tryCount>=TRYMAXCOUNT) {
//                channel[nLocalChannel-1].tryCount=-1;
//                [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel]];
//            }
//        }
//    }
//    
//	[pool release];
    
}

#pragma mark 文本回调函数
void textDeliverDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize){
    
    
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    PAC stpacket={0};
//	if(nSize)//nSize有为0的情况，所以有数据才拷贝数据,lck20120301
//	{
//		memset(&stpacket, 0, sizeof(PAC));
//		memcpy(&stpacket, pBuffer, nSize);
//	}
//    
//    switch(uchType)
//    {
//        case JVN_REQ_TEXT:
//            
//            break;
//        case JVN_RSP_TEXTACCEPT:
//            
//            [NSThread detachNewThreadSelector:@selector(requestDeviceRemoteData:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel-1]];
//            break;
//        case JVN_CMD_TEXTSTOP:
//            
//            
//            break;
//        case JVN_RSP_TEXTDATA:
//        {
//            
//            memcpy(&stpacket, pBuffer, nSize);
//            UInt32 n=0;
//            memcpy(&n, stpacket.acData, 4);
//            
//            
//            char name[32], para[128], *P = stpacket.acData+n;
//            
//            
//            
//            if (stpacket.nPacketType==5) {
//                
//                switch (stpacket.nPacketID) {
//                        
//                    case 2:{
//                        P = stpacket.acData+n;
//                        while (true) {
//                            if(sscanf(P, "%[^=]=%[^;];", name, para))
//                            {
//                                
//                                P = strchr(P, ';');
//                                if(P==NULL)
//                                    break;
//                                NSString *keyName=[NSString stringWithFormat:@"%s",name];
//                                if ([keyName isEqualToString:FRAMEQOS]) {
//                                    
//                                    break;
//                                }
//                                
//                                P++;
//                            }
//                            else
//                                break;
//                        }
//                        
//                        break;
//                        
//                    }
//                        
//                        
//                    default:
//                        break;
//                }
//                
//            }
//            
//            break;
//        }
//        default:
//            break;
//    }
//    [pool release];
//    
    
    
    
}

#pragma mark 连接回调函数
void deliverMessageCallBack(int nLocalChannel, unsigned char  uchType, char *pMsg){
    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    CallBackMsg *_msg=[[CallBackMsg alloc] init];
//    _msg.type=uchType;
//    _msg.channelID=nLocalChannel;
//    
//    if (pMsg==NULL||pMsg==nil) {
//        pMsg="";
//    }
//    
//    _msg.param=[NSData dataWithBytes:pMsg length:strlen(pMsg)];
//    
//    DDLogCVerbose(@"%s---%s",__FUNCTION__,pMsg);
//    
//    [_operationController performSelectorOnMainThread:@selector(refreshManageMessage:) withObject:_msg waitUntilDone:YES];
//    
//    [_msg release];
//    [pool release];
    
}

#pragma mark 语音对讲回调
void remoteChatDataCallBack(int nLocalChannel, unsigned char uchType, unsigned char *pBuffer, int nSize){
    
//    if (1==unAllLinkFlag) {
//        return;
//    }
//    if (nLocalChannel>CONNECTMAXNUMS) {
//        return;
//    }
//    
//    JVChannel *selectChannel= channel[nLocalChannel-1];
//    if (!selectChannel)
//        return;
//	switch(uchType)
//	{
//        case JVN_REQ_CHAT://"收到主控语音请求"
//            //((CJDCSDlg *)g_pMainWnd)->PostMessage(WM_SHOWCHATDLG, JVN_REQ_CHAT,nLocalChannel);
//            printf("");
//            break;
//        case JVN_RSP_CHATACCEPT://"对方接受语音请求"
//            
//            if(_operationController._isTalk){
//                
//                return;
//            }
//            printf("receive remote accept uchtype: %d nSize: %d\n",uchType,nSize);
//            
//            if (_operationController._issound) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    //                    if (_managerVideo.imageViewNums>1) {
//                    //                        _managerVideo._iBigNumbers=_managerVideo.imageViewNums;
//                    //                        _managerVideo.imageViewNums=1;
//                    //                        [_managerVideo changeContenView];
//                    //                    }
//                    
//                    if (!iPhone5) {
//                        
//                        [_operationController unSelectBigButtonStyle:_bSoundBtn];
//                        
//                    }else{
//                        
//                        //                        operationBigView._isPlaySound=FALSE;
//                        //
//                        //                        [operationBigView.tableView reloadData];
//                    }
//                    
//                    
//                });
//                _operationController._issound=FALSE;
//                
//                while (TRUE) {
//                    
//                    if (channel[nLocalChannel]._isUseDecodeSound) {
//                        
//                        if (!channel[nLocalChannel]._isStartingSound) {
//                            
//                            JAD_DecodeClose(0);
//                            channel[nLocalChannel]._isUseDecodeSound = FALSE;
//                            break;
//                        }
//                        usleep(200);
//                        //printf("accept here");
//                    }else{
//                        break;
//                    }
//                }
//                
//                [_openALBufferSound stopSound];
//                [_openALBufferSound cleanUpOpenALMath];
//                [_openALBufferSound initOpenAL];
//                
//                
//            }else{
//                
//                [_openALBufferSound initOpenAL];
//                if (selectChannel.connectDeviceType==1||selectChannel.connectDeviceType==4) {
//                    
//                    if (selectChannel.IsStartCode) {
//                        selectChannel._isUseDecodeSound=TRUE;
//                        JAD_DecodeOpen(0,selectChannel._iAudioType);
//                    }
//                    
//                }else{
//                    
//                    if (selectChannel.IsStartCode) {
//                        selectChannel._isUseDecodeSound=TRUE;
//                        JAD_DecodeOpen(0,1);
//                    }
//                }
//                
//                
//            }
//            [_operationController performSelectorOnMainThread:@selector(selectSmallButtonStyle:) withObject:_bSmallTalkBtn waitUntilDone:NO];
//            _operationController._isTalk=true;
//            
//            if (selectChannel.connectDeviceType==2||selectChannel.connectDeviceType==3||selectChannel.connectDeviceType==0) {
//                
//                [_audioRecordControler record:960 mChannelBit:16];
//                
//            }else if(selectChannel.connectDeviceType==1){
//                
//                if (selectChannel.IsStartCode) {
//                    [_audioRecordControler record:640 mChannelBit:16];
//                }else{
//                    [_audioRecordControler record:320 mChannelBit:8 ];
//                }
//                
//            } else if (4==selectChannel.connectDeviceType) {
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    [_audioRecordControler record:640 mChannelBit:16];
//                }
//                
//            }
//            
//            break;
//        case JVN_CMD_CHATSTOP://"终止语音"
//            
//            if (_operationController._isTalk) {
//                
//                _operationController._isTalk=FALSE;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    
//                    [_operationController unSelectSmallButtonStyle:_bSmallTalkBtn];
//                    
//                    
//                });
//                printf("receive remote stop uchtype: %d nSize: %d\n",uchType,nSize);
//                
//                while (TRUE) {
//                    
//                    if (channel[nLocalChannel]._isUseDecodeSound) {
//                        
//                        if (!channel[nLocalChannel]._isStartingSound) {
//                            
//                            JAD_DecodeClose(0);
//                            channel[nLocalChannel]._isUseDecodeSound = FALSE;
//                            break;
//                        }
//                        usleep(200);
//                    }else{
//                        break;
//                    }
//                }
//                
//                [_openALBufferSound stopSound];
//                [_openALBufferSound cleanUpOpenALMath];
//                
//            }
//            
//            //            else{
//            //
//            //
//            //                 [_operationController performSelectorOnMainThread:@selector(showAlert:) withObject:LOCALANGER(@"PLAY_BACK_OPEN_JVN_CMD_CHATSTOP") waitUntilDone:NO];
//            //
//            //            }
//            
//            break;
//        case JVN_RSP_CHATDATA:
//            
//            if (!_operationController._isTalk) {
//                return;
//            }
//            
//            if (selectChannel.connectDeviceType==2||selectChannel.connectDeviceType==3||selectChannel.connectDeviceType==0) {
//                
//                int outLen;
//                outLen = sizeof(m_cOut);
//                
//                DecodeAudioData(pBuffer+16,nSize-16,m_cOut,&outLen);
//                
//                for (int i=0; i<3; i++) {
//                    
//                    [_openALBufferSound openAudioFromQueue:(short*)(m_cOut+i*320) dataSize:outLen/3 monoValue:YES];
//                }
//                
//            }else if (selectChannel.connectDeviceType==1){
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    unsigned char *audioPcmBuf = NULL;
//                    
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                    [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                }else{
//                    
//                    [_openALBufferSound openAudioFromQueue:(short*)(pBuffer) dataSize:nSize monoValue:NO];
//                }
//            }else if (selectChannel.connectDeviceType==4&&selectChannel.IsStartCode){
//                
//                unsigned char *audioPcmBuf = NULL;
//                selectChannel._isStartingSound=YES;
//                JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                selectChannel._isStartingSound=FALSE;
//            }
//            
//            break;
//        default:
//            break;
//	}
    
}

#pragma mark 远程回放检索回调
void CheckResultCallBack(int nLocalChannel,unsigned char *pBuffer, int nSize){
    
    
//    if (nLocalChannel>CONNECTMAXNUMS) {
//        return;
//    }
//    [[_operationController _playBackVideoDataArray ] removeAllObjects];
//    char *acData  = (char*)malloc(nSize);
//    memcpy(acData, pBuffer, nSize);
//    if (nSize == 0) {
//        free(acData);
//        [_operationController performSelectorOnMainThread:@selector(gotoPlayBackView) withObject:nil waitUntilDone:NO];
//        return;
//    }
//    
//    char acBuff[12] = {0};
//    JVChannel *selectChannel= channel[nLocalChannel-1];
//    
//    if (!selectChannel) {
//        
//        free(acData);
//        return;
//        
//    }else{
//        
//        if (selectChannel.connectDeviceType==0) {
//            
//            for (int i=0; i<=nSize-7; i+=7) {
//                
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                sprintf(acBuff,"%02d",selectChannel.remoteChannel);
//                NSString *str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"remoteChannel"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%c%c:%c%c:%c%c",acData[i+1],acData[i+2],acData[i+3],acData[i+4],acData[i+5],acData[i+6]);
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"date"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%c",acData[i]);
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                
//                [dic setValue:str forKey:@"disk"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                [[_operationController _playBackVideoDataArray ]  addObject:dic];
//                [dic release];
//                
//            }
//            
//            
//        }else if(selectChannel.connectDeviceType == 1 || selectChannel.connectDeviceType == 4){
//            int nIndex = 0;
//            memset(acFLBuffer,0,sizeof(acFLBuffer));
//            for (int i = 0; i<=nSize-10; i+=10) {
//                acFLBuffer[nIndex++] = acData[i];//录像所在盘
//                acFLBuffer[nIndex++] = acData[i+7];//录像类型
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                sprintf(acBuff,"%c%c",acData[i+8],acData[i+9]);//通道号
//                NSString *str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"remoteChannel"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%c%c:%c%c:%c%c",acData[i+1],acData[i+2],acData[i+3],acData[i+4],acData[i+5],acData[i+6]);//日期
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"date"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%s%d","disk",(acData[i]-'C')/10+1);//盘符
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"disk"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                [[_operationController _playBackVideoDataArray ]  addObject:dic];
//                
//                [dic release];
//            }
//        }else if(selectChannel.connectDeviceType == 2 || selectChannel.connectDeviceType == 3){
//            
//            for (int i=0; i<=nSize-7; i+=7) {
//                
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                sprintf(acBuff,"%02d",selectChannel.remoteChannel);
//                NSString *str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"remoteChannel"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%c%c:%c%c:%c%c",acData[i+1],acData[i+2],acData[i+3],acData[i+4],acData[i+5],acData[i+6]);
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"date"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                
//                sprintf(acBuff,"%c",acData[i]);
//                str = [[NSString alloc] initWithUTF8String:acBuff];
//                [dic setValue:str forKey:@"disk"];
//                [str release];
//                memset(acBuff, 0, sizeof(acBuff));
//                [[_operationController _playBackVideoDataArray ]  addObject:dic];
//                [dic release];
//                
//            }
//            
//        }
//    }
//    
//    free(acData);
//    
//    [_operationController performSelectorOnMainThread:@selector(gotoPlayBackView) withObject:nil waitUntilDone:NO];
}


#pragma mark 远程回放
void remotePlayDataCallBack(int nLocalChannel, unsigned char uchType, unsigned char *pBuffer, int nSize, int nWidth, int nHeight, int nTotalFrame){
//    
//    if (1==unAllLinkFlag) {
//        return;
//    }
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    if (nSize>0) {
//        
//        JVChannel *selectChannel= channel[nLocalChannel-1];
//        
//        if (selectChannel==nil) {
//            
//            [pool release];
//            return;
//        }
//        
//        if (uchType==JVN_DATA_I || uchType==JVN_DATA_B || uchType==JVN_DATA_P) {
//            
//            JVS_FRAME_HEADER *jvs_header=(JVS_FRAME_HEADER*)pBuffer;
//            //NSLog(@"type=%d,ch=%d,nlen=%d,bufferSize=%d",uchType,nLocalChannel,nSize,jvs_header->nFrameLens);
//            if (1==selectChannel.changeDecodeFlag||!_isPlayBackVideo) {
//                [pool release];
//                return;
//            }
//            
//            int ver=[[[UIDevice currentDevice] systemVersion] intValue];
//            int startCode = 0;
//            
//			memcpy(&startCode, pBuffer, 4);
//            
//            if (startCode==0x0453564A ||startCode==0x0953564A) {//非准解马流
//                
//                unsigned int i_data =*(unsigned int *)(pBuffer+4);
//                unsigned int uType = i_data & 0xF;
//                if (uType>4) {
//                    [pool release];
//                    return;
//                }
//                unsigned int nLen = (i_data>>4) & 0xFFFFF;
//                //等待i针
//                if (!selectChannel.isWaitIFrame) {
//                    
//                    if (uType==JVN_DATA_I) {
//                        
//                        if (selectChannel.bmPlayVideoWidth>0&&selectChannel.bmPlayVideoHeight>0) {
//                            
//                            selectChannel.isWaitIFrame=TRUE;
//                            JVD04_DecodeOpen(selectChannel.bmPlayVideoWidth ,selectChannel.bmPlayVideoHeight,nLocalChannel-1);
//                            selectChannel.openDecoderFlag=true;
//                            
//                        }else{
//                            
//                            [pool release];
//                            return;
//                        }
//                        
//                    }else{
//                        selectChannel.isWaitIFrame=FALSE;
//                        [pool release];
//                        return;
//                    }
//                }
//                if (!selectChannel.openDecoderFlag) {
//                    
//                    [pool release];
//                    return;
//                }
//                selectChannel.UseDecoderFlag=TRUE;
//                int ret1=JVD04_DecodeOneFrame((unsigned char*)pBuffer+8,imageBuffer[0],nLen, nLocalChannel-1, uType,ver);
//                selectChannel.UseDecoderFlag=FALSE;
//                if (ret1==0) {
//                    
//                    selectChannel.tryCount=0;
//                    NSData *d=[NSData dataWithBytes:imageBuffer[0] length:selectChannel.bmPlayVideoWidth*selectChannel.bmPlayVideoHeight*2+66];
//                    CallBackMsg *m=[[CallBackMsg alloc] init];
//                    m.channelID=nLocalChannel-1;
//                    m.param=d;
//                    [_operationController performSelectorOnMainThread:@selector(refreshImgView:) withObject:m waitUntilDone:YES];
//                    [m release];
//                }else{
//                    
//                    selectChannel.tryCount++;
//                    if (selectChannel.tryCount>=TRYCOUNTMAX) {
//                        selectChannel.changeDecodeFlag=1;
//                        selectChannel.tryCount=0;
//                        selectChannel.isWaitIFrame=FALSE;
//                        if (selectChannel.openDecoderFlag) {
//                            
//                            selectChannel.openDecoderFlag=FALSE;
//                            while (TRUE) {
//                                
//                                if (!selectChannel.UseDecoderFlag) {
//                                    
//                                    if(selectChannel.isStandDecoder){
//                                        JVD05_DecodeClose(nLocalChannel-1);
//                                    }
//                                    break;
//                                    
//                                }
//                                usleep(200);
//                            }
//                        }
//                        selectChannel.tryCount=222;
//                        CallBackMsg *m=[[CallBackMsg alloc] init];
//                        m.channelID=nLocalChannel-1;
//                        [_operationController performSelectorOnMainThread:@selector(disConnectSocket:) withObject:m waitUntilDone:YES];
//                        [m release];
//                    }
//                    [pool release];
//                    return;
//                    
//                    
//                }
//                
//            }else{
//                
//                if (!selectChannel.openDecoderFlag) {
//                    
//                    if (selectChannel.bmPlayVideoWidth>0&&selectChannel.bmPlayVideoHeight>0) {
//                        
//                        memset(imageBufferY[0], 0, sizeof(imageBufferY[0]));
//                        memset(imageBufferU[0], 0, sizeof(imageBufferU[0]));
//                        memset(imageBufferV[0], 0, sizeof(imageBufferV[0]));
//                        JVD05_DecodeOpen(nLocalChannel-1);
//                        selectChannel.openDecoderFlag=TRUE;
//                    }
//                }
//                if (!selectChannel.openDecoderFlag) {
//                    [pool release];
//                    return;
//                }
//                int  ret=-1;
//                
//                if (selectChannel.IsStartCode) {
//                    
//                    if (!selectChannel.isWaitIFrame) {
//                        
//                        if (uchType==JVN_DATA_I) {
//                            
//                            selectChannel.isWaitIFrame=TRUE;
//                            
//                        }else{
//                            
//                            selectChannel.isWaitIFrame=FALSE;
//                            selectChannel.UseDecoderFlag=FALSE;
//                            [pool release];
//                            return;
//                        }
//                    }
//                    
//                    if (selectChannel.IsLocalVideo) {
//                        
//                        if (!selectChannel.isLocalVideoWaitIFrame) {
//                            
//                            if (uchType==JVN_DATA_I) {
//                                
//                                selectChannel.isLocalVideoWaitIFrame=TRUE;
//                                JP_PackageOneFrame((unsigned char*)pBuffer, nSize, nLocalChannel-1);
//                                
//                            }
//                            
//                        }else{
//                            
//                            if (uchType!=JVN_DATA_B) {
//                                
//                                JP_PackageOneFrame((unsigned char*)pBuffer, nSize, nLocalChannel-1);
//                            }else{
//                                int tempSize = nSize;
//                                unsigned char pp[tempSize];
//                                memset(pp, 0, tempSize);
//                                JP_PackageOneFrame(pp ,nSize, nLocalChannel-1,0,0);
//                            }
//                        }
//                        
//                    }
//                    
//                    selectChannel.UseDecoderFlag=TRUE;
//                    
//                    ret = JVD05_DecodeOneFrame(nLocalChannel-1,nSize,pBuffer,imageBufferY[0],imageBufferU[0],imageBufferV[0],0,ver,0);
//                    if (channel[nLocalChannel-1]._iCapturePic) {
//                        
//                        yuv_rgb(nLocalChannel-1,(unsigned int*)(capImageBuffer[0]+66),ver);
//                        CreateBitmap((unsigned char *)capImageBuffer[0],channel[nLocalChannel-1].bmPlayVideoWidth,channel[nLocalChannel-1].bmPlayVideoHeight,ver);
//                        NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[nLocalChannel-1].bmPlayVideoWidth*channel[nLocalChannel-1].bmPlayVideoHeight*2+66];
//                        channel[nLocalChannel-1].ImageData=d;
//                        [_operationController performSelectorOnMainThread:@selector(saveLocalChannelPhoto) withObject:nil waitUntilDone:NO];
//                        
//                    }
//                    
//                    selectChannel.UseDecoderFlag=FALSE;
//                }
//                else{
//                    
//                    JVS_FRAME_HEADER *jvs_header=(JVS_FRAME_HEADER*)pBuffer;
//                    if (!selectChannel.isWaitIFrame) {
//                        
//                        if (jvs_header->nFrameType==JVN_DATA_I) {
//                            
//                            selectChannel.isWaitIFrame=TRUE;
//                        }else{
//                            selectChannel.UseDecoderFlag=FALSE;
//                            selectChannel.isWaitIFrame=FALSE;
//                            [pool release];
//                            return;
//                        }
//                    }
//                    
//                    if (selectChannel.IsLocalVideo) {
//                        
//                        if (!selectChannel.isLocalVideoWaitIFrame) {
//                            
//                            if (jvs_header->nFrameType==JVN_DATA_I) {
//                                
//                                selectChannel.isLocalVideoWaitIFrame=TRUE;
//                                
//                                JP_PackageOneFrame((unsigned char*)pBuffer+8, jvs_header->nFrameLens, nLocalChannel-1);
//                            }
//                            
//                        }else{
//                            
//                            if (jvs_header->nFrameType!=JVN_DATA_B) {
//                                
//                                JP_PackageOneFrame((unsigned char*)pBuffer+8, jvs_header->nFrameLens, nLocalChannel-1);
//                                
//                            }else{
//                                
//                                int tempSize = nSize;
//                                unsigned char pp[tempSize];
//                                memset(pp, 0, tempSize);
//                                JP_PackageOneFrame(pp ,nSize, nLocalChannel - 1,0,0);
//                                
//                                
//                            }
//                        }
//                        
//                    }
//                    
//                    selectChannel.UseDecoderFlag=TRUE;
//                    
//                    ret = JVD05_DecodeOneFrame(nLocalChannel-1,jvs_header->nFrameLens,pBuffer+8,imageBufferY[0],imageBufferU[0],imageBufferV[0],0,ver,0);
//                    if (channel[nLocalChannel-1]._iCapturePic) {
//                        
//                        yuv_rgb(nLocalChannel-1,(unsigned int*)(capImageBuffer[0]+66),ver);
//                        CreateBitmap((unsigned char *)capImageBuffer[0],channel[nLocalChannel-1].bmPlayVideoWidth,channel[nLocalChannel-1].bmPlayVideoHeight,ver);
//                        NSData *d=[NSData dataWithBytes:capImageBuffer[0] length:channel[nLocalChannel-1].bmPlayVideoWidth*channel[nLocalChannel-1].bmPlayVideoHeight*2+66];
//                        channel[nLocalChannel-1].ImageData=d;
//                        [_operationController performSelectorOnMainThread:@selector(saveLocalChannelPhoto) withObject:nil waitUntilDone:NO];
//                        
//                    }
//                    
//                    selectChannel.UseDecoderFlag=FALSE;
//                }
//                if (ret==0) {
//                    selectChannel.tryCount=0;
//                    
//                    CallBackMsg *m=[[CallBackMsg alloc] init];
//                    m.channelID=nLocalChannel-1;
//                    
//                    
//                    [_operationController performSelectorOnMainThread:@selector(openglPlayBackRefresh:) withObject:m waitUntilDone:YES];
//                    [m release];
//                    
//                }else{
//                    
//                    selectChannel.tryCount++;
//                    if (selectChannel.tryCount>=TRYCOUNTMAX) {
//                        selectChannel.changeDecodeFlag=1;
//                        selectChannel.tryCount=0;
//                        selectChannel.isWaitIFrame=FALSE;
//                        if (selectChannel.openDecoderFlag) {
//                            
//                            selectChannel.openDecoderFlag=FALSE;
//                            while (TRUE) {
//                                
//                                if (!selectChannel.UseDecoderFlag) {
//                                    
//                                    if(selectChannel.isStandDecoder){
//                                        JVD05_DecodeClose(nLocalChannel-1);
//                                    }
//                                    break;
//                                    
//                                }
//                                usleep(200);
//                            }
//                        }
//                        selectChannel.tryCount=222;
//                        [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel]];
//                    }
//                    
//                    
//                }
//                
//            }
//			
//        } else if(uchType==JVN_DATA_O){
//            
//            int width = 0;
//            int height = 0;
//            int startCode=0;
//            
//            
//            //判断新头
//            if([_operationController IsFILE_HEADER_EX:pBuffer dwSize:nSize]){
//                
//                
//                
//                memcpy(&startCode, pBuffer+2, 4);
//                memcpy(&width, pBuffer+6, 4);
//                memcpy(&height, pBuffer+10, 4);
//                JVS_FILE_HEADER_EX *fileHeader;
//                
//                fileHeader = malloc(sizeof(JVS_FILE_HEADER_EX));
//                memset(fileHeader, 0, sizeof(JVS_FILE_HEADER_EX));
//                memcpy(fileHeader, pBuffer+2, sizeof(JVS_FILE_HEADER_EX));
//                selectChannel._iplayBackFrametotalNumber=fileHeader->dwRecFileTotalFrames;
//                selectChannel._dPlayBackVideoframeFrate = ((double)fileHeader->wFrameRateNum)/((double)fileHeader->wFrameRateDen);
//                
//                free(fileHeader);
//                
//            }else{
//                JVS_FILE_HEADER header;
//                JVS_FILE_HEADER jHeader;
//                
//                if ((*(unsigned int*)pBuffer&0xFFFFFF)!=0x53564a) {
//                    
//                    memcpy(&jHeader.width, pBuffer, sizeof(int));
//                    memcpy(&jHeader.height, pBuffer+4, sizeof(int));
//                    
//                    if (nSize>=12) {
//                        
//                        memcpy(&jHeader.dwToatlFrames, pBuffer+8, sizeof(int));
//                        
//                    }else{
//                        jHeader.dwToatlFrames = 0;//总针数
//                    }
//                    
//                    pBuffer = (unsigned char *)&jHeader;
//                }
//                
//                
//                memcpy(&header, pBuffer, sizeof(JVS_FILE_HEADER));
//                width=header.width;
//                height=header.height;
//                selectChannel._iplayBackFrametotalNumber=header.dwToatlFrames;
//                
//            }
//            
//            
//            startCode=selectChannel.connectStartCode;
//            
//            [_operationController stopSetting:nLocalChannel-1];
//            _isPlayBackVideo=TRUE;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [_operationController showPlayBackVideo:_isPlayBackVideo];
//                
//            });
//            
//            CallBackMsg *m=[[CallBackMsg alloc] init];
//            m.channelID=nLocalChannel-1;
//            m.type=selectChannel._iplayBackFrametotalNumber;
//            [_operationController performSelectorOnMainThread:@selector(refreshPlayBackVideo:) withObject:m waitUntilDone:YES];
//            [m release];
//            
//            
//            if (startCode==0x0453564A ||startCode==0x0953564A) {
//                
//                if (selectChannel.bmPlayVideoWidth!=width||selectChannel.bmPlayVideoHeight!=height) {
//                    
//                    selectChannel.bmPlayVideoWidth=width;
//                    selectChannel.bmPlayVideoHeight=height;
//                    selectChannel.isWaitIFrame=FALSE;
//                    selectChannel.iFrameCount=0;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel.isStandDecoder=FALSE;
//                    selectChannel.changeDecodeFlag=1;
//                    selectChannel._iWaitICountPic=1;
//                    selectChannel._iWaitICount=1;
//                    
//                    if (selectChannel.openDecoderFlag) {
//                        
//                        selectChannel.openDecoderFlag=FALSE;
//                        
//                        while (TRUE) {
//                            
//                            if (!selectChannel.UseDecoderFlag) {
//                                
//                                if(!selectChannel.isStandDecoder){
//                                    JVD04_DecodeClose(nLocalChannel-1);
//                                }
//                                break;
//                                
//                            }
//                            
//                            usleep(200);
//                        }
//                        selectChannel.changeDecodeFlag=0;
//                    }else{
//                        selectChannel.changeDecodeFlag=0;
//                    }
//                }else{
//                    selectChannel.isWaitIFrame = FALSE;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel._iWaitICountPic=1;
//                    selectChannel._iWaitICount=1;
//                }
//            }else if(0x564a0000==startCode||width>1280||height>720){
//                
//                _isPlayBackVideo=FALSE;
//                JVChannel *selectChannel= channel[nLocalChannel-1];
//                
//                if (selectChannel!=nil) {
//                    
//                    if (selectChannel.openDecoderFlag) {
//                        
//                        while (TRUE) {
//                            
//                            if (!selectChannel.UseDecoderFlag) {
//                                
//                                if(!selectChannel.isStandDecoder){
//                                    
//                                    JVD04_DecodeClose(nLocalChannel-1);
//                                    JVD04_DecodeOpen(selectChannel.bmPlayVideoWidth ,selectChannel.bmPlayVideoHeight,nLocalChannel-1);
//                                    
//                                }else{
//                                    
//                                    JVD05_DecodeClose(nLocalChannel-1);
//                                    JVD05_DecodeOpen(nLocalChannel-1);
//                                    
//                                    
//                                }
//                                //memset(imageBuffer[0], 0, sizeof(imageBuffer[0])) ;
//                                break;
//                            }
//                            usleep(200);
//                        }
//                    }
//                    
//                    
//                }
//                
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [_operationController showPlayBackVideo:_isPlayBackVideo];
//                    [OperationSet showText:NSLocalizedString(@"Not_720p", nil) andPraent:_operationController andTime:1 andYset:60];
//                    
//                    
//                    
//                });
//                
//                if(_operationController._isLocalVideo){
//                    
//                    [_operationController operationPlayVideo:_bSmallVideoBtn];
//                    
//                }
//                selectChannel.isWaitIFrame=FALSE;
//                selectChannel.isLocalVideoWaitIFrame=FALSE;
//                selectChannel._iWaitICount=1;
//                selectChannel._iWaitICountPic=1;
//                
//                [channel[nLocalChannel-1] operationZKVideo:JVN_CMD_VIDEO];
//                
//                [pool release];
//                return;
//                
//            }else{
//                
//                if (selectChannel.bmPlayVideoWidth!=width||selectChannel.bmPlayVideoHeight!=height) {
//                    // printf("run here------------\n");
//                    selectChannel.bmPlayVideoWidth=width;
//                    selectChannel.bmPlayVideoHeight=height;
//                    selectChannel.iFrameCount=0;
//                    selectChannel.isStandDecoder=YES;
//                    selectChannel.isWaitIFrame=FALSE;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel.changeDecodeFlag=1;
//                    selectChannel._iWaitICount=1;
//                    selectChannel._iWaitICountPic=1;
//                    if (selectChannel.openDecoderFlag) {
//                        
//                        selectChannel.openDecoderFlag=FALSE;
//                        while (TRUE) {
//                            
//                            if (!selectChannel.UseDecoderFlag) {
//                                
//                                if(selectChannel.isStandDecoder){
//                                    JVD05_DecodeClose(nLocalChannel-1);
//                                }
//                                break;
//                            }
//                            usleep(200);
//                        }
//                        selectChannel.changeDecodeFlag=0;
//                    }else{
//                        
//                        selectChannel.changeDecodeFlag=0;
//                    }
//                }else{
//                    selectChannel.isWaitIFrame = FALSE;
//                    selectChannel.isLocalVideoWaitIFrame=FALSE;
//                    selectChannel._iWaitICount=1;
//                    selectChannel._iWaitICountPic=1;
//                }
//                
//            }
//        }else if(uchType==JVN_DATA_A){
//            
//            //--------------------播放声音方法
//            if (TRUE) {
//                [pool release];
//                return;
//            }
//            
//            if (selectChannel.connectDeviceType==2||selectChannel.connectDeviceType==3||selectChannel.connectDeviceType==0) {
//                
//                if(selectChannel.IsStartCode) {
//                    
//                    unsigned char *audioPcmBuf = NULL;
//                    
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf, audioPcmBuf, 320);
//                    
//                    
//                    JAD_DecodeOneFrame(0, pBuffer+21,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf+320, audioPcmBuf, 320);
//                    [_openALBufferSound openAudioFromQueue:(short*)(ppszPCMBuf) dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                }else{
//                    
//                    if (nSize>3) {
//                        
//                        if ([_operationController isKindOfBufInStartCode:(char*)pBuffer]) {
//                            
//                            int startCode = 0;
//                            memcpy(&startCode, pBuffer, 4);
//                            
//                            if (startCode==JVN_DSC_9800CARD) {
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:YES];
//                                
//                            }else if(startCode==JVSC951_STARTCOODE){
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                                
//                            }else{
//                                
//                                [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                            }
//                            
//                        }
//                    }
//                    
//                }
//            }else if (selectChannel.connectDeviceType==1){
//                if (selectChannel.IsStartCode) {
//                    
//                    unsigned char *audioPcmBuf = NULL;
//                    selectChannel._isStartingSound=YES;
//                    JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                    memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                    [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                    selectChannel._isStartingSound=FALSE;
//                    
//                }else{
//                    
//                    [_openALBufferSound openAudioFromQueue:(short*)(pBuffer+8) dataSize:nSize-8 monoValue:NO];
//                }
//                
//            }else if (selectChannel.connectDeviceType==4&&selectChannel.IsStartCode){
//                
//                unsigned char *audioPcmBuf = NULL;
//                selectChannel._isStartingSound=YES;
//                JAD_DecodeOneFrame(0, pBuffer,  &audioPcmBuf);
//                memcpy(ppszPCMBuf, audioPcmBuf, 640);
//                [_openALBufferSound openAudioFromQueue:(short*)ppszPCMBuf dataSize:640 monoValue:YES];
//                selectChannel._isStartingSound=FALSE;
//            }
//            
//        }
//    }else if(nSize==0&&(uchType==JVN_RSP_PLAYE||uchType==JVN_RSP_PLAYOVER||uchType==JVN_RSP_PLTIMEOUT)){//文件回放失败
//        _isPlayBackVideo=FALSE;
//        JVChannel *selectChannel= channel[nLocalChannel-1];
//        
//        if (selectChannel!=nil) {
//            
//            if (selectChannel.openDecoderFlag) {
//                
//                while (TRUE) {
//                    
//                    if (!selectChannel.UseDecoderFlag) {
//                        
//                        if(!selectChannel.isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel-1);
//                            JVD04_DecodeOpen(selectChannel.bmPlayVideoWidth ,selectChannel.bmPlayVideoHeight,nLocalChannel-1);
//                            
//                        }else{
//                            
//                            JVD05_DecodeClose(nLocalChannel-1);
//                            JVD05_DecodeOpen(nLocalChannel-1);
//                            
//                            
//                        }
//                        //memset(imageBuffer[0], 0, sizeof(imageBuffer[0])) ;
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            
//            
//        }
//        
//        
//        [_operationController performSelectorOnMainThread:@selector(showPlayBackVideoDisplay) withObject:nil waitUntilDone:nil];
//        
//        if(_operationController._isLocalVideo){
//            
//            
//            [_operationController performSelectorOnMainThread:@selector(operationPlayVideo:) withObject:_bSmallVideoBtn waitUntilDone:nil];
//            //[_operationController operationPlayVideo:_bSmallVideoBtn];
//            
//        }
//        
//        
//        
//        selectChannel.isWaitIFrame=FALSE;
//        selectChannel.isLocalVideoWaitIFrame=FALSE;
//        selectChannel._iWaitICount=1;
//        selectChannel._iCapturePic=false;
//        [channel[nLocalChannel-1] operationZKVideo:JVN_CMD_VIDEO];
//        
//        
//    }else {
//        if (channel[nLocalChannel-1].tryCount>=TRYCOUNTMAX) {
//            channel[nLocalChannel-1].tryCount++;
//            if (channel[nLocalChannel-1].tryCount>=TRYMAXCOUNT) {
//                channel[nLocalChannel-1].tryCount=-1;
//                [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:_operationController withObject:[NSString stringWithFormat:@"%d",nLocalChannel]];
//                
//            }
//        }
//    }
//	[pool release];
    
}


-(void)showPlayBackVideoDisplay{
    
    
    
    [self showPlayBackVideo:_isPlayBackVideo];
    
    
}
#pragma mark 前往远程播放界面
-(void)gotoPlayBackView{
    
//    if (!self._isPlayBack) {
//        
//        _remoteVideoPlayBackVControler=[[RemoteVideoPlayBackVControler alloc] initWithNibName:@"RemoteVideoPlayBackVControler" bundle:nil];
//        [_remoteVideoPlayBackVControler.nultArray addObjectsFromArray:_playBackVideoDataArray];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionReveal;
//        transition.subtype = kCATransitionFromTop;
//        transition.delegate = self;
//        self._isPlayBack=true;
//        _remoteVideoPlayBackVControler._operationController=self;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController pushViewController:_remoteVideoPlayBackVControler animated:NO];
//        [_remoteVideoPlayBackVControler release];
//        
//        
//    }else{
//        
//        [_remoteVideoPlayBackVControler.nultArray removeAllObjects];
//        [_remoteVideoPlayBackVControler.nultArray addObjectsFromArray:_playBackVideoDataArray];
//        _remoteVideoPlayBackVControler._isSendState=NO;
//        [_remoteVideoPlayBackVControler.myTable reloadData];
//        
//        if([_remoteVideoPlayBackVControler.nultArray count]<=0){
//            
//            [OperationSet showText:NSLocalizedString(@"No_video_file_found", nil) andPraent:_remoteVideoPlayBackVControler andTime:1 andYset:60];
//            
//        }
//    }
}

#pragma mark ---------图片刷新方法
-(void) refreshPlayBackVideo:(id)sender{
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
//    [imgView playBackVideoNumber:callBackMsg.type];
//    [pool release];
    
    
}

-(void)changeBtnState:(NSTimer*)timer{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_bSmallTalkBtn setEnabled:YES];
    });
    [timer invalidate];
}

#pragma mark 远程回放界面操作 NO关闭 YES是开启

- (void)showPlayBackVideo:(bool)_isOpen{
    
    if (_isOpen) {
        
        if (_managerVideo.imageViewNums>1) {
            _managerVideo._iBigNumbers=_managerVideo.imageViewNums;
            _managerVideo.imageViewNums=1;
            [_managerVideo changeContenView];
        }
        [_splitViewBgClick setHidden:YES];
        [_splitViewBtn setHidden:YES];
        self.navigationItem.title=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Play back", nil)];
        _managerVideo.WheelShowListView.scrollEnabled=NO;
        [_bYTOBtn setEnabled:NO];
        [_bSoundBtn setEnabled:NO];
        CATransition *transition = [CATransition animation];
        transition.duration = 1.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        
        
    }else{
        [_splitViewBgClick setHidden:NO];
        [_splitViewBtn setHidden:NO];
        _managerVideo.WheelShowListView.scrollEnabled=YES;
        //NSLog(@"seleleindex=%d",self._iSelectedChannelIndex);
        self.navigationItem.title=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Video Display", nil)];
        [_bYTOBtn setEnabled:YES];
        [_bSoundBtn setEnabled:YES];
        CATransition *transition = [CATransition animation];
        transition.duration = 1.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        JVCCustomOperationBottomView  *_singView=(JVCCustomOperationBottomView*)[self.view viewWithTag:WINDOWSFLAG+self._iSelectedChannelIndex];
        [_singView hiddenSlider];
    }
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


#pragma mark 判断是否带针头
-(BOOL)isKindOfBufInStartCode:(char*)buffer{
    
    uint8_t *pacBuffer = (uint8_t*)buffer;
    
	if(buffer == NULL )
	{
		return FALSE;
	}
	return pacBuffer[0] == 'J' && pacBuffer[1] == 'V' && pacBuffer[2] == 'S';
}


#pragma mark 判断设备是新的的还是旧的 新的返回TRUE
-(bool)IsFILE_HEADER_EX:(void *)pBuffer dwSize:(uint32_t)dwSize
{
	uint8_t *pacBuffer = (uint8_t*)pBuffer+2;
    
	if(pBuffer == NULL || dwSize < sizeof(JVS_FILE_HEADER_EX))
	{
		return FALSE;
	}
    
	return pacBuffer[32] == 'J' && pacBuffer[33] == 'F' && pacBuffer[34] == 'H';
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
    if (isShowHelper) {
//        [_helpImageView RemoveHelper];
    }
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



-(void) refreshManageMessage:(id)sender{
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    CallBackMsg *_msg = (CallBackMsg *)sender;
//    int uchType =_msg.type;
//    int nLocalChannel =_msg.channelID-1;
//    NSString *returnConnectInfo=[[NSString alloc] initWithData:(NSData*)_msg.param encoding:NSUTF8StringEncoding];
//    
//    int _ID=channel[nLocalChannel].flag*CONNECTMAXNUMS;
//    int channelID=nLocalChannel+_ID+WINDOWSFLAG;
//    monitorConnectionSingleImageView *imgView=(monitorConnectionSingleImageView*)[self.view viewWithTag:channelID];
//    
//    if (uchType!=1) {
//        
//        if (_isPlayBackVideo) {
//            
//            _isPlayBackVideo=FALSE;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [_operationController showPlayBackVideo:_isPlayBackVideo];
//                
//            });
//        }
//        
//        [self stopSetting:nLocalChannel];
//        
//    }
//    
//    if (channel[nLocalChannel]==nil||channel[nLocalChannel]==nil) {
//        
//        if (1==uchType) {
//            
//            [NSThread detachNewThreadSelector:@selector(disConnectChannel:) toTarget:self withObject:[NSString stringWithFormat:@"%d",nLocalChannel+1]];
//        }
//        [returnConnectInfo release];
//        [pool release];
//        return;
//        
//    }
//	channel[nLocalChannel].connectState=1;
//    
//    if (uchType!=1) {
//        
//        [channel[nLocalChannel] stopTimer];
//        
//        if(!channel[nLocalChannel].isPPConnectStatus){
//            
//            [channel[nLocalChannel] stopConnectPPSTimer];
//            
//        }
//    }
//    if (uchType==1) {
//        
//        if (channel[nLocalChannel]!=nil||channel[nLocalChannel]!=NULL) {
//            
//            if ([returnConnectInfo.uppercaseString isEqualToString:CONNECTTURNFLAG.uppercaseString]) {
//                
//                channel[nLocalChannel].isPPConnectStatus=FALSE;
//                [channel[nLocalChannel] startConnectPPSTimer];
//                
//            }else{
//                
//                channel[nLocalChannel].isPPConnectStatus=TRUE;
//                
//            }
//            
//            
//        }
//        
//    }else if(uchType==2){//断开连接成功
//        
//        //NSLog(@"right %@",@"unalllink连接成功");
//        if(channel[nLocalChannel]!=nil) {
//            
//            
//            if (999==channel[nLocalChannel].tryCount) {
//                
//                [channel[nLocalChannel] ppConncetByYST];
//                [returnConnectInfo release];
//                [pool release];
//                return;
//                
//            }
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            
//            
//            if (222==channel[nLocalChannel].tryCount) {
//                
//                [imgView stopActivity:NSLocalizedString(@"Connection Failed", nil)];
//                
//            }else{
//                [imgView stopActivity:@""];
//                
//            }
//            
//            [imgView setImage:nil];
//            if ( 0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//            
//        }
//		
//    }else if(uchType==3){//不必要重复连接
//        
//		
//    }else if(uchType==4){//连接失败
//        
//#pragma mark  修改的地方
//        // NSLog(@"returnConnectInfo=%@",returnConnectInfo);
//        
//        if ([returnConnectInfo isEqualToString:@"password is wrong!"]) {
//            
//            [imgView stopActivity:NSLocalizedString(@"Connection Failed ID", nil)];
//            
//            iModifyIndex = channel[nLocalChannel]._iSelectSourceModelIndexValue;
//            
//            [_operationController  performSelectorOnMainThread:@selector(showAlertWithUserOrPassWordError) withObject:nil waitUntilDone:NO];
//            
//        }else if([returnConnectInfo isEqualToString:@"client count limit!"])
//        {
//            [imgView stopActivity:NSLocalizedString(@"client count limit", nil)];
//        }else{
//            
//            [imgView stopActivity:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Connection Failed", nil)]];
//        }
//        
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if (0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        //NSLog(@"right 连接失败222");
//		
//    }else if(uchType==5){//没有连接
//		
//    }else if(uchType==6){//连接异常断开
//        [imgView stopActivity:NSLocalizedString(@"Disconnected Due To Abnormal Network", nil)];
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if ( 0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        
//    }else if(uchType==7){//服务停止，连接断开
//        
//        [imgView stopActivity:NSLocalizedString(@"Disconnected Due To CloudSEE Service Has Been Stopped", nil)];
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if ( 0  ==  channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        
//		
//    }else if(uchType==8){//断开连接失败
//        
//		[imgView stopActivity:NSLocalizedString(@"Connection Failed", nil)];
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if ( 0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        
//    }else if(uchType==9){//云视通服务已停止
//        [imgView stopActivity:NSLocalizedString(@"CloudSEE Service Has Been Stopped", nil)];
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if ( 0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        
//        
//		//NSLog(@"right 云视通服务已停止");
//    }else{
//		[imgView stopActivity:NSLocalizedString(@"Connection Failed",nil)];
//        
//        if (channel[nLocalChannel]!=nil) {
//            
//            if (channel[nLocalChannel].openDecoderFlag) {
//                
//                while (TRUE) {
//                    if (!channel[nLocalChannel].UseDecoderFlag) {
//                        
//                        if(!channel[nLocalChannel].isStandDecoder){
//                            
//                            JVD04_DecodeClose(nLocalChannel);
//                            
//                            
//                        }else{
//                            JVD05_DecodeClose(nLocalChannel);
//                            if (channel[nLocalChannel].connectDeviceType!=1) {
//                                [imgView setImageBuffer:(char*)imageBufferY[0] imageBufferU:(char*)imageBufferU[0] imageBufferV:(char*)imageBufferV[0] decoderFrameWidth:0 decoderFrameHeight:0];
//                            }
//                            
//                        }
//                        
//                        break;
//                    }
//                    usleep(200);
//                }
//            }
//            [imgView setImage:nil];
//            if ( 0 == channel[nLocalChannel]._isUpLoadImageState ) {
//                
//                [channel[nLocalChannel] release];
//                channel[nLocalChannel]=nil;
//            }
//        }
//        // NSLog(@"right 云视通服务已停1");
//    }
//    [returnConnectInfo release];
//    [pool release];
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




