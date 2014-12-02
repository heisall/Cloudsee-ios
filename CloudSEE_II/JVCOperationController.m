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
#import "JVCCustomYTOView.h"
#import "JVCDeviceSourceHelper.h"
#import "JVNetConst.h"
#import "GlView.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "JVCRemoteVideoPlayBackVControler.h"
#import "JVCChannelScourseHelper.h"
#import "JVCAlarmCurrentView.h"
#import "JVCHorizontalScreenBar.h"
#import "JVCHorizontalStreamView.h"
#import "JVCControlHelper.h"
#import "JVCCustomOperationBottomView.h"
#import "JVCOperationModifyViewController.h"
#import "JVCConfigModel.h"
#import "JVCLocaOperationModifyViewController.h"
#import "JVCTencentHelp.h"
#import "JVCYTOperaitonView.h"
#include "JVCConstansALAssetsMathHelper.h"
#import "JVCMediaMacro.h"
#import "JVCAlarmManagerHelper.h"

#import "JVCOperaDeviceConnectManagerTableViewController.h"
#import "JVCOperaOldDeviceConnectAlarmViewController.h"

static const int            STARTHEIGHTITEM         =  40;
static const NSString      *kRecoedVideoFileName    = @"LocalValue";                       //保存录像的本地路径文件夹名称
static const NSString      *kRecoedVideoFileFormat  = @".mp4";                             //保存录像的单个文件后缀

static const CGFloat         kTalkViewWithHeight     = 60.0f;
static const CGFloat         kTalkViewWithWidth      = 200.0;
static const int             kAlertTag               = 19384324;
static const NSTimeInterval  kRemoteBackTimer        = 0.3;//远程回放延迟
static const NSTimeInterval  kTalkDelayTimer         = 2.0f;//远程回放延迟

static const int  kBarios6                           = 20.0f;//远程回放延迟

//static const int WINDOWSFLAG  = WINDOWSFLAG;//tag

bool selectState_sound ; // yes  选中   no：没有选中
bool selectState_talk ;
bool selectState_audio ;

@interface JVCOperationController ()
{
    
    int                      iModifyIndex;               //当用户名密码错误时，要跳转到修个用户名。密码界面，此变量用于获取相应的index
    JVCCustomOperationBottomView *_operationItemSmallBg;
    NSString                *_strSaveVideoPath;          // 保存本地相册的path
    JVCOperationMiddleViewIphone5 *operationBigView;     //音频监听、云台、远程回调的中间view
    JVCCustomCoverView      *_splitViewCon;              // 遮罩的view
    JVCYTOperaitonView      *ytOperationView;            //播放界面显示云台操作的view
    int                      nCurrentStreamType;
    BOOL                     isCurrentHomePC;
    int                      nStorageType;
    UIView                  *talkView;
    BOOL                     isLongPressedStartTalk;    //判断当前是否在长按语音对讲
    UIButton                *_splitViewBtn;             //导航条上面的箭头，用于选则是否分屏
    JVCHorizontalStreamView *horizonView;
    JVCPopStreamView        *straemView;
    JVCOperationMiddleView  *_operationBigItemBg;       //中间部分的问题
    UIView                  *_splitViewBgClick;
    int                      unAllLinkFlag;
    AVAudioPlayer           *_play;
    UIButton                *_bSmallVideoBtn;
    UIButton                *_bSoundBtn;
    UIButton                *_bYTOBtn;
    UIButton                *_bSmallCaptureBtn;
    UIImageView             *capImageView;
    bool                     _isPlayBackVideo;
    bool                     _isCapState;
    
    NSData                  *saveImageDate; //保存图片的二进制文件
    NSTimer                 *talkTimer;
    
    UIInterfaceOrientation  originInterface; //旋转之前的方面
}

enum StorageType {
    
    StorageType_alarm = 2,
    StorageType_auto  = 1,
};

enum DISCONNECT_STATUS {

    DISCONNECT_CONNECT = 0,
    DISCONNECT_ALL = 1,

};

@end

@implementation JVCOperationController
@synthesize _iSelectedChannelIndex,strSelectedDeviceYstNumber;
@synthesize _isLocalVideo,_isPlayBack;
@synthesize _playBackVideoDataArray,_playBackDateString;
@synthesize showSingeleDeviceLongTap;
@synthesize delegate;
@synthesize isPlayBackVideo,strPlayBackVideoPath;
@synthesize isConnectAll;

static const CGFloat  kRightButtonViewWithHeight      = 38.0f ;
static const CGFloat  kRightButtonViewWithWidth       = 80.0f ;
static const CGFloat  kRightButtonViewWithTitleFont   = 8.0f ; //右侧报警录像和手动录像 标题lab的字体间距
static const CGFloat  kRightButtonViewWithTitleHeight = 16.0f ; //右侧报警录像和手动录像 标题lab的字体间距

char remoteSendSearchFileBuffer[29] = {0};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

-(void)dealloc{
    
    [straemView release];

    [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = NO;
    
    if (isPlayBackVideo) {
        
         [strPlayBackVideoPath release];
    }
   
    [_strSaveVideoPath release];
    [strSelectedDeviceYstNumber release];
    
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
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_splitViewBtn setHidden:YES];
    [_splitViewCon setHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_isPlayBackVideo && !self.isPlayBackVideo) {
        /**
         *  获取当前设备的通道数组，一个不让显示
         */
        int channelListCount = [_managerVideo channelCountAtSelectedYstNumber];
        
        if (channelListCount <= showWindowNumberType_One) {
            
            [_splitViewBtn setHidden:YES];
            [_splitViewCon setHidden:YES];
            
        }else{
            
            [_splitViewBtn setHidden:NO];
            [_splitViewCon setHidden:NO];
            
        }
        
        if (self.isPlayBackVideo) {
            
            [_splitViewBtn setHidden:YES];
            [_splitViewCon setHidden:YES];
        }
        
        
        if (self.navigationController.navigationBarHidden) {
            
            self.navigationController.navigationBarHidden = NO;
        }
        
    }else{
    
        [_splitViewBtn setHidden:YES];
        [_splitViewCon setHidden:YES];
    }
    
    [self setAlarmTypeButton];
    
}

/**
 *  加载右侧的手动录像和报警录像按钮
 *
 *  @param imageName 图片名称
 *  @param title     图片的标题
 */
-(void)initwithRightButton:(NSString *)imageName withTitle:(NSString *)title{
    
    if (imageName == nil) {
        
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        return;
    }
    
    JVCControlHelper *controlObj = [JVCControlHelper shareJVCControlHelper];
    
    UIImageView *rightImageView     = [[UIImageView alloc] init];
    rightImageView.backgroundColor  = [UIColor clearColor];
    rightImageView.frame            = CGRectMake(0.0, 0.0, kRightButtonViewWithWidth, kRightButtonViewWithHeight);
    rightImageView.userInteractionEnabled = YES;
    
    UIButton *rightButton = [controlObj buttonWithTitile:nil normalImage:imageName horverimage:nil];
    
    CGRect rightRectBtn   = rightButton.frame;
    rightRectBtn.origin.x = (rightImageView.frame.size.width - rightRectBtn.size.width)/2.0;
    rightButton.frame     = rightRectBtn;
    rightButton.userInteractionEnabled = NO;
    [rightImageView addSubview:rightButton];
    
    UILabel *titleLbl     = [controlObj labelWithText:title];
    CGRect titleRect      = titleLbl.frame;
    titleRect.origin.y    = rightRectBtn.size.height;
    titleRect.size.width  = rightImageView.frame.size.width;
    titleRect.size.height = kRightButtonViewWithTitleHeight;
    titleLbl.frame        = titleRect;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text         = title;
    titleLbl.textColor    = [UIColor whiteColor];
    titleLbl.font         = [UIFont systemFontOfSize:kRightButtonViewWithTitleFont];
    [rightImageView addSubview:titleLbl];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoOrAlarmVideoModeSwitch)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [rightImageView addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:rightImageView];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    [rightImageView release];
}

/**
 *  手动录像和报警录像切换
 */
