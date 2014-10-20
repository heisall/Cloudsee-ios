//
//  JVCApConfigPlayVideoViewController.m
//  CloudSEE_II
//  ap配置视频观看界面
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCApConfigPlayVideoViewController.h"
#import "JVCDeviceMacro.h"
#import "JVCAPConfingMiddleIphone5.h"

@interface JVCApConfigPlayVideoViewController () {

    JVCMonitorConnectionSingleImageView *singleVideoShow;
    
    UIButton *nextBtn;
}

@end

@implementation JVCApConfigPlayVideoViewController
@synthesize strYstNumber;

static const int       kConnectDefaultLocalChannel   = 1;
static const int       kConnectDefaultRemoteChannel  = 1;
static NSString const *kConnectDefaultUsername       = @"jwifiApuser";
static NSString const *kConnectDefaultPassword       = @"^!^@#&1a**U";
static NSString const *kConnectDefaultIP             = @"10.10.0.1";
static const  int      kConnectDefaultPort           = 9101;
static const CGFloat   kNextButtonWithBottom         = 20.0f;
static const CGFloat   kNextButtonWithTop            = 20.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"视频检测";
        
    }
    
    return self;
}

-(void)dealloc{

    [strYstNumber release];
    [super dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayoutWithSingVidew];
    [self initLayoutWithNextButton];
    [self initLayoutWithOperationView];
    [self connectApDeviceWithVideo];
}

/**
 *  初始化视频显示窗口
 */
-(void)initLayoutWithSingVidew{
    
    singleVideoShow                   = [[JVCMonitorConnectionSingleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width/3*2)];
    
    singleVideoShow.layer.borderWidth = 1.0;
    [singleVideoShow unSelectUIView];
    singleVideoShow.singleViewType    = 1;
    singleVideoShow.wheelShowType     = 1;
    singleVideoShow.tag               = KWINDOWSFLAG;
    singleVideoShow.delegate          =  self;
    singleVideoShow.backgroundColor   = [UIColor blackColor];
    [singleVideoShow initWithView];
    [self.view addSubview:singleVideoShow];

}


/**
 *  初始化底部下一步按钮
 */
-(void)initLayoutWithNextButton{
    
    
    UIImage *nextBtnImage = [UIImage imageNamed:@"ap_playVideo_next.png"];
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    nextBtn.frame=CGRectMake((self.view.frame.size.width - nextBtnImage.size.width)/2.0,  self.view.frame.size.height - nextBtnImage.size.height - kNextButtonWithBottom,  nextBtnImage.size.width, nextBtnImage.size.height);
    [nextBtn setTitle:NSLocalizedString(@"apSetting_new_device_next", nil) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:nextBtnImage forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    [singleVideoShow release];
}

/**
 *  初始化中间功能按钮视图
 */
-(void)initLayoutWithOperationView{

    JVCAPConfingMiddleIphone5 *middleView = [JVCAPConfingMiddleIphone5 shareApConfigMiddleIphone5Instance];
    middleView.frame = CGRectMake(0, singleVideoShow.bottom, self.view.width ,nextBtn.origin.y - singleVideoShow.bottom -kNextButtonWithTop);
    middleView.delegateIphone5BtnCallBack = self;
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Audio", nil),NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"Playback", nil), nil];
    [middleView updateViewWithTitleArray:array detailArray:array];
    [self.view addSubview:middleView];
}

/**
 *  开始配置
 */
-(void)nextBtnClick{

    DDLogVerbose(@"%s---begin config",__FUNCTION__);

}

/**
 *  选中中间按钮的回调
 *
 *  @param clickBtnType btn的索引
 */
-  (void)operationMiddleIphone5APBtnCallBack:(int)clickBtnType
{
    DDLogVerbose(@"%s---%d",__FUNCTION__,clickBtnType);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark monitorConnectionSingleImageView delegate

-(void)connectVideoCallBack:(int)nShowWindowID{
    
    [self connectApDeviceWithVideo];
}

#pragma mark  ------------ ystNetWorkHelpDelegate

/**
 *  连接的回调代理
 *
 *  @param connectCallBackInfo 返回的连接信息
 *  @param nlocalChannel       本地通道连接从1开始
 *  @param connectType         连接返回的类型
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType{

    [connectCallBackInfo retain];
    
    [singleVideoShow connectResultShowInfo:connectCallBackInfo connectResultType:connectResultType];
    
    [connectCallBackInfo release];
}

/**
 *  OpenGL显示的视频回调函数
 *
 *  @param nLocalChannel             本地显示窗口的编号
 *  @param imageBufferY              YUV数据中的Y数据
 *  @param imageBufferU              YUV数据中的U数据
 *  @param imageBufferV              YUV数据中的V数据
 *  @param decoderFrameWidth         视频的宽
 *  @param decoderFrameHeight        视频的高
 *  @param nPlayBackFrametotalNumber 远程回放的总帧数
 */
-(void)H264VideoDataCallBackMath:(int)nLocalChannel imageBufferY:(char *)imageBufferY imageBufferU:(char *)imageBufferU imageBufferV:(char *)imageBufferV decoderFrameWidth:(int)decoderFrameWidth decoderFrameHeight:(int)decoderFrameHeight nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber{

    [singleVideoShow setImageBuffer:imageBufferY imageBufferU:imageBufferU imageBufferV:imageBufferV decoderFrameWidth:decoderFrameWidth decoderFrameHeight:decoderFrameHeight nPlayBackFrametotalNumber:nPlayBackFrametotalNumber];
}

/**
 *
 * 连接AP热点的设备
 *
 */
-(void)connectApDeviceWithVideo{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        ystNetWorkHelperObj.ystNWHDelegate                       =  self;
        BOOL                                 connectStatus       = [ystNetWorkHelperObj checknLocalChannelExistConnect:kConnectDefaultLocalChannel];
        
        NSString                        *connectInfo             = [NSString stringWithFormat:@"%@-%d",self.strYstNumber,kConnectDefaultRemoteChannel];
        
        //重复连接
        if (!connectStatus) {
            
            [singleVideoShow startActivity:connectInfo isConnectType:CONNECTTYPE_IP];
            
             connectStatus = [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:kConnectDefaultLocalChannel nRemoteChannel:kConnectDefaultRemoteChannel strUserName:(NSString *)kConnectDefaultUsername strPassWord:(NSString *)kConnectDefaultPassword strRemoteIP:(NSString *)kConnectDefaultIP nRemotePort:kConnectDefaultPort nSystemVersion:IOS_VERSION isConnectShowVideo:TRUE];
        }
        
    });
}


@end
