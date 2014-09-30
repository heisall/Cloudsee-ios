//
//  JVCCloudSEENetworkHelper.m
//  CloudSEE_II
//  和云视通网络库对接的中转助手类
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCCloudSEENetworkHelper.h"
#import "JVCCloudSEENetworkInterface.h"
#import "JVNetConst.h"
#import "JVCCloudSEENetworkGeneralHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCCloudSEESendGeneralHelper.h"
#import "JVCVideoDecoderHelper.h"
#import "JVCRemotePlayBackWithVideoDecoderHelper.h"

@interface JVCCloudSEENetworkHelper ()

/**
 *  云视通连接的回调函数
 *
 *  @param nLocalChannel    连接的本地通道号 从1开始
 *  @param uchType          连接的返回值
 *  @param pMsg             连接返回的信息
 */
void ConnectMessageCallBack(int nLocalChannel, unsigned char  uchType, char *pMsg);

/**
 *  云视通连接的视频回调函数
 *
 *  @param nLocalChannel    连接的本地通道号 从1开始
 *  @param uchType          视频数据类型（I、B、P等）
 *  @param pBuffer          H264 视频数据或音频数据
 *  @param nSize            视频数据大小
 *  @param nWidth           视频数据的宽
 *  @param nHeight          视频数据的高
 */
void VideoDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize,int nWidth,int nHeight);


/**
 *  文本聊天的回调函数
 *
 *  @param nLocalChannel   连接的本地通道号 从1开始
 *  @param uchType         文本聊天的数据类型
 *  @param pBuffer         文本聊天的数据
 *  @param nSize           文本聊天的数据大小
 */
void TextChatDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize);

/**
 *  语音对讲的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param uchType        音频数据数据类型
 *  @param pBuffer        音频数据
 *  @param nSize          音频数据大小
 */
void VoiceIntercomCallBack(int nLocalChannel, unsigned char uchType, char *pBuffer, int nSize);


/**
 *  远程回放检索文件的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param pBuffer        回放文件集合数据
 *  @param nSize          回放文件集合数据大小
 */
void RemoteplaybackSearchCallBack(int nLocalChannel,char *pBuffer, int nSize);


/**
 *  远程回放的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param uchType        远程连接的通道号 从1开始
 *  @param pBuffer        回放的音视频数据
 *  @param nSize          回放的音视频数据大小
 *  @param nWidth         回放的视频数据宽
 *  @param nHeight        回放的视频数据高
 *  @param nTotalFrame    回放的视频数据的总帧数
 */
void RemotePlaybackDataCallBack(int nLocalChannel, unsigned char uchType, char *pBuffer, int nSize, int nWidth, int nHeight, int nTotalFrame);

@end


@implementation JVCCloudSEENetworkHelper

@synthesize ystNWHDelegate;
@synthesize ystNWRODelegate;
@synthesize ystNWADelegate;
@synthesize ystNWRPVDelegate;
@synthesize ystNWTDDelegate;

#define       MOBILECHFLAG   @"MobileCH"

char          ppszPCMBuf[640] ={0};

char          encodeLocalRecordeData[1024]  = {0}; //语音对讲编码后的数据
char          remotePlaybackBuffer[64*1024] = {0}; //存放远程回放数据原始值
BOOL          isRequestTimeoutSecondFlag;          //远程请求用于跳出请求的标志位 TRUE  :跳出
BOOL          isRequestRunFlag;                    //远程请求用于正在请求的标志位 FALSE :执行结束

JVCCloudSEEManagerHelper *jvChannel[CONNECTMAXNUMS];


static JVCCloudSEENetworkHelper *jvcCloudSEENetworkHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCCloudSEENetworkHelper 单例
 */
+ (JVCCloudSEENetworkHelper *)shareJVCCloudSEENetworkHelper
{
    @synchronized(self)
    {
        if (jvcCloudSEENetworkHelper == nil) {
            
            jvcCloudSEENetworkHelper = [[self alloc] init ];
            
            JVC_RegisterCallBack(ConnectMessageCallBack,VideoDataCallBack,RemoteplaybackSearchCallBack,VoiceIntercomCallBack,TextChatDataCallBack,NULL,RemotePlaybackDataCallBack);
            
        }
        
        return jvcCloudSEENetworkHelper;
    }
    
    return jvcCloudSEENetworkHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcCloudSEENetworkHelper == nil) {
            
            jvcCloudSEENetworkHelper = [super allocWithZone:zone];
            
            return jvcCloudSEENetworkHelper;
            
        }
    }
    
    return nil;
}

/**
 *  返回当前窗口对应的 jvChannel数组中的下标索引
 *
 *  @param nLocalChannel jvChannel数组中的下标索引
 *
 *  @return jvChannel数组中的下标索引
 */
-(int)returnCurrentChannelBynLocalChannelID:(int)nLocalChannel{
    
    return (nLocalChannel -1) % CONNECTMAXNUMS;
    
}

/**
 *  返回当前nLocalChannel对应的显示窗口的编号
 *
 *  @param nLocalChannel 本地通道
 *
 *  @return nLocalChannel对应的显示窗口的编号
 */
-(int)returnCurrentChannelNShowWindowIDBynLocalChannel:(int)nLocalChannel{
    
    JVCCloudSEEManagerHelper *currentChannelObj   = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    int                nshowWindowNumber  = nLocalChannel;
    
    if ( currentChannelObj != nil ) {
        
        nshowWindowNumber  = currentChannelObj.nShowWindowID + 1;
    }
    
    return nshowWindowNumber;
}

/**
 *  检测当前窗口连接是否已存在
 *
 *  @param nLocalChannel nLocalChannel description
 *
 *  @return YES:存在 NO:不存在
 */
-(BOOL)checknLocalChannelExistConnect:(int)nLocalChannel {
    
    JVCCloudSEEManagerHelper *currentChannelObj = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if ( currentChannelObj != nil ) {
        
        if (nLocalChannel == currentChannelObj.nShowWindowID + 1) {
            
            return YES;
            
        }else {
            
            return FALSE;
        }
    }
    
    return FALSE ;
}

/**
 *  检测当前窗口视频是否已经显示
 *
 *  @param nLocalChannel nLocalChannel description
 *
 *  @return YES:存在 NO:不存在
 */
-(BOOL)checknLocalChannelIsDisplayVideo:(int)nLocalChannel {
    
    JVCCloudSEEManagerHelper *currentChannelObj   = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if ( currentChannelObj != nil ) {
        
        return currentChannelObj.isDisplayVideo;
    }
    
    return FALSE ;
}

/**
 *  根据本地通道号返回对应的JVCCloudSEEManagerHelper
 *
 *  @param nLocalChannel 本地通道号
 *
 *  @return 本地通道号返回对应的JVCCloudSEEManagerHelper
 */