-(void)autoOrAlarmVideoModeSwitch {

    JVCCloudSEENetworkHelper *netWorkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    if ([netWorkObj checknLocalChannelIsDisplayVideo:_managerVideo.nSelectedChannelIndex+1]) {
        
        [netWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_StorageMode remoteOperationCommand:nStorageType==StorageType_alarm?StorageType_auto:StorageType_alarm];
        [netWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
    }
}

- (void)viewDidLoad
{
    self.tenCentKey = kTencentKey_operationPlay;
    [super viewDidLoad];
    
    unAllLinkFlag = DISCONNECT_CONNECT;
    
    [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = YES;
    
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
     *  标题
     */
    self.navigationItem.title = self.isPlayBackVideo == YES ? NSLocalizedString(@"Play back", nil):NSLocalizedString(@"Video Display", nil);
    
    [self initLayoutWithShowVideoView];
    
     ytOperationView = [[JVCYTOperaitonView alloc] initContentViewWithFrame:_managerVideo.frame];
    [self.view addSubview:ytOperationView];
    [ytOperationView release];

    /**
     *  抓拍完成之后图片有贝萨尔曲线动画效果的imageview
     */
    capImageView=[[UIImageView alloc] init];
    capImageView.frame=_managerVideo.frame;
    [self.view addSubview:capImageView];
    [capImageView setHidden:YES];
    
    /**
     *  抓拍、对讲、录像、更多按钮的view
     */
    NSString *pathSamllImage    =  [UIImage imageBundlePath:@"tabbar_bg.png"];
    UIImage *_smallItemBgImage  = [[UIImage alloc]initWithContentsOfFile:pathSamllImage];
    CGRect frameBottom ;

    frameBottom = CGRectMake(0.0, self.view.frame.size.height-_smallItemBgImage.size.height, self.view.frame.size.width, _smallItemBgImage.size.height);
    [_smallItemBgImage release];

    NSArray *arrayTitle = [NSArray arrayWithObjects:NSLocalizedString(@"Capture", nil),NSLocalizedString(@"megaphone", nil),NSLocalizedString(@"video", nil) ,NSLocalizedString(@"stream_0", nil), nil];
    
    /**
     *  底部的按钮
     */
    _operationItemSmallBg =  [[JVCCustomOperationBottomView alloc] init];
    [_operationItemSmallBg updateViewWithTitleArray:arrayTitle Frame:frameBottom SkinType:skinSelect];
    _operationItemSmallBg.BottomDelegate = self;
    [_operationItemSmallBg setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_operationItemSmallBg];
    [_operationItemSmallBg release];
    
    UIButton *talkBtn = [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];

    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedStartTalk:)];
    [talkBtn addGestureRecognizer:longPress];
    longPress.allowableMovement = NO;
    longPress.minimumPressDuration = 0.5;
    [longPress release];
    
    /**
     *  多窗口的时候，导航栏上面的三角按钮，用于选中4、9、16窗口
     */
    _splitViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *_splitShow=[UIImage imageNamed:@"play_dwn.png"];

    float _x;
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        _x=190-_splitShow.size.width/2.0;
    }else
    {
        _x= 190-_splitShow.size.width/2.0;
    }
    
    _splitViewBtn.frame=CGRectMake(_x, (self.navigationController.navigationBar.frame.size.height-_splitShow.size.height-5.0)/2.0+3.0, _splitShow.size.width-5.0, _splitShow.size.height-2.0);
    [_splitViewBtn setShowsTouchWhenHighlighted:YES];
    [_splitViewBtn addTarget:self action:@selector(gotoShowSpltWindow) forControlEvents:UIControlEventTouchUpInside];
    [_splitViewBtn setBackgroundImage:_splitShow forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_splitViewBtn];
    if (self.isPlayBackVideo) {//远程回放，隐藏此按钮
        
        _splitViewBtn.hidden = YES;
    }
    
    /**
     *  中间的语音对讲、云台、远程回放按钮
     */
    
    CGRect frame = CGRectMake(0.0, _managerVideo.frame.origin.y+_managerVideo.frame.size.height, self.view.frame.size.width, _operationItemSmallBg.frame.origin.y-_managerVideo.frame.size.height-_managerVideo.frame.origin.y);
    
    [self initOperationControllerMiddleViewwithFrame:frame];
    
    skinSelect = 0;
}

/**
 *  初始化视频显示窗口视图
 */
-(void)initLayoutWithShowVideoView {

    /**
     *  播放窗体
     */
    _managerVideo                            = [[JVCManagePalyVideoComtroller alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width*0.75)];
    _managerVideo.tag                        = 100;
    _managerVideo.strSelectedDeviceYstNumber = self.strSelectedDeviceYstNumber;
    _managerVideo._operationController       = self;
    _managerVideo.delegate                   = self;
    _managerVideo.isPlayBackVideo            = self.isPlayBackVideo;
    _managerVideo.nSelectedChannelIndex      = self._iSelectedChannelIndex;
    _managerVideo.imageViewNums              = kDefaultShowWidnowCount;
    _managerVideo.isConnectAll               = self.isConnectAll;
    [_managerVideo setUserInteractionEnabled:YES];
    [self.view addSubview:_managerVideo];
    [_managerVideo initWithLayout];

}

/**
 *  初始化长按对讲提示界面
 */
-(void)initTalkView {
    
    int width  = kTalkViewWithWidth ;
    int height = kTalkViewWithHeight ;
    
    talkView = [[UIView alloc] init];
    talkView.backgroundColor = [UIColor blackColor];
    talkView.alpha = 0.8 ;
    talkView.layer.cornerRadius = 5.0;
    talkView.layer.borderWidth  = 1.0;
    talkView.layer.borderColor  = [UIColor grayColor].CGColor;
    talkView.frame = CGRectMake((self.view.frame.size.width - width)/2.0 , (self.view.frame.size.height - height)/2.0, width, height);
    
    
    UIImage *image = [UIImage imageNamed:@"ope_long_talk.png"];
    
    UIImageView *talkImageIcon    = [[UIImageView alloc] init];
    talkImageIcon.frame           = CGRectMake(15.0, (height-image.size.height)/2.0, image.size.width, image.size.height);
    talkImageIcon.image           = image;
    talkImageIcon.backgroundColor = [UIColor clearColor];
    [talkView addSubview:talkImageIcon];
    [talkImageIcon release];
    
    
    UILabel *talkTitle=[[UILabel alloc] init];
    talkTitle.frame=CGRectMake(talkImageIcon.frame.origin.x+talkImageIcon.frame.size.width+5.0, (height-40)/2,width - talkImageIcon.frame.origin.x-talkImageIcon.frame.size.width - 15.0, 40);
    talkTitle.numberOfLines = 2;
    talkTitle.lineBreakMode = UILineBreakModeWordWrap;
    [talkTitle setTextColor:[UIColor blueColor]];
    talkTitle.text=NSLocalizedString(@"talkStart", nil);
    [talkTitle setTextColor:[UIColor whiteColor]];
    talkTitle.font=[UIFont systemFontOfSize:14];
    talkTitle.textAlignment=UITextAlignmentLeft;
    [talkTitle setBackgroundColor:[UIColor clearColor]];
    [talkView addSubview:talkTitle];
    
    [talkTitle release];
    
    [self.view addSubview:talkView];
    
    [talkView release];
}

/**
 *  移除长按对讲界面
 */
-(void)RemoveTalkView {
    
    if (talkView != nil) {
        
        [talkView removeFromSuperview];
        talkView = nil;
    }
}

/**
 *  长按说话
 *
 *  @param longGestureRecognizer 长按对象
 */
-(void)longPressedStartTalk:(UILongPressGestureRecognizer *)longGestureRecognizer{
    
    JVCCloudSEENetworkHelper *jvcCloudseeObj  = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    if ([jvcCloudseeObj checknLocalChannelIsDisplayVideo:_managerVideo.nSelectedChannelIndex+1] && ! isCurrentHomePC) {
        
        return;
    }
    
    if (![_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK].selected) {
        
        [self RemoveTalkView];
        return;
    }
    
    if ([longGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self beginTalk];
        
    }else if ([longGestureRecognizer state] == UIGestureRecognizerStateEnded){
        
        [self stopTalk];
        
        isLongPressedStartTalk = FALSE;
    }
}

/**
 *  开启语音对讲延迟播放声音的心跳
 */
-(void)startCheckTalkTimer{

    [self performSelectorOnMainThread:@selector(talkTimer) withObject:nil waitUntilDone:NO];
}

/**
 *  停止
 */
-(void)stopTalkTimer{
    
    if (isLongPressedStartTalk) {
        
        if (talkTimer !=nil) {
            
            if ([talkTimer isValid]) {
                
                [talkTimer invalidate];
            }
            
            talkTimer = nil;
        }
    }
}

/**
 *  开启对讲的Time
 */
-(void)talkTimer{
    
   
    [self stopTalkTimer];

    if (talkTimer == nil) {
        
        talkTimer = [NSTimer scheduledTimerWithTimeInterval:kTalkDelayTimer target:self selector:@selector(changeTalkStatus) userInfo:nil repeats:NO];
    }
}

/**
 *  改变语音对讲的状态
 */
-(void)changeTalkStatus {

    DDLogVerbose(@"%s-----#00000000000----------",__FUNCTION__);
     talkTimer = nil;
     isLongPressedStartTalk = FALSE;
}

/**
 *  语音请求
 */
-(void)beginTalk {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *jvcCloudseeObj  = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        AQSController            *aqCon           = [AQSController shareAQSControllerobjInstance];
        
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Talk];
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Talk];
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Talk];
        [aqCon changeRecordState:TRUE];
        
        isLongPressedStartTalk = TRUE;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initTalkView];
            
        });
        
    });
}

/**
 *  停止语音请求
 */
