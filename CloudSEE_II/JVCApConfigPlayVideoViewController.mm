//
//  JVCApConfigPlayVideoViewController.m
//  CloudSEE_II
//  ap配置视频观看界面
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCApConfigPlayVideoViewController.h"
#import "JVCDeviceMacro.h"
#import "JVNetConst.h"
#import "JVCCustomOperationBottomView.h"
#import "JVCSystemUtility.h"
#import "JVCAlertHelper.h"

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
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
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
    NSArray *title = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Audio", nil),NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"Playback", nil), nil];
    
     NSArray *info = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Learn audio info at any time", nil),NSLocalizedString(@"Adjust PTZ at any time", nil),NSLocalizedString(@"AudioTalkInfo", nil), nil];
    
    [middleView updateViewWithTitleArray:title detailArray:info];
    [self.view addSubview:middleView];
}

/**
 *  开始配置
 */
-(void)nextBtnClick{
    
    DDLogVerbose(@"%s---begin config",__FUNCTION__);
    
    JVCCloudSEENetworkHelper *netWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    netWorkHelperObj.ystNWTDDelegate           = self;
    
    if ([[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSIDIsHomeIPC]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [netWorkHelperObj RemoteOperationSendDataToDevice:kConnectDefaultLocalChannel remoteOperationCommand:JVN_CMD_VIDEOPAUSE];
            
            [netWorkHelperObj RemoteOperationSendDataToDevice:kConnectDefaultLocalChannel remoteOperationType:TextChatType_NetWorkInfo remoteOperationCommand:-1];
            
        });
    }
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
    
    //如果在WIFI配置界面直接返回
    if (connectResultType != CONNECTRESULTTYPE_Succeed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if ([self checkApconfigDeviceIsExist]) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
        
    }
    
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
 *  视频来O帧之后请求文本聊天
 *
 *  @param nLocalChannel 本地显示的通道编号 需减去1
 */
-(void)RequestTextChatCallback:(int)nLocalChannel {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        if (singleVideoShow.nStreamType == VideoStreamType_Default) {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
            
        }else {
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
        }
        
    });
}

/**
 *  文本聊天请求的结果回调
 *
 *  @param nLocalChannel 本地本地显示窗口的编号
 *  @param nStatus       文本聊天的状态
 */
-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus{
    
    if (nStatus == JVN_RSP_TEXTACCEPT) {
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWRODelegate                      = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_paraInfo remoteOperationCommand:-1];
            
        });
    }
}

/**
 *  获取当前连接通道的码流参数
 *
 *  @param nLocalChannel 本地连接通道编号
 *  @param nStreamType     码流类型  1:高清 2：标清 3：流畅 0:默认不支持切换码流
 */
-(void)deviceWithFrameStatus:(int)nLocalChannel withStreamType:(int)nStreamType withIsHomeIPC:(BOOL)isHomeIPC{
    
    singleVideoShow.nStreamType                          = nStreamType;
    singleVideoShow.isHomeIPC                            = isHomeIPC;
    
    DDLogCVerbose(@"%s----nStreamType=%d",__FUNCTION__,nStreamType);
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

#pragma mark ---------  ystNetWorkHelpTextDataDelegate

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData{
    
    switch (nYstNetWorkHelpTextDataType) {
            
        case TextChatType_NetWorkInfo:{
        
               NSMutableDictionary *networkInfo = (NSMutableDictionary *)objYstNetWorkHelpSendData;
            
               if (networkInfo) {
    
                  [self gotoApConfigDevice:networkInfo];
               }
        }
            break;
        case TextChatType_ApList:{
            
            NSMutableArray *networkInfo = (NSMutableArray *)objYstNetWorkHelpSendData;
            
            [self refreshWifiListInfoCallBack:networkInfo];
            
        }
            break;
            
        case TextChatType_ApSetResult:{
            
            NSString *networkInfo = (NSString *)objYstNetWorkHelpSendData;
            
            [self apConfigDeviceWifiInfo:networkInfo.intValue];
            
        }
            break;
            
        default:
            break;
    }
    
    DDLogVerbose(@"%s----%@",__FUNCTION__,objYstNetWorkHelpSendData);

}

/**
 *  设置设备的无线网路
 *
 *  @param networkInfo 无线网络信息
 */
-(void)gotoApConfigDevice:(NSMutableDictionary *)networkInfo{
    
    [networkInfo retain];
    
    if (![self checkApconfigDeviceIsExist]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            JVCApConfigDeviceViewController *configDevice   = [[JVCApConfigDeviceViewController alloc] init];
            configDevice.delegate                               = self;
            [self.navigationController pushViewController:configDevice animated:YES];
            [configDevice release];
        
        });
    }
    
    [networkInfo release];
}