-(JVCCloudSEEManagerHelper *)returnCurrentChannelBynLocalChannel:(int)nLocalChannel{
    
    int nJvchannelID = [self returnCurrentChannelBynLocalChannelID:nLocalChannel];
    
    return jvChannel [nJvchannelID];
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－远程连接功能模块

/**
 *   云视通连接视频的函数 (子线程调用)
 *
 *  @param nLocalChannel  本地连接的通道号 >=1
 *  @param nRemoteChannel 连接设备的通道号
 *  @param strYstNumber   设备的云视通号
 *  @param strUserName    连接设备通道的用户名
 *  @param strPassWord    连接设备通道的密码
 *  @param nSystemVersion 当前手机的操作系统版本
 *
 *  @return 成功返回YES  重复连接返回NO
 */
-(BOOL)ystConnectVideobyDeviceInfo:(int)nLocalChannel nRemoteChannel:(int)nRemoteChannel strYstNumber:(NSString *)strYstNumber strUserName:(NSString *)strUserName strPassWord:(NSString *)strPassWord nSystemVersion:(int)nSystemVersion{
    
    
    JVCCloudSEEManagerHelper *currentChannelObj        = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    int               nJvchannelID             = [self returnCurrentChannelBynLocalChannelID:nLocalChannel];
    int               nJVCCloudSEEManagerHelper        = nJvchannelID+1;
    
    if (currentChannelObj  == nil || currentChannelObj.nShowWindowID != nLocalChannel -1 ) {
        
        if (currentChannelObj != nil && currentChannelObj.nShowWindowID != nLocalChannel -1 ) {
            
            DDLogVerbose(@"%s---%@---channelID=%d",__FUNCTION__,currentChannelObj,currentChannelObj.nShowWindowID);
            
            [self disconnect:nJVCCloudSEEManagerHelper];
            
        }
        
        int             nYstNumber             = -1 ;
        
        NSString *strYstGroup ;
        
        [[JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper] getYstGroupStrAndYstNumberByYstNumberString:strYstNumber.uppercaseString strYstgroup:&strYstGroup nYstNumber:&nYstNumber];
        
        
        jvChannel [nJvchannelID]               = [[JVCCloudSEEManagerHelper alloc] init];
        
        JVCCloudSEEManagerHelper *newCurrentChannelObj = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
        
        newCurrentChannelObj.jvConnectDelegate = self;
        newCurrentChannelObj.nLocalChannel     = nJVCCloudSEEManagerHelper;
        newCurrentChannelObj.nRemoteChannel    = nRemoteChannel;
        newCurrentChannelObj.linkModel         = NO;
        newCurrentChannelObj.strYstGroup       = strYstGroup;
        newCurrentChannelObj.nYstNumber        = nYstNumber;
        newCurrentChannelObj.strUserName       = strUserName;
        newCurrentChannelObj.strPassWord       = strPassWord;
        newCurrentChannelObj.nShowWindowID     = nLocalChannel -1;
        newCurrentChannelObj.nSystemVersion    = nSystemVersion;
        
        [newCurrentChannelObj connectWork];
        
        return TRUE;
        
    }else {
        
        DDLogCWarn(@"%s---- （%d）连接已存在",__FUNCTION__,nLocalChannel);
        
        return FALSE;
        
    }
}

/**
 *  IP连接视频的函数 (子线程调用)
 *
 *  @param nLocalChannel  本地连接的通道号 >=1
 *  @param strUserName    连接设备通道的用户名
 *  @param strPassWord    连接设备通道的密码
 *  @param strRemoteIP    IP直连的IP地址
 *  @param nRemotePort    IP直连的端口号
 *  @param nSystemVersion 当前手机的操作系统版本
 *
 *  @return  @return 成功返回YES  重复连接返回NO
 */
-(BOOL)ipConnectVideobyDeviceInfo:(int)nLocalChannel nRemoteChannel:(int)nRemoteChannel  strUserName:(NSString *)strUserName strPassWord:(NSString *)strPassWord strRemoteIP:(NSString *)strRemoteIP nRemotePort:(int)nRemotePort
                   nSystemVersion:(int)nSystemVersion{
    
    
    JVCCloudSEEManagerHelper *currentChannelObj        = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    int               nJvchannelID             = [self returnCurrentChannelBynLocalChannelID:nLocalChannel];
    int               nJVCCloudSEEManagerHelper        = nJvchannelID+1;
    
    if ( currentChannelObj  == nil || currentChannelObj.nShowWindowID != nLocalChannel -1 ) {
        
        if ( currentChannelObj != nil && currentChannelObj.nShowWindowID != nLocalChannel -1 ) {
            
            [self disconnect:nJVCCloudSEEManagerHelper];
            
        }
        
        jvChannel [nJvchannelID]                = [[JVCCloudSEEManagerHelper alloc] init];
        
        JVCCloudSEEManagerHelper *newCurrentChannelObj  = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
        newCurrentChannelObj.jvConnectDelegate = self;
        newCurrentChannelObj.nLocalChannel      = nJVCCloudSEEManagerHelper;
        newCurrentChannelObj.nRemoteChannel     = nRemoteChannel;
        newCurrentChannelObj.strRemoteIP        = strRemoteIP;
        newCurrentChannelObj.nRemotePort        = nRemotePort;
        newCurrentChannelObj.linkModel          = YES;
        newCurrentChannelObj.strUserName        = strUserName;
        newCurrentChannelObj.strPassWord        = strPassWord;
        newCurrentChannelObj.nShowWindowID      = nLocalChannel -1;
        newCurrentChannelObj.nSystemVersion     =nSystemVersion;
        
        [newCurrentChannelObj connectWork];
        
        return TRUE;
        
    }else {
        
        DDLogCWarn(@"%s---- （%d）连接已存在",__FUNCTION__,nLocalChannel);
        
        return FALSE;
        
    }
}

#pragma mark  断开连接

/**
 *  断开连接（子线程调用）
 *
 *  @param nLocalChannel 本地视频窗口编号
 *
 *  @return YSE:断开成功 NO:断开失败
 */
-(BOOL)disconnect:(int)nLocalChannel{
    
    JVCCloudSEEManagerHelper *currentChannelObj   = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if (currentChannelObj  != nil) {
        
        currentChannelObj.isRunDisconnect = YES;
        //断开远程连接
        [currentChannelObj disconnect];
        
        int nJvchannelID = nLocalChannel -1;
        
        while (true) {
            
            if (jvChannel[nJvchannelID] != nil) {
                
                usleep(500);
                
            }else{
                
                break;
            }
        }
        
        return YES;
    }
    
    return YES;
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－视频连接的回调处理

/**
 *  云视通连接的回调函数
 *
 *  @param nLocalChannel    连接的本地通道号 从1开始
 *  @param uchType          连接的返回值
 *  @param pMsg             连接返回的信息
 */
void ConnectMessageCallBack(int nLocalChannel, unsigned char  uchType, char *pMsg){
    
    if (pMsg==NULL||pMsg==nil) {
        
        pMsg="";
    }
    
    NSString *connectResultInfo=[[NSString alloc] initWithCString:pMsg encoding:NSUTF8StringEncoding];
    DDLogCWarn(@"%s--connectType=%d,connectInfo=%@,nlcalChannel=%d",__FUNCTION__,uchType,connectResultInfo,nLocalChannel);
    [jvcCloudSEENetworkHelper runConnectMessageCallBackMath:connectResultInfo nLocalChannel:nLocalChannel connectResultType:uchType];
    
    [connectResultInfo release];
}

/**
 *  C函数与UI层桥接的返回回调
 *
 *  @param connectCallBackInfo 连接的返回信息
 *  @param nlocalChannel       连接返回的本地通道
 *  @param connectResultType   连接的返回类型
 */
-(void)runConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType{
    
    [connectCallBackInfo retain];
    
    
    int               nJvchannelID       = [self returnCurrentChannelBynLocalChannelID:nlocalChannel];
    
    int               nshowWindowNumber  = [self returnCurrentChannelNShowWindowIDBynLocalChannel:nlocalChannel];
    
    if (self.ystNWHDelegate != nil && [self.ystNWHDelegate respondsToSelector:@selector(ConnectMessageCallBackMath:nLocalChannel:connectResultType:)]) {
        
        [[JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper] getConnectFailedDetailedInfoByConnectResultInfo:connectCallBackInfo conenctResultType:&connectResultType];
        
        [self.ystNWHDelegate ConnectMessageCallBackMath:connectCallBackInfo nLocalChannel:nshowWindowNumber connectResultType:connectResultType];
    }
    
    if (CONNECTRESULTTYPE_Succeed != connectResultType) {
        
        if (jvChannel[nJvchannelID] != nil) {
            
            [jvChannel[nJvchannelID] closeVideoDecoder];
            [jvChannel[nJvchannelID] exitQueue];
            
            [jvChannel[nJvchannelID] release];
            jvChannel[nJvchannelID]=nil;
        }
    }
    
    [connectCallBackInfo release];
}

#pragma mark  视频数据的回调函数

/**
 *  云视通连接的视频回调函数
 *
 *  @param nLocalChannel    连接的本地通道号 从1开始
 *  @param uchType          视频数据类型（I、B、P等）
 *  @param pBuffer          H264 视频数据或音频数据
 *  @param nSize            视频数据大小
 *  @param nWidth           视频数据的宽
 *  @param nHeight          视频数据的高
 */
void VideoDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize,int nWidth,int nHeight){
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    JVCCloudSEENetworkGeneralHelper *ystNetworkHelperCMObj = [JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper];
    JVCCloudSEEManagerHelper                    *currentChannelObj     = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    JVCVideoDecoderHelper                        *JVCVideoDecoderHelperObj       = currentChannelObj.decodeModelObj;
    JVCRemotePlayBackWithVideoDecoderHelper                *playBackDecoderObj    = currentChannelObj.playBackDecoderObj;
    
    
    if (currentChannelObj.isRunDisconnect) {
        
        [pool release];
        return;
    }
    
    switch (uchType) {
            
        case JVN_DATA_O:{
            
            if (pBuffer[0]!=0) {
                
                [pool release];
                return;
            }
            
            //NSLog(@"%s----VideoDataCallBack O_frmame",__FUNCTION__);
            
            int startCode   = -1;
            int width       = -1;
            int height      = -1;
            int nAudioType  = 0;
            
            //获取startCode 、宽、高
            [ystNetworkHelperCMObj getBufferOInInfo:pBuffer startCode:&startCode videoWidth:&width videoHeight:&height];
            
            currentChannelObj.nConnectDeviceType = [ystNetworkHelperCMObj checkConnectDeviceModel:startCode];
            
            currentChannelObj.nConnectStartCode  =  startCode;
            
            if (width != JVCVideoDecoderHelperObj.nVideoWidth || height != JVCVideoDecoderHelperObj.nVideoHeight) {
                
                /**
                 *  处理解码器对象
                 */
                JVCVideoDecoderHelperObj.nVideoWidth          = width;
                JVCVideoDecoderHelperObj.nVideoHeight         = height;
                
                JVCVideoDecoderHelperObj.dVideoframeFrate     = [ystNetworkHelperCMObj getPlayVideoframeFrate:startCode buffer_O:pBuffer buffer_O_size:nSize nAudioType:&nAudioType];
                
                JVCVideoDecoderHelperObj.isDecoderModel       = [ystNetworkHelperCMObj checkConnectDeviceEncodModel:startCode];
                
                JVCVideoDecoderHelperObj.isExistStartCode     = [ystNetworkHelperCMObj checkConnectVideoInExistStartCode:startCode buffer_O:pBuffer buffer_O_size:nSize];
                
                [currentChannelObj setAudioType:nAudioType];
                
                playBackDecoderObj.isDecoderModel    = JVCVideoDecoderHelperObj.isDecoderModel;
                playBackDecoderObj.isExistStartCode  = JVCVideoDecoderHelperObj.isExistStartCode;
                
                [currentChannelObj resetVideoDecoderParam];
            }
            [currentChannelObj startPopVideoDataThread];
        }
            break;
        case JVN_DATA_I:
        case JVN_DATA_B:
        case JVN_DATA_P:{
            
            if (currentChannelObj.isPlaybackVideo) {
                
                [pool release];
                return;
            }
            
            BOOL               isH264Data         = [ystNetworkHelperCMObj checkVideoDataIsH264:pBuffer];
            
            [currentChannelObj openVideoDecoder];
            
            if (isH264Data) {
                
                int bufferType = uchType;
                
                if (jvcCloudSEENetworkHelper.ystNWHDelegate != nil && [jvcCloudSEENetworkHelper.ystNWHDelegate respondsToSelector:@selector(H264VideoDataCallBackMath:imageBufferY:imageBufferU:imageBufferV:decoderFrameWidth:decoderFrameHeight:nPlayBackFrametotalNumber:)]) {
                    
                    //偏移带帧头的数据和视频数据的大小以及获取当前的帧类型
                    [jvcCloudSEENetworkHelper videoDataInExistStartCode:&pBuffer isFrameOStartCode:JVCVideoDecoderHelperObj.isExistStartCode nbufferSize:&nSize nBufferType:&bufferType];
                    
                    [currentChannelObj pushVideoData:(unsigned char *)pBuffer nVideoDataSize:nSize isVideoDataIFrame:bufferType==JVN_DATA_I isVideoDataBFrame:bufferType == JVN_DATA_B];
                    
                    //DDLogCInfo(@"%s---video",__FUNCTION__);
                    
                }else{
                    
                    DDLogCVerbose(@"%s---H264VideoDataCallBackMath:imageBufferY:imageBufferU:imageBufferV:decoderFrameWidth:decoderFrameHeight:nPlayBackFrametotalNumber: callBack is Null",__FUNCTION__);
                }
            }
        }
            break;
        case JVN_DATA_A:{
            
            //DDLogCInfo(@"%s---chenzhenyangA",__FUNCTION__);
            if (!currentChannelObj.isAudioListening) {
                
                [pool release];
                return;
            }
            
            [currentChannelObj pushAudioData:(unsigned char *)pBuffer nAudioDataSize:nSize];
        }
            break;
            
        default:
            break;
    }
    
    [pool release];
}

/**
 *  开启录像
 *
 *  @param nLocalChannel      连接的本地通道号
 *  @param saveLocalVideoPath 录像文件存放的地址
 */
-(void)openRecordVideo:(int)nLocalChannel saveLocalVideoPath:(NSString *)saveLocalVideoPath{
    
    JVCCloudSEEManagerHelper  *currentChannelObj = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    [currentChannelObj retain];
    [saveLocalVideoPath retain];
    
    if (currentChannelObj == nil) {
        
        DDLogVerbose(@"%s---JVCCloudSEEManagerHelper(%d) is null",__FUNCTION__,nLocalChannel);
        
        return;
    }
    [currentChannelObj openRecordVideo:saveLocalVideoPath];
    
    [saveLocalVideoPath release];
    [currentChannelObj release];
}

/**
 *  关闭本地录像
 *
 *  @param nLocalChannel 本地连接的通道地址
 */
-(void)stopRecordVideo:(int)nLocalChannel{
    
    JVCCloudSEEManagerHelper  *currentChannelObj = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    [currentChannelObj retain];
    
    if (currentChannelObj == nil) {
        
        DDLogVerbose(@"%s---JVCCloudSEEManagerHelper(%d) is null",__FUNCTION__,nLocalChannel);
        
        return;
    }
    [currentChannelObj stopRecordVideo];
    
    [currentChannelObj release];
}

#pragma mark VideoDataCallBack 逻辑处理模块

/**
 *  判断视频数据是否包含帧头
 *
 *  @param videoBuffer       视频数据
 *  @param isFrameOStartCode O帧是否带帧头
 */
-(void)videoDataInExistStartCode:(char **)videoBuffer isFrameOStartCode:(int)isFrameOStartCode  nbufferSize:(int *)nbufferSize nBufferType:(int *)nBufferType{
    
    
    JVCCloudSEENetworkGeneralHelper *ystNetworkHelperCMObj = [JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper];
    
    char                                 *videdata              = *videoBuffer;
    
    int                                   bufferSize            = *nbufferSize;
    int                                   bufferType            = *nBufferType;
    
    if (! isFrameOStartCode || [ystNetworkHelperCMObj isKindOfBufInStartCode:videdata]) {
        
        if (!isFrameOStartCode ) {
            
            JVS_FRAME_HEADER *jvs_header = (JVS_FRAME_HEADER*)videdata;
            
            bufferSize = jvs_header->nFrameLens;
            bufferType = jvs_header->nFrameType;
            
        }else{
            
            bufferSize = bufferSize-8;
            
        }
        
        videdata   = videdata + 8;
    }
    
    *videoBuffer  = videdata;
    *nbufferSize  = bufferSize;
    *nBufferType  = bufferType;
}

#pragma mark 远程控制

/**
 *  远程控制指令
 *
 *  @param nLocalChannel          视频显示的窗口编号
 *  @param remoteOperationCommand 控制的命令
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationCommand:(int)remoteOperationCommand{
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper         *currentChannelObj           = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if (currentChannelObj == nil) {
        
        DDLogVerbose(@"%s---JVCCloudSEEManagerHelper(%d) is Null",__FUNCTION__,currentChannelObj.nLocalChannel-1);
        
        return;
    }
    switch (remoteOperationCommand) {
            
        case JVN_RSP_PLAYOVER:{
            
            [self RemotePlayBackVideoEndCallBack:remoteOperationCommand currentChannelObj:currentChannelObj];
            return;
        }
            break;
            
        default:
            break;
    }
    
    [ystRemoteOperationHelperObj RemoteOperationSendDataToDevice:currentChannelObj.nLocalChannel remoteOperationCommand:remoteOperationCommand];
}

/**
 *  远程控制指令
 *
 *  @param nLocalChannel          控制本地连接的通道号
 *  @param remoteOperationType    控制的类型
 *  @param remoteOperationCommand 控制的命令
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationType:(int)remoteOperationType remoteOperationCommand:(int)remoteOperationCommand {
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper     *currentChannelObj           = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    
    if (currentChannelObj == nil) {
        
        DDLogVerbose(@"%s---JVCCloudSEEManagerHelper(%d) is Null",__FUNCTION__,currentChannelObj.nLocalChannel-1);
        
        return;
    }
    
    switch (remoteOperationType) {
            
        case RemoteOperationType_CaptureImage:{
            
            [currentChannelObj startWithCaptureImage];
        }
            break;
        case RemoteOperationType_AudioListening:{
            
            if (currentChannelObj.isAudioListening) {
                
                [currentChannelObj closeAudioDecoder];
                
            }else{
                
                [currentChannelObj openAudioDecoder];
            }
        }
        case RemoteOperationType_VoiceIntercom:{
            
            [ystRemoteOperationHelperObj onlySendRemoteOperation:currentChannelObj.nLocalChannel remoteOperationType:remoteOperationType remoteOperationCommand:remoteOperationCommand];
            
            if (remoteOperationCommand == JVN_CMD_CHATSTOP) {
                
                [self returnVoiceIntercomCallBack:currentChannelObj nVoiceInterStateType:VoiceInterStateType_End];
            }
            
        }
            break;
        case RemoteOperationType_YTO:
        case RemoteOperationType_RemotePlaybackSEEK:
        case TextChatType_NetWorkInfo:
        case TextChatType_paraInfo:
        case TextChatType_ApList:
        case TextChatType_ApSetResult:{
            
            [ystRemoteOperationHelperObj onlySendRemoteOperation:currentChannelObj.nLocalChannel remoteOperationType:remoteOperationType remoteOperationCommand:remoteOperationCommand];
        }
            break;
            
        case RemoteOperationType_TextChat:{
            
            [ystRemoteOperationHelperObj onlySendRemoteOperation:currentChannelObj.nLocalChannel remoteOperationType:remoteOperationType remoteOperationCommand:remoteOperationCommand];
            
        }
            break;
        default:
            break;
    }
}

/**
 *  远程控制指令
 *
 *  @param nLocalChannel              视频显示的窗口编号
 *  @param remoteOperationType        控制的类型
 *  @param remoteOperationCommandData 控制的指令内容
 *  @param nRequestCount              请求的次数
 */
-(void)RemoteOperationSendDataToDevice:(int)nLocalChannel remoteOperationType:(int)remoteOperationType remoteOperationCommandData:(char *)remoteOperationCommandData nRequestCount:(int)nRequestCount{
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper         *currentChannelObj           = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if (currentChannelObj == nil) {
        
        DDLogVerbose(@"%s---JVCCloudSEEManagerHelper(%d) is Null",__FUNCTION__,currentChannelObj.nLocalChannel-1);
        
        return;
    }
    
    while (isRequestRunFlag) {
        
        isRequestTimeoutSecondFlag = FALSE;
        usleep(500);
    }
    
    BOOL                      isTimeout       = FALSE;  //超时次数启用的标志位 YES:超时返回
    isRequestTimeoutSecondFlag                = TRUE;   //网路库返回结果跳出While 循环的标志 FALSE:跳出
    isRequestRunFlag                          = TRUE;
    
    while ( true ) {
        
        DDLogVerbose(@"%s-------runRequestCount=%d",__FUNCTION__,nRequestCount);
        
        if (!isRequestTimeoutSecondFlag) {
            
            DDLogVerbose(@"%s-------isRequestTimeoutSecondFlag =FALSE ",__FUNCTION__);
            break;
        }
        
        if (nRequestCount > 0 ) {
            
            [ystRemoteOperationHelperObj remoteSendDataToDevice:currentChannelObj.nLocalChannel remoteOperationType:remoteOperationType remoteOperationCommandData:remoteOperationCommandData];
            
        }else {
            
            DDLogVerbose(@"%s-------runRequestCount break=%d",__FUNCTION__,nRequestCount);
            isTimeout =TRUE;
            break;
        }
        
        nRequestCount --;
        usleep(REQUESTTIMEOUTSECOND*1000*1000);
    }
    
    isRequestRunFlag = FALSE;
    
    if (isTimeout) {
        
        if (jvcCloudSEENetworkHelper.ystNWRPVDelegate != nil && [jvcCloudSEENetworkHelper.ystNWRPVDelegate respondsToSelector:@selector(remoteplaybackSearchFileListInfoCallBack:)]) {
            
            [jvcCloudSEENetworkHelper.ystNWRPVDelegate remoteplaybackSearchFileListInfoCallBack:nil];
        }
    }
}

#pragma mark -----------------------------------------------------------－－－－－－－－语音对讲功能模块
/**
 *  语音对讲的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param uchType        音频数据数据类型
 *  @param pBuffer        音频数据
 *  @param nSize          音频数据大小
 */
void VoiceIntercomCallBack(int nLocalChannel, unsigned char uchType, char *pBuffer, int nSize){
    
    JVCCloudSEEManagerHelper  *currentChannelObj = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    switch(uchType)
	{
        case JVN_REQ_CHAT:
            break;
            
        case JVN_RSP_CHATACCEPT:{
            
            int nAudioBit                 = 0;
            int nAudioCollectionDataSize  = 0;
            
            BOOL isResult=[currentChannelObj getAudioCollectionBitAndDataSize:&nAudioBit nAudioCollectionDataSize:&nAudioCollectionDataSize];
            
            [jvcCloudSEENetworkHelper returnVoiceIntercomCallBack:currentChannelObj nVoiceInterStateType:VoiceInterStateType_Succeed];
            
            if (isResult) {
                
                if (jvcCloudSEENetworkHelper.ystNWADelegate !=nil && [jvcCloudSEENetworkHelper.ystNWADelegate respondsToSelector:@selector(OpenAudioCollectionCallBack:nAudioCollectionDataSize:)]) {
                    
                    [jvcCloudSEENetworkHelper.ystNWADelegate OpenAudioCollectionCallBack:nAudioBit nAudioCollectionDataSize:nAudioCollectionDataSize];
                }
            }
        }
            break;
            
        case JVN_CMD_CHATSTOP://"终止语音"
            
            [jvcCloudSEENetworkHelper returnVoiceIntercomCallBack:currentChannelObj nVoiceInterStateType:VoiceInterStateType_End];
            
            break;
        case JVN_RSP_CHATDATA:{
            
            if (!currentChannelObj.isVoiceIntercom) {
                
                return;
            }
            
            [currentChannelObj pushAudioData:(unsigned char *)pBuffer nAudioDataSize:nSize];
            
        }
        default:
            break;
	}
}

/**
 *  远程发送音频数据（对讲）
 *
 *  @param nLocalChannel 视频显示的窗口编号
 *  @param Audiodata     音频数据
 */
-(void)RemoteSendAudioDataToDevice:(int)nLocalChannel Audiodata:(char *)Audiodata nAudiodataSize:(int)nAudiodataSize{
    
   JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper        *currentChannelObj           = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if (currentChannelObj == nil) {
        DDLogVerbose(@"%s----error 009--- currentChannelObj is Null ",__FUNCTION__);
        return;
    }
    
    BOOL isEncoderSuccessFul = [currentChannelObj encoderLocalRecorderData:Audiodata nEncodeAudioOutdataSize:&nAudiodataSize encodeOutAudioData:encodeLocalRecordeData];
    
    if (isEncoderSuccessFul) {
        
        [ystRemoteOperationHelperObj SendAudioDataToDevice:currentChannelObj.nLocalChannel Audiodata:(char *)encodeLocalRecordeData AudiodataSize:nAudiodataSize];
    }
}

/**
 *  语音对讲回调处理
 *
 *  @param currentChannelObj    连接本地通道的对象
 *  @param nVoiceInterStateType 返回的类型
 */
-(void)returnVoiceIntercomCallBack:(JVCCloudSEEManagerHelper *)currentChannelObj nVoiceInterStateType:(int)nVoiceInterStateType{
    
    [currentChannelObj retain];
    
    if (!currentChannelObj.isVoiceIntercom) {
        
        [currentChannelObj openVoiceIntercomDecoder];
        
    }else{
        
        [currentChannelObj closeVoiceIntercomDecoder];
    }
    
    if (self.ystNWADelegate !=nil && [self.ystNWADelegate respondsToSelector:@selector(VoiceInterComCallBack:)]) {
        
        [self.ystNWADelegate VoiceInterComCallBack:nVoiceInterStateType];
    }
    
    [currentChannelObj release];
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－远程回放检索处理模块

/**
 *  远程回放检索文件的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param pBuffer        回放文件集合数据
 *  @param nSize          回放文件集合数据大小
 */
void RemoteplaybackSearchCallBack(int nLocalChannel,char *pBuffer, int nSize) {
    
    JVCCloudSEEManagerHelper  *currentChannelObj           = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    if (currentChannelObj == nil) {
        
        return;
    }
    
    if (jvcCloudSEENetworkHelper.ystNWRPVDelegate != nil && [jvcCloudSEENetworkHelper.ystNWRPVDelegate respondsToSelector:@selector(remoteplaybackSearchFileListInfoCallBack:)]) {
        
        NSMutableArray   *mArrayRemotePlaybackFileList = [[NSMutableArray alloc] initWithCapacity:10];
        
        NSMutableArray *serachPlayBackListData = [currentChannelObj getRemoteplaybackSearchFileListInfoByNetworkBuffer:pBuffer remotePlaybackFileBufferSize:nSize];
        
        [serachPlayBackListData retain];
        [mArrayRemotePlaybackFileList addObjectsFromArray:serachPlayBackListData];
        [serachPlayBackListData release];
        
        [jvcCloudSEENetworkHelper.ystNWRPVDelegate remoteplaybackSearchFileListInfoCallBack:mArrayRemotePlaybackFileList];
        
        [mArrayRemotePlaybackFileList release];
    }
    
    isRequestTimeoutSecondFlag = FALSE;
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－--远程回放处理模块

/**
 *  远程回放的回调函数
 *
 *  @param nLocalChannel  连接的本地通道号 从1开始
 *  @param uchType        远程连接的通道号 从1开始
 *  @param pBuffer        回放的音视频数据
 *  @param nSize          回放的音视频数据大小
 *  @param nWidth         回放的视频数据宽
 *  @param nHeight        回放的视频数据高
 *  @param nTotalFrame    回放的视频数据的总帧数
 */
void RemotePlaybackDataCallBack(int nLocalChannel, unsigned char uchType, char *pBuffer, int nSize, int nWidth, int nHeight, int nTotalFrame) {
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    JVCCloudSEENetworkGeneralHelper *ystNetworkHelperCMObj = [JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper];
    JVCCloudSEEManagerHelper                    *currentChannelObj     = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    JVCRemotePlayBackWithVideoDecoderHelper                *playBackDecoderObj    = currentChannelObj.playBackDecoderObj;
    
    if (currentChannelObj.isRunDisconnect) {
        
        [pool release];
        return;
    }
    
    switch (uchType) {
            
        case JVN_DATA_O:{
            
            
            int     width       = -1;
            int     height      = -1;
            double  frameRate   = 0 ;
            
            currentChannelObj.nConnectDeviceType         = currentChannelObj.nConnectDeviceType;
            
            playBackDecoderObj.nPlayBackFrametotalNumber = [ystNetworkHelperCMObj getRemotePlaybackTotalFrameAndframeFrate:pBuffer buffer_O_size:nSize videoWidth:&width videoHeight:&height dFrameRate:&frameRate];
            
            if (width != playBackDecoderObj.nVideoWidth || height != playBackDecoderObj.nVideoHeight) {
                
                /**
                 *  处理解码器对象
                 */
                playBackDecoderObj.nVideoWidth       = width;
                playBackDecoderObj.nVideoHeight      = height;
                playBackDecoderObj.dVideoframeFrate  = frameRate;
                [currentChannelObj resetVideoDecoderParam];
                currentChannelObj.isPlaybackVideo    = YES;
            }
            
            [currentChannelObj startPopVideoDataThread];
            
            if (width > 0 && height >0) {
                
                if (jvcCloudSEENetworkHelper.ystNWRPVDelegate != nil && [jvcCloudSEENetworkHelper.ystNWRPVDelegate respondsToSelector:@selector(remoteplaybackState:)]) {
                    
                    [jvcCloudSEENetworkHelper.ystNWRPVDelegate remoteplaybackState:RemotePlayBackVideoStateType_Succeed];
                }
            }
        }
            break;
            
        case JVN_DATA_I:
        case JVN_DATA_B:
        case JVN_DATA_P:{
            
            if (!currentChannelObj.isPlaybackVideo) {
                
                [pool release];
                return;
            }
            
            BOOL               isH264Data      = [ystNetworkHelperCMObj checkVideoDataIsH264:pBuffer];
            
            [currentChannelObj openVideoDecoder];
            
            if (isH264Data) {
                
                int bufferType = uchType;
                
                if (jvcCloudSEENetworkHelper.ystNWHDelegate != nil && [jvcCloudSEENetworkHelper.ystNWHDelegate respondsToSelector:@selector(H264VideoDataCallBackMath:imageBufferY:imageBufferU:imageBufferV:decoderFrameWidth:decoderFrameHeight:nPlayBackFrametotalNumber:)]) {
                    
                    //偏移带帧头的数据和视频数据的大小
                    [jvcCloudSEENetworkHelper videoDataInExistStartCode:&pBuffer isFrameOStartCode:playBackDecoderObj.isExistStartCode nbufferSize:&nSize nBufferType:&bufferType];
                    
                    [currentChannelObj pushVideoData:(unsigned char *)pBuffer nVideoDataSize:nSize isVideoDataIFrame:bufferType==JVN_DATA_I isVideoDataBFrame:bufferType==JVN_DATA_B];
                    
                }else{
                    
                    DDLogCVerbose(@"%s---H264VideoDataCallBackMath:imageBufferY:imageBufferU:imageBufferV:decoderFrameWidth:decoderFrameHeight:nPlayBackFrametotalNumber: callback is Null",__FUNCTION__);
                }
            }
            
        }
            break;
        case JVN_DATA_A:{
            
            if (!currentChannelObj.isAudioListening) {
                
                [pool release];
                return;
            }
            
            [currentChannelObj pushAudioData:(unsigned char *)pBuffer nAudioDataSize:nSize];
        }
            break;
        case JVN_RSP_PLAYE:
        case JVN_RSP_PLAYOVER:
        case JVN_RSP_PLTIMEOUT:{
            
            [jvcCloudSEENetworkHelper RemotePlayBackVideoEndCallBack:uchType currentChannelObj:currentChannelObj];
        }
            
        default:
            break;
    }
    
    [pool release];
}

/**
 *  远程回放请求文件视频
 *
 *  @param nLocalChannel           视频显示窗口编号
 *  @param requestPlayBackFileInfo 远程文件的信息
 *  @param requestPlayBackFileDate 远程文件的日期
 */
-(void)RemoteRequestSendPlaybackVideo:(int)nLocalChannel requestPlayBackFileInfo:(NSMutableDictionary *)requestPlayBackFileInfo  requestPlayBackFileDate:(NSDate *)requestPlayBackFileDate requestPlayBackFileIndex:(int)requestPlayBackFileIndex {
    
    [requestPlayBackFileInfo retain];
    [requestPlayBackFileDate retain];
    
   JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    
    JVCCloudSEEManagerHelper                    *currentChannelObj               = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    char acBuff[150] = {0};
    
    //组合一条发送的远程回放文件的信息
    [currentChannelObj getRequestSendPlaybackVideoCommand:requestPlayBackFileInfo requestPlayBackFileDate:requestPlayBackFileDate nRequestPlayBackFileIndex:requestPlayBackFileIndex requestOutCommand:(char *)acBuff];
    
    [ystRemoteOperationHelperObj remoteSendDataToDevice:currentChannelObj.nLocalChannel remoteOperationType:JVN_REQ_PLAY remoteOperationCommandData:acBuff];
    [ystRemoteOperationHelperObj remoteSendDataToDevice:currentChannelObj.nLocalChannel remoteOperationType:JVN_REQ_PLAY remoteOperationCommandData:acBuff];
    
    [requestPlayBackFileDate release];
    [requestPlayBackFileInfo release];
}

/**
 *  回放结束的回调函数
 *
 *  @param nCallBackType     连接返回的类型
 */
-(void)RemotePlayBackVideoEndCallBack:(int)nCallBackType currentChannelObj:(JVCCloudSEEManagerHelper *)currentChannelObj{
    
    [currentChannelObj retain];
    
    [currentChannelObj resetVideoDecoderParam];
    currentChannelObj.isPlaybackVideo = FALSE;
    
    int nRemotePlaybackVideoState = RemotePlayBackVideoStateType_End;
    
    switch (nCallBackType) {
            
        case JVN_RSP_PLAYE:
            nRemotePlaybackVideoState = RemotePlayBackVideoStateType_Failed;
            break;
        case JVN_RSP_PLTIMEOUT:
            nRemotePlaybackVideoState = RemotePlayBackVideoStateType_TimeOut;
            break;
            
        default:
            break;
    }
    
    if (self.ystNWRPVDelegate != nil && [self.ystNWRPVDelegate respondsToSelector:@selector(remoteplaybackState:)]) {
        
        [self.ystNWRPVDelegate remoteplaybackState:nRemotePlaybackVideoState];
    }
    
    [currentChannelObj release];
}

#pragma mark －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－--远程回放处理模块

/**
 *  文本聊天的回调函数
 *
 *  @param nLocalChannel   连接的本地通道号 从1开始
 *  @param uchType         文本聊天的数据类型
 *  @param pBuffer         文本聊天的数据
 *  @param nSize           文本聊天的数据大小
 */
void TextChatDataCallBack(int nLocalChannel,unsigned char uchType, char *pBuffer, int nSize){
    
    NSAutoreleasePool                    *pool                  = [[NSAutoreleasePool alloc] init];
    
    JVCCloudSEENetworkGeneralHelper *ystNetworkHelperCMObj = [JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper];
    
    PAC stpacket={0};
    
	if(nSize)//nSize有为0的情况，所以有数据才拷贝数据,lck20120301
	{
		memset(&stpacket, 0, sizeof(PAC));
		memcpy(&stpacket, pBuffer, nSize);
	}
    
    switch(uchType)
    {
        case JVN_RSP_TEXTACCEPT:
        case JVN_CMD_TEXTSTOP:{
            
            if (jvcCloudSEENetworkHelper.ystNWTDDelegate != nil && [jvcCloudSEENetworkHelper.ystNWTDDelegate respondsToSelector:@selector(ystNetWorkHelpTextChatCallBack:objYstNetWorkHelpSendData:)]) {
                
                [jvcCloudSEENetworkHelper.ystNWTDDelegate ystNetWorkHelpTextChatCallBack:uchType objYstNetWorkHelpSendData:nil];
            }
        }
            break;
            
        case JVN_RSP_TEXTDATA:
        {
            
            memcpy(&stpacket, pBuffer, nSize);
            UInt32 n=0;
            memcpy(&n, stpacket.acData, 4);
            
            EXTEND *_extend=(EXTEND*)stpacket.acData;//{0};
            
            switch (_extend->nType) {
                    
                case EX_WIFI_AP:{
                    
                    NSMutableArray *amAplistData          = [[NSMutableArray alloc] initWithCapacity:10];
                    
                    [amAplistData addObjectsFromArray:[jvcCloudSEENetworkHelper getDeviceNearApList:_extend->nParam1 NearApListBuffer:_extend->acData]];
                    
                    if (jvcCloudSEENetworkHelper.ystNWTDDelegate != nil && [jvcCloudSEENetworkHelper.ystNWTDDelegate respondsToSelector:@selector(ystNetWorkHelpTextChatCallBack:objYstNetWorkHelpSendData:)]) {
                        
                        [jvcCloudSEENetworkHelper.ystNWTDDelegate ystNetWorkHelpTextChatCallBack:TextChatType_ApList objYstNetWorkHelpSendData:amAplistData];
                    }
                    
                    [amAplistData release];
                }
                    break;
                    
                default:
                    break;
            }
            
            //start stpacket.nPacketType
            switch (stpacket.nPacketType) {
                    
                case RC_LOADDLG:{
                    
                    //start stpacket.nPacketID
                    switch (stpacket.nPacketID) {
                            
                        case RC_SNAPSLIST:{
                            
                            if (jvcCloudSEENetworkHelper.ystNWTDDelegate != nil && [jvcCloudSEENetworkHelper.ystNWTDDelegate respondsToSelector:@selector(ystNetWorkHelpTextChatCallBack:objYstNetWorkHelpSendData:)]) {
                                
                                DDLogCVerbose(@"%s-----buffer3=%s",__FUNCTION__, stpacket.acData+n);
                                NSMutableDictionary *networkInfoMDic = [[NSMutableDictionary alloc] initWithCapacity:10];
                                
                                [networkInfoMDic addEntriesFromDictionary:[ystNetworkHelperCMObj convertpBufferToMDictionary:stpacket.acData+n]];
                                
                                [jvcCloudSEENetworkHelper.ystNWTDDelegate ystNetWorkHelpTextChatCallBack:TextChatType_NetWorkInfo objYstNetWorkHelpSendData:networkInfoMDic];
                                
                                [networkInfoMDic release];
                            }
                        }
                            break;
                            
                        case RC_GETPARAM:{
                            
                            if (jvcCloudSEENetworkHelper.ystNWTDDelegate != nil && [jvcCloudSEENetworkHelper.ystNWTDDelegate respondsToSelector:@selector(ystNetWorkHelpTextChatCallBack:objYstNetWorkHelpSendData:)]) {
                                
                                NSString *strDevice          = [[NSString alloc] initWithString:[ystNetworkHelperCMObj findBufferInExitValueToByKey:stpacket.acData+n nameBuffer:(char *)[MOBILECHFLAG UTF8String]]];
                                
                                int nMobileCh = MOBILECHDEFAULT;
                                
                                if (strDevice.intValue == MOBILECHSECOND) {
                                    
                                    nMobileCh = MOBILECHSECOND;
                                }
                                
                                NSMutableDictionary *networkInfoMDic = [[NSMutableDictionary alloc] initWithCapacity:10];
                                
                                [networkInfoMDic addEntriesFromDictionary:[ystNetworkHelperCMObj getFrameParamInfoByChannel:stpacket.acData+n nChannelValue:3]];
                                
                                [jvcCloudSEENetworkHelper.ystNWTDDelegate ystNetWorkHelpTextChatCallBack:TextChatType_paraInfo objYstNetWorkHelpSendData:networkInfoMDic];
                                
                                [strDevice release];
                                [networkInfoMDic release];
                                
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                    //end stpacket.nPacketID
                    
                }
                    break;
                    
                case RC_GETFILE:{
                    
                    if (stpacket.nPacketCount == RC_EX_NETWORK) {
                        
                        unsigned int type = 0;
                        memcpy(&type, stpacket.acData, 4);
                        
                        if(EX_NW_GETRESULT == type)
                        {
                            char a = stpacket.acData[4];
                            
                            NSString *strSetApResult = [[NSString alloc] initWithFormat:@"%d",a];
                            
                            if (jvcCloudSEENetworkHelper.ystNWTDDelegate != nil && [jvcCloudSEENetworkHelper.ystNWTDDelegate respondsToSelector:@selector(ystNetWorkHelpTextChatCallBack:objYstNetWorkHelpSendData:)]) {
                                
                                [jvcCloudSEENetworkHelper.ystNWTDDelegate ystNetWorkHelpTextChatCallBack:TextChatType_ApSetResult objYstNetWorkHelpSendData:strSetApResult];
                            }
                        }
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            //end stpacket.nPacketType
            
        }
        default:
            break;
    }
    
    [pool release];
    
}

/**
 *  获取设备附近的WI-FI热点
 *
 *  @param nNearApListCount 返回的热点个数
 *  @param NearApListBuffer 返回的热点数据
 *
 *  @return 返回的是热点
 */
-(NSMutableArray *)getDeviceNearApList:(int)nNearApListCount NearApListBuffer:(char *)NearApListBuffer{
    
    NSMutableArray *amNearApList = [[NSMutableArray alloc] init];
    
    wifiap_t _wifer={0};
    
    for (int i=0; i<nNearApListCount; i++) {
        
        memset(&_wifer, 0, sizeof(wifiap_t));
        
        memcpy(&_wifer, NearApListBuffer+sizeof(wifiap_t)*i, sizeof(wifiap_t));
        
        NSMutableDictionary *apSingleInfo = [[NSMutableDictionary  alloc] initWithCapacity:10];
        
        NSString               *strApName = [[NSString alloc] initWithCString:_wifer.name encoding:NSUTF8StringEncoding];
        
        [apSingleInfo setObject:strApName  forKey:AP_WIFI_USERNAME];
        [apSingleInfo setObject:[NSString stringWithFormat:@"%s",_wifer.passwd]  forKey:AP_WIFI_PASSWORD];
        [apSingleInfo setObject:[NSString stringWithFormat:@"%d",_wifer.quality] forKey:AP_WIFI_QUALITY];
        [apSingleInfo setObject:[NSString stringWithFormat:@"%d",_wifer.keystat] forKey:AP_WIFI_KEYSTAT];
        [apSingleInfo setObject:[NSString stringWithFormat:@"%s",_wifer.iestat]  forKey:AP_WIFI_IESTAT];
        
        unsigned int iauth=_wifer.iestat[0];
        unsigned int ienc=_wifer.iestat[1];
        
        [apSingleInfo setObject:[NSString stringWithFormat:@"%d",iauth] forKey:AP_WIFI_AUTH];
        [apSingleInfo setObject:[NSString stringWithFormat:@"%d",ienc]  forKey:AP_WIFI_ENC];
        
        [amNearApList addObject:apSingleInfo];
        
        [apSingleInfo release];
        [strApName release];
    }
    
    return [amNearApList autorelease];
}

/**
 *  设置有线网络
 *
 *  @param nLocalChannel     本地连接的编号
 *  @param nIsEnableDHCP     是否启用自动获取 1:启用 0:手动输入
 *  ************以下参数手动输入时才生效*********************
 *  @param strIpAddress      ip地址
 *  @param strSubnetMaskIp   子网掩码
 *  @param strDefaultGateway 默认网关
 *  @param strDns            DNS服务器地址
 */
-(void)RemoteSetWiredNetwork:(int)nLocalChannel nIsEnableDHCP:(int)nIsEnableDHCP strIpAddress:(NSString *)strIpAddress strSubnetMask:(NSString *)strSubnetMask strDefaultGateway:(NSString *)strDefaultGateway strDns:(NSString *)strDns{
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper            *currentChannelObj            = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    [ystRemoteOperationHelperObj RemoteSetWiredNetwork:currentChannelObj.nLocalChannel nIsEnableDHCP:nIsEnableDHCP strIpAddress:strIpAddress strSubnetMask:strSubnetMask strDefaultGateway:strDefaultGateway strDns:strDns];
}

/**
 *  配置设备的无线网络(老的配置方式)
 *
 *  @param nLocalChannel   本地连接的编号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param strWifiAuth     热点的认证方式
 *  @param strWifiEncryp   热点的加密方式
 */
-(void)RemoteOldSetWiFINetwork:(int)nLocalChannel strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord strWifiAuth:(NSString *)strWifiAuth strWifiEncrypt:(NSString *)strWifiEncrypt{
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper            *currentChannelObj            = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    [ystRemoteOperationHelperObj RemoteOldSetWiFINetwork:currentChannelObj.nLocalChannel strSSIDName:strSSIDName strSSIDPassWord:strSSIDPassWord strWifiAuth:strWifiAuth strWifiEncrypt:strWifiEncrypt];
}

/**
 *  配置设备的无线网络(新的配置方式)
 *
 *  @param nLocalChannel   本地连接的编号
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param nWifiAuth       热点的认证方式
 *  @param nWifiEncryp     热点的加密方式
 */
-(void)RemoteNewSetWiFINetwork:(int)nLocalChannel strSSIDName:(NSString *)strSSIDName strSSIDPassWord:(NSString *)strSSIDPassWord nWifiAuth:(int)nWifiAuth nWifiEncrypt:(int)nWifiEncrypt{
    
    JVCCloudSEESendGeneralHelper *ystRemoteOperationHelperObj = [JVCCloudSEESendGeneralHelper shareJVCCloudSEESendGeneralHelper];
    JVCCloudSEEManagerHelper            *currentChannelObj            = [jvcCloudSEENetworkHelper returnCurrentChannelBynLocalChannel:nLocalChannel];
    
    [ystRemoteOperationHelperObj  RemoteNewSetWiFINetwork:currentChannelObj.nLocalChannel strSSIDName:strSSIDName strSSIDPassWord:strSSIDPassWord nWifiAuth:nWifiAuth nWifiEncrypt:nWifiEncrypt];
}

#pragma mark --------------------- JVCCloudSEEManagerHelper delegate

/**
 *  解码返回的数据
 *
 *  @param decoderOutVideoFrame 解码返回的数据
 */
-(void)decoderOutVideoFrameCallBack:(DecoderOutVideoFrame *)decoderOutVideoFrame nPlayBackFrametotalNumber:(int)nPlayBackFrametotalNumber{
    
    int nLocalChannel                     = decoderOutVideoFrame->nLocalChannelID;
    JVCCloudSEEManagerHelper *currentChannelObj   = [self returnCurrentChannelBynLocalChannel:nLocalChannel];
    int                nshowWindowNumber  = [self returnCurrentChannelNShowWindowIDBynLocalChannel:nLocalChannel];
    
    [self.ystNWHDelegate H264VideoDataCallBackMath:nshowWindowNumber imageBufferY:decoderOutVideoFrame->decoder_y imageBufferU:decoderOutVideoFrame->decoder_u imageBufferV:decoderOutVideoFrame->decoder_v decoderFrameWidth:decoderOutVideoFrame->nWidth decoderFrameHeight:decoderOutVideoFrame->nHeight nPlayBackFrametotalNumber:nPlayBackFrametotalNumber];
    
    currentChannelObj.isDisplayVideo = YES;
}

/**
 *  抓拍图片
 *
 *  @param captureOutImageData 抓拍的图片数据
 */
-(void)JVCCloudSEEManagerHelperCaptureImageData:(NSData *)captureOutImageData{
    
    [captureOutImageData retain];
    
    if (self.ystNWRODelegate != nil && [self.ystNWRODelegate respondsToSelector:@selector(captureImageCallBack:)]) {
        
        [self.ystNWRODelegate captureImageCallBack:captureOutImageData];
    }
    
    [captureOutImageData release];
}

/**
 *  音频解码后的回调
 *
 *  @param audioData     音频解码的数据
 *  @param audioDataSize 音频解码的数据大小
 *  @param audioDataType 音频解码的数据类别
 */
-(void)JVCCloudSEEManagerHelperAudioDataCallBack:(char *)audioData audioDataSize:(int)audioDataSize audioDataType:(BOOL)audioDataType{
    
    if (jvcCloudSEENetworkHelper.ystNWHDelegate != nil && [jvcCloudSEENetworkHelper.ystNWADelegate respondsToSelector:@selector(playVideoSoundCallBackMath:soundBufferSize:soundBufferType:)]) {
        
        [jvcCloudSEENetworkHelper.ystNWADelegate playVideoSoundCallBackMath:(char *)audioData soundBufferSize:audioDataSize soundBufferType:audioDataType];
    }
}


@end