-(void)stopTalk {
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *jvcCloudseeObj  = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        AQSController            *aqCon           = [AQSController shareAQSControllerobjInstance];
        
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Notalk];
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Notalk];
        [jvcCloudseeObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:TextChatType_setTalkModel remoteOperationCommand:DEVICETALKMODEL_Notalk];
        
        [aqCon changeRecordState:FALSE];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self talkTimer];
            [self RemoveTalkView];
        
        });
    
    });
    
    
}

#pragma mark -------------- JVCManagePalyVideoComtroller delegate
/**
 *  视频连接失败的回调函数
 */
- (void)connectVideoFailCallBack:(BOOL)isPassword{
    
      [self closeAudioAndTalkAndVideoFuction];
        
      if (self.isPlayBackVideo) {
            
        [self.navigationController popToRootViewControllerAnimated:YES];
          
      }else{
      
          if (isPassword) {
              
              dispatch_async(dispatch_get_main_queue(), ^{
              
                [self  showAlertWithUserOrPassWordError];
              });
          }else{
                        
              if ([self.navigationController.viewControllers containsObject:self]) {
                  
                  [self.navigationController popToViewController:self animated:YES];
              }
          
          }
     }
}

/**
 *  改变当前视频窗口下方码流的显示文本
 *
 *  @param nStreamType 码流类型
 */
-(void)changeCurrentVidedoStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC withEffectType:(int)effectType withStorageType:(int)storageType{
    
    nCurrentStreamType = nStreamType;
    isCurrentHomePC    = isHomeIPC;
    nStorageType       = storageType;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        switch (nStreamType) {
                
            case VideoStreamType_Default:
            case VideoStreamType_HD:
            case VideoStreamType_SD:
            case VideoStreamType_FL:
            [_operationItemSmallBg setVideoStreamState:nStreamType];
            NSString *bundString =  [ NSString stringWithFormat: @"stream_%d",nStreamType];
            [[JVCHorizontalScreenBar shareHorizontalBarInstance ] setStreamBtnTitle:NSLocalizedString(bundString, nil)];
                break;
            default:
                nCurrentStreamType = 0;
                break;
        }
        
        [self setAlarmTypeButton];
        
    });
}

/**
 *  设置报警的类型
 */
- (void)setAlarmTypeButton
{
    if (_managerVideo.imageViewNums > kDefaultShowWidnowCount || _isPlayBackVideo) {
        
        [self initwithRightButton:nil withTitle:nil];
        
    }else {
        
        switch (nStorageType) {
                
            case StorageType_alarm:{
                
                [self initwithRightButton:@"sto_alarm.png" withTitle:LOCALANGER(@"jvcoper_autoRecord")];
            }
                break;
            case StorageType_auto:{
                
                [self initwithRightButton:@"sto_auto.png" withTitle:LOCALANGER(@"jvcoper_Record")];
            }
                break;
                
            default:{
                
                [self initwithRightButton:nil withTitle:nil];
            }
                break;
        }
    }

}

-(void)refreshDeviceRemoteInfoCallBack:(NSMutableDictionary *)mdRemoteInfo{

    for (UIViewController *con in self.navigationController.viewControllers) {
        
        if ([con isKindOfClass:[JVCOperaDeviceConnectManagerTableViewController class]]) {
            
            JVCOperaDeviceConnectManagerTableViewController *remoteDeviceViewcontroller = (JVCOperaDeviceConnectManagerTableViewController *)con;
            
            [remoteDeviceViewcontroller.deviceDic addEntriesFromDictionary:mdRemoteInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [remoteDeviceViewcontroller refreshInfo];
            
            });
            
        }
    }

}

/**
 *  初始化音频监听、云台、远程回放模块
 */
- (void)initOperationControllerMiddleViewwithFrame:(CGRect )newFrame
{
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"Playback", nil),NSLocalizedString(@"remoteSetDevice", nil), nil];
    
     _operationBigItemBg =   [[JVCOperationMiddleView alloc] init];
    
    [_operationBigItemBg updateViewWithTitleArray:array frame:newFrame skinType:skinSelect];
    
    _operationBigItemBg.delegateOperationMiddle = self;
    
    [self.view addSubview:_operationBigItemBg];
    [_operationBigItemBg release];
    
    JVCCustomYTOView *ytoView = [JVCCustomYTOView shareInstance];
    ytoView.frame = CGRectMake(_operationBigItemBg.frame.origin.x,_operationBigItemBg.frame.origin.y,_operationBigItemBg.frame.size.width,_operationBigItemBg.frame.size.height);
    ytoView.tag=661;
    ytoView.delegateYTOperation=self;
    [self.view addSubview:ytoView];
    [ytoView setHidden:YES];
}

-(void)gotoShowSpltWindow{
    
    //开启音频监听或者对讲获取录像的时候，这个功能是不能用的
    if ([self getOperationViewstate]) {
        
        return;
    }
    
    NSMutableArray *_splitItems=[[NSMutableArray alloc] initWithCapacity:10];
    
    [_splitItems addObjectsFromArray:[self getSplitWindowMaxNumbers]];
    
    _splitViewCon= [JVCCustomCoverView shareInstance];
    [self.view.window addSubview:_splitViewCon];
    
    _splitViewCon.frame = CGRectMake(0,0, self.view.frame.size.width, 0.0);
    _splitViewCon.CustomCoverDelegate=self;
    _splitViewCon.hidden = NO;
    [_splitViewCon updateConverViewWithTitleArray:_splitItems skinType:skinSelect];
    [_splitItems release];

    
}

/**
 *  判断是否支持多屏，（开启音频监听||开启云台||开启对讲||开启录像的时候，不让多屏)
 */
- (BOOL)getOperationViewstate
{
    //云台的
    BOOL bStateYTView =  [[JVCCustomYTOView shareInstance] getYTViewShowState];
    
    //音频监听
    BOOL bStateAudio  =  [_managerVideo getSingleViewVoiceBtnState];
    
    //对讲的状态
    UIButton *btnTalk  =  [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];
    BOOL bStateTalk   =  btnTalk.selected;
    
    //录像的状态
    UIButton *btnVideo  =  [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_VIDEO];
    BOOL bStateVideo   =  btnVideo.selected;
    
    if (bStateYTView || bStateAudio || bStateTalk || bStateVideo ) {
        
        return YES;
    }
    return NO;
}

/**
 *  返回底部按钮的选中状态
 *
 *  @param indexBtn index
 *
 *  @return 选中状态
 */
- (BOOL)getButtonWithIndex:(int)indexBtn
{
    UIButton *btn  =  [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];
    return  btn.selected;

}

#pragma mark 返回当前的屏幕显示的模式
-(NSMutableArray*)getSplitWindowMaxNumbers{
    
    NSMutableArray *_windowListData=[NSMutableArray arrayWithCapacity:10];
    
    int channelListCount = [_managerVideo channelCountAtSelectedYstNumber];
    
    if (channelListCount <= showWindowNumberType_Four) {
        
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        
    }else if(channelListCount <= showWindowNumberType_Nine){
        
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"nine-Screen", nil)]];
        
    }else {
        
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"four-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"nine-Screen", nil)]];
        [_windowListData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"sixteen-Screen", nil)]];
        
    }
    
    return _windowListData;
    
}

#pragma mark 返回上一级
-(void)BackClick{
    
    if (_isPlayBackVideo&&!self.isPlayBackVideo) {
        //不敢是远程回放还是播放窗口，都有开启录像功能，点击返回时，要关闭

        [self closeAudioAndTalkAndVideoFuction];
        
        _isPlayBackVideo=FALSE;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            
            [ystNetworkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationCommand:JVN_CMD_PLAYSTOP];
            [ystNetworkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationCommand:JVN_RSP_PLAYOVER];
            
            [ystNetworkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationCommand:JVN_CMD_VIDEO];
            
        });
        
        
    }else{
        
        
        
        self.navigationController.navigationBarHidden = NO;
        //关闭文本、视频的回调
        JVCCloudSEENetworkHelper        *ystNetWorkObj   = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        ystNetWorkObj.ystNWHDelegate    = nil;
        ystNetWorkObj.ystNWTDDelegate   = nil;
        //不敢是远程回放还是播放窗口，都有开启录像功能，点击返回时，要关闭

        [self closeAudioAndTalkAndVideoFuction];
        
        wheelAlterInfo=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnecting nowPlease Wait", nil)
                                                  message:nil
                                                 delegate:nil
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
        unAllLinkFlag = DISCONNECT_ALL;
        
        [NSThread detachNewThreadSelector:@selector(unAllLink) toTarget:self withObject:nil];
       
    }
    
}

#pragma mark 断开事件