/**
 *  刷新无线网络的信息
 */
-(void)refreshWifiListInfoCallBack:(NSMutableArray *)ssidList{
    
    [ssidList retain];
    
    for (UIViewController *con in self.navigationController.viewControllers) {
        
        if ([con isKindOfClass:[JVCApConfigDeviceViewController class]]) {
            
            JVCApConfigDeviceViewController *apConfig = (JVCApConfigDeviceViewController *)con;
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                 [apConfig refreshWifiViewShowInfo:ssidList];
            
            });
        }
    }
    
    [ssidList release];
}

/**
 *  配置设备的无线的网络的返回值
 *
 *  @param nResult 收到回调配置结束弹出回调
 */
-(void)apConfigDeviceWifiInfo:(int)nResult{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self apConfigDisconnect];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //配置完成处理回到登陆界面
            [self configFinshed];
            
            DDLogVerbose(@"%s-----apConfigResult=%d",__FUNCTION__,nResult);
            [[JVCAlertHelper shareAlertHelper] alertWithMessage:NSLocalizedString(@"wifi-Successful", nil)];
            
        });
    });
}

#pragma mark -------------- 配置完成处理

/**
 *  断开当前的AP配置连接,不接收回调处理
 */
-(void)apConfigDisconnect{
    
    JVCCloudSEENetworkHelper *networkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    networkHelperObj.ystNWHDelegate            = nil;
    [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:kConnectDefaultLocalChannel];
}

/**
 *  配置完成处理
 */
-(void)configFinshed {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}


/**
 *  判断AP设置界面是否已经存在
 *
 *  @return YES：存在
 */
-(BOOL)checkApconfigDeviceIsExist {
    
    BOOL isCheck = NO;
    
    for (UIViewController *con in self.navigationController.viewControllers) {
        
        if ([con isKindOfClass:[JVCApConfigDeviceViewController class]]) {
            
            isCheck = YES;
        }
    }
    
    return isCheck;
}


#pragma mark --------  JVCApConfigDeviceViewControllerDelegate 获取设备的无线网络

/**
 *  获取设备的WIFI信息
 */
-(void)refreshWifiListInfo {
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWTDDelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:kConnectDefaultLocalChannel remoteOperationType:TextChatType_ApList remoteOperationCommand:-1];
        
    });
}

/**
 *  开始配置
 *
 *  @param strWifiEnc      wifi的加密方式
 *  @param strWifiAuth     wifi的认证方式
 *  @param strWifiSSid     配置WIFI的SSID名称
 *  @param strWifiPassWord 配置WIFi的密码
 */
-(void)runApSetting:(NSString *)strWifiEnc strWifiAuth:(NSString *)strWifiAuth strWifiSSid:(NSString *)strWifiSSid strWifiPassWord:(NSString *)strWifiPassWord {
    
    [strWifiEnc retain];
    [strWifiAuth retain];
    [strWifiSSid retain];
    [strWifiPassWord retain];
    
    JVCCloudSEENetworkHelper   *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWTDDelegate             = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [ystNetWorkHelperObj RemoteNewSetWiFINetwork:kConnectDefaultLocalChannel strSSIDName:strWifiSSid strSSIDPassWord:strWifiPassWord nWifiAuth:strWifiAuth.intValue nWifiEncrypt:strWifiEnc.intValue];
    
    });
    
    [strWifiSSid release];
    [strWifiPassWord release];
    [strWifiEnc release];
    [strWifiAuth release];
}




@end