-(void)unAllLink{
    
    [_managerVideo CancelConnectAllVideoByLocalChannelID];
    
	for (int i=0; i < kJVCCloudSEENetworkHelperWithConnectMaxNumber; i++) {
        
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
    [self.view bringSubviewToFront: [JVCCustomYTOView shareInstance]];
    
}

-(void)ytoHidenClick{
    
    [[JVCCustomYTOView shareInstance] HidenYTOperationView];
}

-(void)closeAlterViewAllDic{
    

    JVCCloudSEENetworkHelper *networkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    networkHelperObj.ystNWADelegate            = nil;
    networkHelperObj.ystNWHDelegate            = nil;
    networkHelperObj.ystNWRODelegate           = nil;
    networkHelperObj.ystNWRPVDelegate          = nil;
    networkHelperObj.ystNWTDDelegate           = nil;
    networkHelperObj.videoDelegate             = nil;
    
    [wheelAlterInfo dismissWithClickedButtonIndex:0 animated:NO];
    
    DDLogVerbose(@"___%s==========004",__FUNCTION__);

    if (self.isPlayBackVideo) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToPreviousViewController
{
    
    DDLogVerbose(@"___%s==========005",__FUNCTION__);

    if (self.isPlayBackVideo) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark 保存本地录像的文件
- (void)saveLocalVideo:(NSString*)urlString{
    
    if (urlString) {
        
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            // NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            //  "pictureLibraynoAutor" = "无法访问相册.请在'设置->定位服务'设置为打开状态.";
            //"picturelibrayError"
            
            
            if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil) ];
                    
                    
                    // NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"videolibrayError", nil) ];
                    //   NSLog(@"相册访问失败.");
                });
                
            }
            
        };
        
        JVCConstansALAssetsMathHelper *alassetLibrary=[[[JVCConstansALAssetsMathHelper alloc] init] autorelease];
        
        [alassetLibrary saveVideoToAlbumPhoto:[NSURL URLWithString:urlString] albumGroupName:(NSString *)kKYCustomVideoAlbumName returnALAssetsLibraryAccessFailureBlock:failureblock];

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

- (void)setScrollviewByIndex:(NSInteger)Index
{
    [_managerVideo  setScrollviewByIndex:Index];
}

-(void)startRepeatConnect:(NSDictionary*)_connectInfo{
    
}

#pragma mark 最下面的操作按钮控制方法
-(void)smallBtnTouchUpInside:(UIButton*)sender{
    //sender.selected=TRUE;
    
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
    [self.view bringSubviewToFront:ytOperationView];
    [self.view bringSubviewToFront:[JVCHorizontalScreenBar shareHorizontalBarInstance]];

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
        
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALANGER(@"Connection Failed ID_and_modify_user_and password") message:nil delegate:self cancelButtonTitle:LOCALANGER(@"jvc_more_loginout_quit") otherButtonTitles:LOCALANGER(@"jvc_more_loginout_ok"), nil];
            alertView.tag = kAlertTag;
            [alertView show];
            [alertView release];
     
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    

    if (alertView.tag == kAlertTag) {
        
        if (buttonIndex == 0) {
        
            
        }else{//跳转到修改用户名密码的界面
    
            [self gotoModifyUserAndPassWordViewcontroller];
        }
            
    }
}

#pragma mark ---------------- 当连接设备时身份验证失败弹出的修改提示
- (void)gotoModifyUserAndPassWordViewcontroller
{
    JVCDeviceModel *model=[[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[_managerVideo ystNumberAtCurrentSelectedIndex]];

    if ([ JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
        
        JVCLocaOperationModifyViewController *viewController = [[JVCLocaOperationModifyViewController alloc] init];
        viewController.modifyDelegate = self;
        viewController.modifyModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }else{
    
        JVCOperationModifyViewController *viewController = [[JVCOperationModifyViewController alloc] init];
        viewController.modifyDelegate = self;
        viewController.modifyModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
}

/**
 *  修改完之后的返回事件
 */
- (void)modifyDeviceInfoCallBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [_managerVideo connectVideoByLocalChannelID:KWINDOWSFLAG+self._iSelectedChannelIndex];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {

        return NO;
    }
    
    if (isLongPressedStartTalk) {

        return  NO;
    }
    
    [self removHelpView];

    return unAllLinkFlag == DISCONNECT_ALL ? NO:YES;;
}
-(NSUInteger)supportedInterfaceOrientations{
    
    [self removHelpView];
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    if (isLongPressedStartTalk) {
       
        return  NO;
    }

    return unAllLinkFlag == DISCONNECT_ALL ? NO:YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    _managerVideo.isShowVideo = TRUE;

//        [self shouldAutorotate];
//        [self shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    
 
    
     if( UIDeviceOrientationIsValidInterfaceOrientation( toInterfaceOrientation ) )     {         //参数表示是否横屏，这里我只需要知道屏幕方向就可以提前知道目标区域了！         [self setCtrlPos: UIInterfaceOrientationIsLandscape( toInterfaceOrientation) ];
         
            CGRect rectFrame = [self getClientRect:UIInterfaceOrientationIsLandscape( toInterfaceOrientation)];
         if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
             
             
             [self changeRotateFromInterfaceOrientationFrame:YES frame:rectFrame];
             
         } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
             
             
             [self changeRotateFromInterfaceOrientationFrame:NO  frame:rectFrame];
             
         } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
             
             
             [self changeRotateFromInterfaceOrientationFrame:NO  frame:rectFrame];
         }else if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
             
             
             [self changeRotateFromInterfaceOrientationFrame:YES  frame:rectFrame];
         }

         
     }
    
    
}


//可以根据横屏还是竖屏，提前预知目标窗口区域大小  //不要看多了这么一整个函数，但是给多个UIViewController调用就很方便了。  //这一个函数，本人丢到自定义的公共文件去实现。当做全局函数，一般用global.h来声明接口，在global.m实现。
- (CGRect)getClientRect:( BOOL) isHorz
{
    BOOL isStatusBarHidden = [[ UIApplication sharedApplication ]isStatusBarHidden ]; //判断屏幕顶部有没状态栏出现
    CGRect rcScreen = [[UIScreen mainScreen] bounds];//这个不会随着屏幕旋转而改变
    CGRect rcClient = rcScreen;
    CGRect rcArea = rcClient;
    if( isHorz )
    {
        rcArea.size.width = MAX(rcClient.size.width,rcClient.size.height);
        rcArea.size.height = MIN(rcClient.size.width,rcClient.size.height);
    }
    return rcArea;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    _managerVideo.isShowVideo = FALSE;
    
//    if (isLongPressedStartTalk) {
//        
//        [self stopTalk];
//    }
}


-(void)changeRotateFromInterfaceOrientationFrame:(BOOL)IsRotateFrom  frame:(CGRect)frame{
    
    if (IsRotateFrom) {
        [JVCHorizontalScreenBar shareHorizontalBarInstance].bStateHorigin = NO;

        self.navigationController.navigationBarHidden = NO;
        _managerVideo.frame=CGRectMake(0,  0, 320, 320*0.75);
        [_managerVideo setManagePlayViewScrollState:YES];
        [_managerVideo changeContenView];
        _managerVideo.hidden = NO;
        [self.view bringSubviewToFront:_managerVideo];
        [self.view bringSubviewToFront:ytOperationView];
        [self.view bringSubviewToFront:_operationItemSmallBg];
        
        [JVCHorizontalScreenBar shareHorizontalBarInstance].hidden = YES;

    }else{
        
        int deleteSize = 0;
        
        if (IOS_VERSION<IOS7) {
            
            deleteSize = kBarios6;
        }
        
        if (_splitViewCon.frame.size.height>0) {
            
            [self gotoShowSpltWindow];
        }
        
        [JVCHorizontalScreenBar shareHorizontalBarInstance].bStateHorigin = YES;

        self.navigationController.navigationBarHidden = YES;
        

        _managerVideo.frame=CGRectMake( 0, 0, frame.size.width , frame.size.height-deleteSize);
        [_managerVideo setManagePlayViewScrollState:NO];
        [_managerVideo setSingleViewVerticalViewState:YES];
     
        /**
         *  是否多屏，多屏的时候，变成单屏
         */
        [self changeManagePalyVideoComtrollerViewsToSingeView];
        [_managerVideo changeContenView];

        [self.view bringSubviewToFront:_managerVideo];
        [self.view bringSubviewToFront:ytOperationView];
        [ straemView removeFromSuperview];

        //显示横屏的按钮
        [JVCHorizontalScreenBar shareHorizontalBarInstance].hidden = NO;
        [JVCHorizontalScreenBar shareHorizontalBarInstance].alpha =1.0f;

        [JVCHorizontalScreenBar shareHorizontalBarInstance].HorizontalDelegate = self;
        [JVCHorizontalScreenBar shareHorizontalBarInstance].frame = CGRectMake(0, _managerVideo.bottom - HORIZEROSCREENVIEWHEIGHT,frame.size.width, HORIZEROSCREENVIEWHEIGHT);
        
        if (![self.view.subviews containsObject:[JVCHorizontalScreenBar shareHorizontalBarInstance]]) {
            
            [self.view addSubview:[JVCHorizontalScreenBar shareHorizontalBarInstance]];
        }
        
        [self.view bringSubviewToFront:[JVCHorizontalScreenBar shareHorizontalBarInstance]];
    }
    
    DDLogVerbose(@"%@========",_managerVideo);
}

#pragma mark 返回远程回放的状态
-(BOOL)returnIsplayBackVideo{
    
    return _isPlayBackVideo;
    
}

/**
 *	获取当前窗口GLView的是否可见
 *
 *	@return	获取当前窗口GLView的是否可见
 */
-(BOOL)isCheckCurrentSingleViewGlViewHidden{
    
    
     JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)[self.view viewWithTag:KWINDOWSFLAG+self._iSelectedChannelIndex];
    
    return [(UIView *)singleView._glView isHidden];
    
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




#pragma mark ********************************************
#pragma mark ********************************************
#pragma mark 切换窗口的布局
-(void)changeSplitView:(int)_splitWindows{
    
    int channelListCount = [_managerVideo channelCountAtSelectedYstNumber];

    if (channelListCount > showWindowNumberType_One) {
        
        if (_splitWindows > showWindowNumberType_One) {
            
            [self closeAudioAndTalkAndVideoFuction];
            
            [_managerVideo hiddenEffectView];
        }
        
        _managerVideo._iBigNumbers = 1;
        _managerVideo.imageViewNums = _splitWindows;
        
        _managerVideo.isShowVideo = YES;
        [_managerVideo changeContenView];
        _managerVideo.isShowVideo = FALSE;
    }
}

#pragma mark －－－－－－－－－－－－－－语音对讲、抓拍、本地录像、码流切换模块

#pragma mark 底部按钮按下事件
/**
 *  bottom按钮按下的事件回调
 */
- (void)customBottomPressCallback:(NSUInteger )buttonPress
{
    /**
     *  是否有画面
     */
    if (![self judgeOpenVideoPlaying] ) {
        
        return;
        
    }
    /**
     *  是否多屏，多屏的时候，变成单屏
     */
    [self changeManagePalyVideoComtrollerViewsToSingeView];
    
    UIButton *btn = [_operationItemSmallBg getButtonWithIndex:buttonPress];

    
    switch (buttonPress) {
            
        case BUTTON_TYPE_CAPTURE:
        {
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationCaptur];

            [self smallCaptureTouchUpInside:btn];
        }
            break;
            
        case BUTTON_TYPE_TALK:
        {
            
            //04解码器不支持此操作
            if (![_managerVideo getCurrentSelectedSingelViewIs05Device]) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
                
                return;
            }
            
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }
            
            
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationTalk];

            [self chatRequest:btn];
        }
            break;
            
        case BUTTON_TYPE_VIDEO:
        {
            
            
            //04解码器不支持此操作
            if (![_managerVideo getCurrentSelectedSingelViewIs05Device]) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
                
                return;
            }
            
            btn.selected = !btn.selected;
            
            if (btn.isSelected) {
                
                [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForSelectState:HORIZONTALBAR_VIDEO];
                
            }else{
                
                [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForNormalState:HORIZONTALBAR_VIDEO];
                
            }
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationVideo];

            [self operationPlayVideo:btn.selected];
            
        }
            break;
            
        case BUTTON_TYPE_MORE:
        {
            
            //04解码器不支持此操作
            if (![_managerVideo getCurrentSelectedSingelViewIs05Device]) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
                
                return;
            }
            
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationSteam];

            [self showChangeStreamView:btn];
        }
            break;
            
        default:
            break;
    }
}


/**
 *  显示画质切换
 */
- (void)showChangeStreamView:(UIButton *)btn
{
    if (VideoStreamType_Default == nCurrentStreamType ||VideoStreamType_NoSupport == nCurrentStreamType) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"This video source doesn't support image resolution switch.")];
        return;
    }
     straemView= [[JVCPopStreamView alloc] initStreamView:btn andSelectindex:nCurrentStreamType streamCountType:[_managerVideo getCurrentIsOldHomeIPC]];
    straemView.delegateStream = self;
    [self.view addSubview:straemView];
    [straemView show];
}

/**
 *  切换码流的
 *
 *  @param index 选中的码流的index
 */
- (void)changeStreamViewCallBack:(int)index
{
    [self removeStreamView];

    if (nCurrentStreamType != index) {
        
        JVCCloudSEENetworkHelper *netWorkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkObj.ystNWRODelegate            = _managerVideo;
        
        [_managerVideo getCurrentIsOldHomeIPC] == YES ? [netWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex + 1 remoteOperationType:TextChatType_setStream remoteOperationCommand:index]:[netWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex + 1 remoteOperationType:TextChatType_setOldStream remoteOperationCommand:index];
    }
}

#pragma mark 保存图片
-(void)smallCaptureTouchUpInside:(UIButton*)button{
    
    /**
     *  保存照片失败的事件
     */
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        
        
        if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil)];
                
                // NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"picturelibrayError", nil)];
                
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
    
    
    //判断是否开启音频监听、如果打开关闭音频监听
    [self stopAudioMonitor];
    
    JVCCloudSEENetworkHelper        *ystNetWorkObj   = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkObj.ystNWADelegate    = self;
    
    if (!button.selected) {
        
        [ystNetWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_VoiceIntercom remoteOperationCommand:JVN_REQ_CHAT];
    }else {
        
        [ystNetWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_VoiceIntercom remoteOperationCommand:JVN_CMD_CHATSTOP];
        
        /**
         *  使选中的button变成默认
         */
        [_operationItemSmallBg setbuttonUnSelectWithIndex:BUTTON_TYPE_TALK];
        
        [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForNormalState:HORIZONTALBAR_TACK ];
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
    
    saveImageDate = [imageData retain];
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        
        [saveImageDate release];
        
        if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper ]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil) ];
                
                 DDLogVerbose(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JVCAlertHelper shareAlertHelper ]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"picturelibrayError", nil) ];
            
            });
        }
    };

    
    JVCConstansALAssetsMathHelper  *alassetLibrary=[[[JVCConstansALAssetsMathHelper alloc] init] autorelease];
    alassetLibrary.AseeetDelegate = self;
    [alassetLibrary saveImageToAlbumPhoto:[UIImage imageWithData:imageData ] albumGroupName:(NSString *)kKYCustomPhotoAlbumName returnALAssetsLibraryAccessFailureBlock:failureblock];
    
    [imageData release];
}

/**
 * 保存图像到指点相册的返回值
 *
 *  @param result 1 成功  0 失败
 */
- (void)savePhotoToAlassertsWithResult:(NSString *)result 
{
    dispatch_async(dispatch_get_main_queue(), ^{

        UIImageView *imgView=capImageView;
        [self.view bringSubviewToFront:imgView];
        UIImage *image = [UIImage imageWithData:saveImageDate];
        [imgView setImage:image];
        [capImageView setHidden:NO];
        [UIView beginAnimations:@"superView" context:nil];
        [UIView setAnimationDuration:0.4f];
        imgView.frame=CGRectMake((imgView.frame.size.width-_bSmallCaptureBtn.frame.size.width)/2.0, (imgView.frame.size.height-_bSmallCaptureBtn.frame.size.height)/2., STARTHEIGHTITEM, STARTHEIGHTITEM);
        [UIView commitAnimations];
        [self capAnimations];
        
        [saveImageDate release];
        
    });


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
    
    [aqsControllerObj changeRecordState:!isCurrentHomePC]; //设置采集的模式
    
}

#pragma mark AQSController Delegate

/**
 *  发送音频数据的回调函数
 *
 *  @param audionData    采集的音频数据
 *  @param audioDataSize 采集的音频数据大小
 */
-(void)receiveAudioDataCallBack:(char *)audionData audioDataSize:(long)audioDataSize{
    
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
 *  iphone5、5s中间的那块音频监听 云台 远程回放
 *
 *  @param clickBtnType 选则那个按钮
 */
-  (void)operationMiddleIphone5BtnCallBack:(int)clickBtnType
{
    DDLogInfo(@"%s====%d",__FUNCTION__,clickBtnType);
    
    [self MiddleBtnClickWithIndex:clickBtnType];
}

/**
 *  相应单个singleview的事件
 *
 *  @param state yes 选中  no 不选中
 */
- (void)responseSingleViewVoicebtnEvent:(BOOL)state;
{
    [self operationAudio];
}

/**
 * 按下事件的执行方法
 *
 *  @param index btn的index
 */
- (void)MiddleBtnClickWithIndex:(int )index
{
    /**
     *  是否有画面
     */
    if (![self judgeOpenVideoPlaying]) {
        
        return;
    }
    
    //04解码器不支持此操作
    if (![_managerVideo getCurrentSelectedSingelViewIs05Device]) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
        
        return;
    }
    

    
    switch (index) {
            
        case TYPEBUTTONCLI_SOUND:{
            
            /**
             *  是否多屏，多屏的时候，变成单屏
             */
            [self changeManagePalyVideoComtrollerViewsToSingeView];
            
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }

            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationAudio];
            
            
            [self gotoOperationDeviceAlarmState];
            
        }
            break;
        case TYPEBUTTONCLI_YTOPERATION:
            
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationYT];

            [self ytoClick:nil];
            break;
            
        case TYPEBUTTONCLI_PLAYBACK:
        {
            /**
             *  是否多屏，多屏的时候，变成单屏
             */
            [self changeManagePalyVideoComtrollerViewsToSingeView];
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationplaybac];

            [self remotePlaybackClick];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  去往报警设置界面
 */
- (void)gotoOperationDeviceAlarmState
{
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn != TYPELOGINTYPE_ACCOUNT) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_local_noSupport")];
        return;
        
    }
    
    BOOL newIPCState =  [_managerVideo getCurrentIsOldHomeIPC];
    
    if (newIPCState) {
        
        JVCMonitorConnectionSingleImageView *singleView=(JVCMonitorConnectionSingleImageView*)[self.view viewWithTag:KWINDOWSFLAG+self._iSelectedChannelIndex];
        JVCOperaDeviceConnectManagerTableViewController *viewController = [[JVCOperaDeviceConnectManagerTableViewController alloc] init];
        [viewController.deviceDic addEntriesFromDictionary:singleView.mdDeviceRemoteInfo];
        viewController.nLocalChannel = _managerVideo.nSelectedChannelIndex+1;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];

    }else{
        
        JVCDeviceModel *model=[[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[_managerVideo ystNumberAtCurrentSelectedIndex]];
            
        if (model.isDeviceType ) {
            
            JVCOperaOldDeviceConnectAlarmViewController *deviceAlarmVC = [[JVCOperaOldDeviceConnectAlarmViewController alloc] init];
            deviceAlarmVC.deviceModel = model;
            [self.navigationController pushViewController:deviceAlarmVC animated:YES];
            [deviceAlarmVC release];
            
        }else{
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
        }
    }
}

/**
 *  修改之后，点击悬浮窗上的音量按钮
 */
- (void)operationAudio
{
    [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_operationAudio];
    /**
     *  判断是否开启语音对讲,开启直接返回
     */
    UIButton *btnTalk = [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];
    
    if (btnTalk.selected) {
        
        return;
    }
    
        JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        ystNetworkObj.ystNWADelegate    =  self;
        [self audioButtonClick];
}


/**
 *  音频监听功能（关闭）
 *
 *  @param bState YES:(对讲模式下)  NO：音频监听模式下
 */
-(void)audioButtonClick{
    
    OpenALBufferViewcontroller *openAlObj     = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    JVCCloudSEENetworkHelper           *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    /**
     *  如果是选中状态，置为非选中状态，如果是非选中状态，置为非选中状态
     */
    
    if ([_managerVideo getSingleViewVoiceBtnState]) {
        
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:-1];
        
        [openAlObj stopSound];
        [openAlObj cleanUpOpenALMath];
        
        [_managerVideo setSingleViewVoiceBtnSelect:NO];
        
        [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForNormalState:HORIZONTALBAR_AUDIO ];

        
    }else{
        
        [openAlObj initOpenAL];
        
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:-1];
        
        [_managerVideo setSingleViewVoiceBtnSelect:YES];

        
        [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForSelectState:HORIZONTALBAR_AUDIO ];
    }
}

#pragma mark ---------------JVCMangerVideoDelegate 

/**
 *  请求报警视频的远程回放的回调
 */
-(void)RemotePlayBackVideo{

    JVCCloudSEENetworkHelper  *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRPVDelegate           = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationCommand:JVN_CMD_PLAYSTOP];
        [ystNetWorkHelperObj RemoteRequestSendPlaybackVideo:_managerVideo.nSelectedChannelIndex+1 withPlayBackPath:self.strPlayBackVideoPath];
    });
}

/**
 *  远程回放检索的事件
 */
-(void)remotePlaybackClick {
    
    if (_isPlayBackVideo) {
        
        JVCRemoteVideoPlayBackVControler  *remoteVideoPlayBackVControler=[JVCRemoteVideoPlayBackVControler shareInstance];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:remoteVideoPlayBackVControler animated:NO];
        [remoteVideoPlayBackVControler tableViewReloadDate];
        
    }else{
        
        [self playBackSendPlayVideoDate:[NSDate date]];
    }
}

/**
 *  远程回放检索组合日期远程发送给设备
 *
 *  @param date 检索的日期
 */
-(void)playBackSendPlayVideoDate:(NSDate*)date{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSDateFormatter *formatter    = [[NSDateFormatter alloc] init];
        
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSCalendar       *calendar    = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSInteger         unitFlags   = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *comps       = [calendar components:unitFlags fromDate:date];
        
        int               year        = [comps year];
        int               month       = [comps month];
        int               day         = [comps day];
        
        DDLogVerbose(@"%d  %d    %d",year,month,day);
        
        NSString    *dateStr     = [[NSString alloc] initWithFormat:@"%04d%02d%02d000000%04d%02d%02d000000",year, month, day,year, month, day];
        
        [formatter  release];
        [calendar  release];
        
        //远程回放请求
        memset(&remoteSendSearchFileBuffer, 0, sizeof(remoteSendSearchFileBuffer));
        sprintf(remoteSendSearchFileBuffer, [dateStr UTF8String], sizeof(remoteSendSearchFileBuffer));
        
        JVCCloudSEENetworkHelper  *ystNetworkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetworkHelperObj.ystNWRPVDelegate           = self;
        
        [ystNetworkHelperObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:JVN_REQ_CHECK remoteOperationCommandData:remoteSendSearchFileBuffer nRequestCount:1];
        
        [dateStr release];
    
    });
}

/**
 *  接收远程回放检索的视频文件列表
 *
 *  @param playbackSearchFileListMArray 视频文件列表
 */
-(void)remoteplaybackSearchFileListInfoCallBack:(NSMutableArray *)playbackSearchFileListMArray{
    
    [self performSelectorOnMainThread:@selector(popRemoteVideoPlayBackVControlerWithData:) withObject:playbackSearchFileListMArray waitUntilDone:NO];
}

/**
 *  跳转到远程回放的列表界面，供用户选择要播放的远程回放列表
 *
 *  @param arrayList 远程回放列表
 */
- (void)popRemoteVideoPlayBackVControlerWithData:(NSMutableArray *)arrayList
{
    [arrayList retain];
    
    id viewController = [self.navigationController.viewControllers lastObject];
    
    if (![viewController isKindOfClass:[JVCRemoteVideoPlayBackVControler  class]]) {
        
        JVCRemoteVideoPlayBackVControler *remoteVideoPlayBackVControler=[JVCRemoteVideoPlayBackVControler shareInstance];
        remoteVideoPlayBackVControler.iSelectRow = -1;
        [remoteVideoPlayBackVControler.arrayDateList removeAllObjects];
        remoteVideoPlayBackVControler.remoteDelegat = self;
        [remoteVideoPlayBackVControler.arrayDateList addObjectsFromArray:arrayList];
        [remoteVideoPlayBackVControler tableViewReloadDate];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:remoteVideoPlayBackVControler animated:NO];
        
        
    }else{
        
//        //远程回放界面，可能点击音频监听以及录像按钮，所以要关闭
//        [self closeAudioAndTalkAndVideoFuction];
        
        JVCRemoteVideoPlayBackVControler *remoteVideoPlayBackVControler=(JVCRemoteVideoPlayBackVControler  *)viewController;
        [remoteVideoPlayBackVControler.arrayDateList removeAllObjects];
        [remoteVideoPlayBackVControler.arrayDateList addObjectsFromArray:arrayList];
        [remoteVideoPlayBackVControler tableViewReloadDate];
    }
    
    [arrayList release];
}
/**
 *  远程回调选中的一行的回调
 *
 *  @param dicInfo 字典数据（时间）
 *  @param date    时间（选中的哪天数）
 *  @param index   选中返回数据的哪一行（具体的时间，小时：分钟：秒）
 */
- (void)remotePlaybackVideoCallbackWithrequestPlayBackFileInfo:(NSMutableDictionary *)dicInfo  requestPlayBackFileDate:(NSDate *)date  requestPlayBackFileIndex:(int )index
{
   
    JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    
    id viewController = [self.navigationController.viewControllers lastObject];
    
    if ([viewController isKindOfClass:[JVCRemoteVideoPlayBackVControler class]]) {
        
        JVCRemoteVideoPlayBackVControler  *remoteVideoPlayBackVControler=(JVCRemoteVideoPlayBackVControler  *)viewController;
        
        [remoteVideoPlayBackVControler BackClick];
    }
    
    /**
     *  关闭音频监听、对讲、录像的功能
     */
    [self closeAudioAndTalkAndVideoFuction];
    
    [ystNetworkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationCommand:JVN_CMD_PLAYSTOP];
    
    
    [ystNetworkObj RemoteRequestSendPlaybackVideo:_managerVideo.nSelectedChannelIndex+1 requestPlayBackFileInfo:dicInfo requestPlayBackFileDate:date requestPlayBackFileIndex:index];
    
   
    /**
     *  当前状态为远程回放状态
     */
    _isPlayBackVideo = YES;
    
    [_splitViewBgClick setHidden:YES];
    [_managerVideo setScrollViewEnable:!_isPlayBackVideo];
    [_splitViewBtn setHidden:YES];
    self.navigationItem.title = NSLocalizedString(@"Play back", nil);
    [_bYTOBtn setEnabled:NO];
    [_bSoundBtn setEnabled:NO];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//
    
}
/**
 *  获取选中日期的回调
 *
 *  @param date 传入的日期
 */
- (void)remoteGetPlayBackDateWithSelectDate:(NSDate *)date;
{
    [self playBackSendPlayVideoDate:date];
}

/**
 *  远程回放状态回调
 *
 *  @param remoteplaybackState
 */
-(void)remoteplaybackState:(int)remoteplaybackState
{
    
    if (self.isPlayBackVideo) {
        
        switch (remoteplaybackState) {
                
            case RemotePlayBackVideoStateType_End:
            case RemotePlayBackVideoStateType_Stop:
            case RemotePlayBackVideoStateType_Failed:
            case RemotePlayBackVideoStateType_TimeOut:{
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [_managerVideo setCurrentSingleViewSlideToMaxNum];
                    [self BackClick];
                });
            }
                break;
            case RemotePlayBackVideoStateType_Succeed:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JVCMonitorConnectionSingleImageView  *_singView = (JVCMonitorConnectionSingleImageView*)[_managerVideo viewWithTag:KWINDOWSFLAG+_managerVideo.nSelectedChannelIndex];
                    [_singView hiddenSlider];
                    
                });
            }
                break;
                
            default:
                break;
        }
        
        return;
    
    }
    
    switch (remoteplaybackState) {
            
        case RemotePlayBackVideoStateType_End:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_managerVideo setCurrentSingleViewSlideToMaxNum];

                
                [self performSelector:@selector(remotePlayBackEndSuccess) withObject:nil afterDelay:kRemoteBackTimer];
                
            });
            
        }
            break;
        case RemotePlayBackVideoStateType_Stop:
        case RemotePlayBackVideoStateType_Failed:
        case RemotePlayBackVideoStateType_TimeOut:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self showPlayBackVideo:NO ];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"Playback_error")];
                
            });
        }
            break;
            
        case RemotePlayBackVideoStateType_Succeed:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                JVCMonitorConnectionSingleImageView  *_singView = (JVCMonitorConnectionSingleImageView*)[_managerVideo viewWithTag:KWINDOWSFLAG+_managerVideo.nSelectedChannelIndex];
                [_singView hiddenSlider];
            
            });
        }
            break;
            
        default:
            
            break;
    }
    
}

/**
 *  远程回放结束的时候执行，为了让进度条跑到最后面
 */
- (void)remotePlayBackEndSuccess{
    [self showPlayBackVideo:NO];
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"Playback_Finish")];
}

#pragma mark 远程回放界面操作 NO关闭 YES是开启
- (void)showPlayBackVideo:(bool)_isOpen{
    
    [_managerVideo setScrollViewEnable:!_isOpen];
    
    if (_isOpen) {
        
        [self changeManagePalyVideoComtrollerViewsToSingeView];
        [_splitViewBgClick setHidden:YES];
        [_splitViewBtn setHidden:YES];
        self.navigationItem.title = NSLocalizedString(@"Play back", nil);
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
        
        if ([JVCHorizontalScreenBar shareHorizontalBarInstance].bStateHorigin) {
            
            [JVCHorizontalScreenBar shareHorizontalBarInstance].hidden = NO;
        }
        _isPlayBackVideo = NO;
        
        [_splitViewBgClick setHidden:NO];
        [_splitViewBtn setHidden:NO];
        self.navigationItem.title = NSLocalizedString(@"Video Display", nil);
        [_bYTOBtn setEnabled:YES];
        [_bSoundBtn setEnabled:YES];
        CATransition *transition = [CATransition animation];
        transition.duration = 1.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        JVCMonitorConnectionSingleImageView  *_singView=(JVCMonitorConnectionSingleImageView*)[self.view viewWithTag:KWINDOWSFLAG+self._iSelectedChannelIndex];
        [_singView hiddenSlider];
        
        [self setAlarmTypeButton];
    }
}



#pragma mark 云台操作的回调

/**
 *  云台操作的回调
 *
 *  @param YTJVNtype 云台控制的命令
 */
- (void)YTOperationDelegateCallBackWithJVNYTCType:(int )YTJVNtype
{
    [ytOperationView showOperationTypeImageVIew:YTJVNtype];
    
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_YTO remoteOperationCommand:YTJVNtype];
    
    /**
     *  是否多屏，多屏的时候，变成单屏
     */
    [self changeManagePalyVideoComtrollerViewsToSingeView];
}

#pragma mark 点击4、9、16分屏的回调
/**
 *  点击4、9、16分屏的回调
 *
 *  @param screanNum 分屏num
 */
- (void)customCoverViewButtonCkickCallBack:(int)screanNum
{
    
    if (screanNum == SCREAN_ONE) {//点击的背景，关闭
        [self gotoShowSpltWindow];
    }else{
        
        [self changeSplitView:pow((screanNum+2),2)];
        
    }
}

#pragma mark 关闭音频监听、对讲、录像的功能

/**
 *  关闭音频监听、对讲、录像的功能
 */
- (void)closeAudioAndTalkAndVideoFuction
{
    
    [self performSelectorOnMainThread:@selector(reductionDefaultAudioAndTalkAndVideoBtnImage) withObject:nil waitUntilDone:YES];
    
}

/**
 *  还原特殊功能的默认状态
 */
-(void)reductionDefaultAudioAndTalkAndVideoBtnImage {
    
    
    [self stopTalkTimer];
    
    /**
     *  关闭录像
     */
    UIButton *btn = [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_VIDEO];//获取录像的按钮
    
    if (btn.selected) {
        
        btn.selected = NO;
        [self operationPlayVideo:btn.selected];
    }
    
    [self initwithRightButton:nil withTitle:nil];
    
    
    /**
     *  关闭音频监听
     */
    [self stopAudioMonitor];
    
    /**
     *  关闭对讲
     */
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [self closeChatVoiceIntercom];

    });
    
    [[JVCHorizontalScreenBar shareHorizontalBarInstance] setALlBtnNormal];
}


#pragma mark 开启本地录像
-(void)operationPlayVideo:(BOOL)buttonState{
    
    JVCCloudSEENetworkHelper *jvcCloudObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    jvcCloudObj.videoDelegate             = self;
    
    if (buttonState) {
        
        /**
         *  保存录像的回调
         */
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            if ([myerror.localizedDescription rangeOfString:NSLocalizedString(@"userDefine", nil)].location!=NSNotFound) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"pictureLibraynoAutor", nil)];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"picturelibrayError", nil)];
                });
                
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group,BOOL *stop){
            
            NSString *documentPaths = NSTemporaryDirectory();
            
            NSString *filePath = [documentPaths stringByAppendingPathComponent:(NSString *)kRecoedVideoFileName];
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
            }
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYYMMddHHmmssSSSS"];
            NSString *videoPath =[NSString stringWithFormat:@"%@/%@%@",filePath,[df stringFromDate:[NSDate date]],kRecoedVideoFileFormat];
            [df release];
            
            [_strSaveVideoPath  release];
            _strSaveVideoPath= nil;
            
            _strSaveVideoPath = [videoPath retain];
            
           [jvcCloudObj openRecordVideo:_managerVideo.nSelectedChannelIndex+1  saveLocalVideoPath:videoPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"operationStartVideoSuccess", nil)];
            });
            
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSUInteger groupTypes =ALAssetsGroupFaces;// ALAssetsGroupAlbum;// | ALAssetsGroupEvent | ALAssetsGroupFaces;
        [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureblock];
        
    }else{
        
        [jvcCloudObj stopRecordVideo:_managerVideo.nSelectedChannelIndex+1  withIsContinueVideo:NO];
    }
}

/**
 *   录像结束的回调函数
 *
 *  @param isContinue 是否结束后继续录像 YES：继续
 */
-(void)videoEndCallBack:(BOOL)isContinueVideo{
    
    DDLogVerbose(@"==%@=",_strSaveVideoPath);
    [self saveLocalVideo:_strSaveVideoPath];

    if (isContinueVideo) {
   
        [self operationPlayVideo:YES];
        
    }else{
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operationEndVideoSuccess")];
        });
        
    }
}

/**
 *  停止音频监听
 */
- (void)stopAudioMonitor
{

    if ([_managerVideo getSingleViewVoiceBtnState]) {
        
        JVCCloudSEENetworkHelper           *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        OpenALBufferViewcontroller *openAlObj             = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
        
        [ystNetworkObj  RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_AudioListening remoteOperationCommand:-1];
        
        [openAlObj stopSound];
        [openAlObj cleanUpOpenALMath];
        
        [_managerVideo setSingleViewVoiceBtnSelect:NO];

        [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForNormalState:HORIZONTALBAR_AUDIO];

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
    
    DDLogVerbose(@"%s------status=%d",__FUNCTION__,VoiceInterState);
    switch (VoiceInterState) {
            
        case VoiceInterStateType_Succeed:{
            
            [self performSelectorOnMainThread:@selector(OpenChatVoiceIntercom) withObject:self waitUntilDone:NO];
            
        }
            break;
        case VoiceInterStateType_End:{
            
            [self performSelectorOnMainThread:@selector(closeChatVoiceIntercom) withObject:self waitUntilDone:NO];
            
            
        }
            break;
            
        default:
            break;
    }
}

/**
 *  打开语音对讲
 */
- (void)OpenChatVoiceIntercom
{
    
    OpenALBufferViewcontroller *openAlObj       = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    [openAlObj initOpenAL];
    
    /**
     *  选中对讲button
     */
    [_operationItemSmallBg setbuttonSelectStateWithIndex:BUTTON_TYPE_TALK andSkinType:skinSelect];
    [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForSelectState:HORIZONTALBAR_TACK];

    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(isCurrentHomePC == TRUE ? @"talkingHomeIPC" : @"Intercom function has started successfully, speak to him please.", nil) ];
}

/**
 *  关闭对讲
 */
- (void)closeChatVoiceIntercom
{
    
    UIButton *talkBtn = [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];

   
    JVCCloudSEENetworkHelper        *ystNetWorkObj   = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    ystNetWorkObj.ystNWADelegate    = nil;
    
    //    id <ystNetWorkHelpDelegate>                      ystNWHDelegate;     //视频
    //    id <ystNetWorkHelpRemoteOperationDelegate>       ystNWRODelegate;    //远程请求操作
    //    id <ystNetWorkAudioDelegate>                     ystNWADelegate;     //音频
    //    id <ystNetWorkHelpRemotePlaybackVideoDelegate>   ystNWRPVDelegate;   //远程回放
    //    id <ystNetWorkHelpTextDataDelegate>              ystNWTDDelegate;    //文本聊天
    
    [ystNetWorkObj RemoteOperationSendDataToDevice:_managerVideo.nSelectedChannelIndex+1 remoteOperationType:RemoteOperationType_VoiceIntercom remoteOperationCommand:JVN_CMD_CHATSTOP];
    
    OpenALBufferViewcontroller *openAlObj       = [OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance];
    AQSController  *aqControllerobj = [AQSController shareAQSControllerobjInstance];
    
    [openAlObj stopSound];
    [openAlObj cleanUpOpenALMath];
    
    [aqControllerobj stopRecord];
    aqControllerobj.delegate = nil;
  

    dispatch_async(dispatch_get_main_queue(), ^{
    
        [_operationItemSmallBg setbuttonUnSelectWithIndex:BUTTON_TYPE_TALK];

    });
    
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
    
    if (!isLongPressedStartTalk) {
        
        [[OpenALBufferViewcontroller shareOpenALBufferViewcontrollerobjInstance] openAudioFromQueue:(short *)soundBuffer dataSize:soundBufferSize playSoundType:soundBufferType == YES ? playSoundType_8k16B : playSoundType_8k8B];
    }
}

/**
 *  判断是否打开远程配置
 *
 *  @return yes 打开  no 取消
 */
- (BOOL)judgeOpenVideoPlaying
{
    return [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] checknLocalChannelIsDisplayVideo:_managerVideo.nSelectedChannelIndex+1];
}

#pragma mark 是否多屏，多屏的时候，变成单屏
/**
 *  是否多屏，多屏的时候，变成单屏
 */
- (void)changeManagePalyVideoComtrollerViewsToSingeView
{
    
    if (_managerVideo.imageViewNums>1) {
        
        _managerVideo._iBigNumbers=_managerVideo.imageViewNums;
        _managerVideo.imageViewNums=1;
        _managerVideo.isShowVideo  = TRUE;
        [_managerVideo changeContenView];
        _managerVideo.isShowVideo  = FALSE;
    }
}


#pragma mark  横屏的回调

/**
 *  HorizontalScreenBar按钮按下的返回值
 *
 *  @param btn 传回相应的but
 */
- (void)HorizontalScreenBarBtnClickCallBack:(UIButton *)btn
{
    
    /**
     *  是否有画面
     */
    if (![self judgeOpenVideoPlaying] ) {
        
        return;
        
    }
    /**
     *  是否多屏，多屏的时候，变成单屏
     */
    [self changeManagePalyVideoComtrollerViewsToSingeView];
    
    //    HORIZONTALBAR_TACK          = 0,//对讲
    //    HORIZONTALBAR_CAPTURE       = 1,//拍照
    //    HORIZONTALBAR_VIDEO         = 2,//录像
    //    HORIZONTALBAR_AUDIO         = 3,//音频
    //    HORIZONTALBAR_RESTORE       = 4,//回放默认状态
    //    HORIZONTALBAR_ROTATION      = 5,//图片旋转
    //    HORIZONTALBAR_STREAM        = 6,//画质
    
    int switchCase = btn.tag - 232000;
    
    
    switch (switchCase) {
        case HORIZONTALBAR_TACK://对讲
        {
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }
            
            [self chatRequest:btn];
            
            /**
             *  长按
             */
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedStartTalk:)];
            [btn addGestureRecognizer:longPress];
            longPress.allowableMovement = NO;
            longPress.minimumPressDuration = 0.5;
            [longPress release];
        }
            
            break;
        case HORIZONTALBAR_CAPTURE:{//抓拍
            
            [self smallCaptureTouchUpInside:btn];
        }
            break;
        case HORIZONTALBAR_VIDEO://录像
        {
            if (!btn.isSelected) {
                
                [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForSelectState:HORIZONTALBAR_VIDEO];
                [_operationItemSmallBg setbuttonSelectStateWithIndex:BUTTON_TYPE_VIDEO andSkinType:0];
                
            }else{
                [[JVCHorizontalScreenBar shareHorizontalBarInstance] setBtnForNormalState:HORIZONTALBAR_VIDEO];
                [_operationItemSmallBg setbuttonUnSelectWithIndex:BUTTON_TYPE_VIDEO ];


            }
            
            [self  operationPlayVideo:btn.selected];
            
            
        }
            break;
        case  HORIZONTALBAR_AUDIO://音频
        {
            /**
             *  判断是否开启语音对讲,开启直接返回
             */
            UIButton *btnTalk = [_operationItemSmallBg getButtonWithIndex:BUTTON_TYPE_TALK];
            if (btnTalk.selected) {
                
                return;
            }
            
            JVCCloudSEENetworkHelper *ystNetworkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            ystNetworkObj.ystNWADelegate    =  self;
            
            [self audioButtonClick];
            
        }
            
            break;
        case HORIZONTALBAR_RESTORE://恢复到设备默认状态
        {
           
        }
            break;
        case HORIZONTALBAR_ROTATION://图像旋转
        {
//            if (iOperationEffectFlag == 4) {
//                
//                iOperationEffectFlag = 1;
//            }else{
//                
//                iOperationEffectFlag =4;
//            }
//            
//            [self sendEffectModel:iOperationEffectFlag];
        }
            
            break;
        case HORIZONTALBAR_STREAM://画质切换
        {
            //画质
            //远程回放时，屏蔽掉此功能
            if (_isPlayBackVideo ||self.isPlayBackVideo) {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"operation")];
                
                return;
            }
            
            [self setHorbarStreamView:btn];
            
        }
            break;
            //
        default:
            break;
    }
    
    
    //  [self addSetimgQualityView:btn];
}

- (void)setHorbarStreamView:(UIButton *)btn
{
    
    if (VideoStreamType_Default == nCurrentStreamType ||VideoStreamType_NoSupport == nCurrentStreamType) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"This video source doesn't support image resolution switch.")];
        return;
    }
    
    if(!horizonView)
    {
        horizonView = [[JVCHorizontalStreamView alloc] showHorizonStreamView:btn andSelectindex:nCurrentStreamType>0?nCurrentStreamType :0 streamCountType:[_managerVideo getCurrentIsOldHomeIPC]] ;
        horizonView.horStreamDelegate = self;
    }else{
        [self removeStreamView];
    }

}

//横屏的时候处理
- (void)removeStreamView
{
    
    if ( [JVCHorizontalScreenBar shareHorizontalBarInstance].hidden) {
        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        CGRect frame = streamView.frame;
//        frame.size.height = 0;
//        streamView.frame =frame;
//        [UIView commitAnimations];
//        [streamView removeFromSuperview];
//        [streamView release];
//        streamView = nil;
        
    }else{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGRect frame = horizonView.frame;
        frame.size.height = 0;
        horizonView.frame =frame;
        [UIView commitAnimations];
        [horizonView removeFromSuperview];
        [horizonView release];
        horizonView = nil;
    }
    
}

//选中那个按钮
- (void)horizontalStreamViewCallBack:(UIButton *)btn
{
    [self changeStreamViewCallBack:btn.tag];
    
}

@end
