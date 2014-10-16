//
//  JVCCloudSEEManagerHelper.m
//  CloudSEE_II
//  视频连接、显示播放声音、远程回放对讲的集中处理类
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCCloudSEEManagerHelper.h"
#import "JVCCloudSEENetworkInterface.h"
#import "JVNetConst.h"
#import "JVCRemotePlayBackWithVideoDecoderHelper.h"
#import "JVCPlaySoundHelper.h"
#import "JVCVoiceIntercomHelper.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCRecordVideoHelper.h"

@interface JVCCloudSEEManagerHelper (){
    
    DecoderOutVideoFrame  *jvcOutVideoFrame;
}

@end

@implementation JVCCloudSEEManagerHelper;
@synthesize nLocalChannel ,strYstGroup , nYstNumber, strRemoteIP;
@synthesize nRemotePort ,nRemoteChannel ,strUserName ,strPassWord;
@synthesize linkModel,nConnectDeviceType,decodeModelObj,isRunDisconnect;
@synthesize nShowWindowID,isAudioListening,isVoiceIntercom;
@synthesize isPlaybackVideo,playBackDecoderObj,nConnectStartCode;
@synthesize isDisplayVideo,jvcQueueHelper,jvConnectDelegate,nSystemVersion;
@synthesize jvcPlaySound,jvcAudioQueueHelper,jvcVoiceIntercomHelper;
@synthesize isOnlyIState,isVideoPause;
@synthesize jvcRecodVideoHelper;

char          pcmBuffer[1024] ={0};

-(void)dealloc{
    
    [strYstGroup    release];
    [strRemoteIP    release];
    [strUserName    release];
    [strPassWord    release];
    [decodeModelObj release];
    [playBackDecoderObj release];
    [jvcQueueHelper release];
    [jvcPlaySound release];
    [jvcAudioQueueHelper release];
    [jvcVoiceIntercomHelper release];
    [jvcRecodVideoHelper release];
    
    DDLogInfo(@"%s",__FUNCTION__);
    
    free(jvcOutVideoFrame);
    
    [super dealloc];
}

-(id)init {
    
    if (self = [super init]) {
        
        JVCVideoDecoderHelper    * decodemodel   =  [[JVCVideoDecoderHelper alloc] init];
        self.decodeModelObj                      =  decodemodel;
        decodeModelObj.delegate                  =  self;
        [decodemodel release];
        
        JVCRemotePlayBackWithVideoDecoderHelper *playBackDecoderModel =  [[JVCRemotePlayBackWithVideoDecoderHelper alloc] init];
        self.playBackDecoderObj                                       =  playBackDecoderModel;
        playBackDecoderObj.delegate                                   =  self;
        [playBackDecoderModel release];
        
        JVCPlaySoundHelper        *jvcPlaySoundObj = [[JVCPlaySoundHelper alloc] init];
        self.jvcPlaySound                          = jvcPlaySoundObj;
        [jvcPlaySoundObj release];
        
        JVCVoiceIntercomHelper *jvcVoiceIntercomObj   = [[JVCVoiceIntercomHelper alloc] init];
        self.jvcVoiceIntercomHelper                   = jvcVoiceIntercomObj;
        [jvcVoiceIntercomObj release];
        
        JVCRecordVideoHelper   *jvcRecordObj          = [[JVCRecordVideoHelper alloc] init];
        self.jvcRecodVideoHelper                      =  jvcRecordObj;
        [jvcRecordObj release];
        
        jvcOutVideoFrame = malloc(sizeof(DecoderOutVideoFrame));
        
        memset(jvcOutVideoFrame->decoder_y, 0, sizeof(jvcOutVideoFrame->decoder_y));
        memset(jvcOutVideoFrame->decoder_u, 0, sizeof(jvcOutVideoFrame->decoder_u));
        memset(jvcOutVideoFrame->decoder_v, 0, sizeof(jvcOutVideoFrame->decoder_v));
        
    }
    
    return self;
}

/**
 *  连接的工作线程
 */
-(void)connectWork{
    
    if (self.linkModel) {
        
        [self ipConnectWorker];
        
    }else {
        
        [self ystConnectWorker];
    }
}

/**
 *   yst连接工作线程
 */
-(void)ystConnectWorker
{
    DDLogVerbose(@"%s--RemoteChannel=%d,Group=%@,ystNumber=%d,port=%d,userName=%@,password=%@",__FUNCTION__,self.nRemoteChannel,self.strYstGroup,self.nYstNumber,self.nRemotePort,self.strUserName,self.strPassWord);
    
    JVC_Connect(self.nLocalChannel, self.nRemoteChannel, (char *)[@"" UTF8String], self.nRemotePort, (char *)[self.strUserName UTF8String], (char *)[self.strPassWord UTF8String],self.nYstNumber, (char *)[self.strYstGroup UTF8String], YES, JVN_TRYTURN,NO,TYPE_3GMOHOME_UDP,TRUE);
}

/**
 *  ip连接工作线程
 */
-(void)ipConnectWorker
{
    DDLogVerbose(@"%s--RemoteChannel=%d,Group=%@,ystNumber=%d,remoIP=%@,port=%d,userName=%@,password=%@",__FUNCTION__,self.nRemoteChannel,self.strYstGroup,self.nYstNumber,self.strRemoteIP,self.nRemotePort,self.strUserName,self.strPassWord);
    
    JVC_Connect(self.nLocalChannel, self.nRemoteChannel, (char *)[self.strRemoteIP UTF8String], self.nRemotePort, (char *)[self.strUserName UTF8String], (char *)[self.strPassWord UTF8String],-1, (char *)[@"" UTF8String], YES, JVN_TRYTURN,NO,TYPE_3GMOHOME_UDP,TRUE);
}

/**
 *  退出缓存队列
 */
-(void)exitQueue{
    
    self.jvcQueueHelper.jvcQueueHelperDelegate = nil;
    [self.jvcQueueHelper exitPopDataThread];
    
    if (self.isVoiceIntercom || self.isAudioListening) {
        
        self.jvcAudioQueueHelper.jvcAudioQueueHelperDelegate = nil;
        [self.jvcAudioQueueHelper exitPopDataThread];
    }
}

/**
 *  断开远程连接
 */
-(void)disconnect {
    
    [self exitQueue];
    
    DDLogVerbose(@"%s----%d----start",__FUNCTION__,nLocalChannel);
    JVC_DisConnect(self.nLocalChannel);
    DDLogVerbose(@"%s----%d----end",__FUNCTION__,nLocalChannel);
}

#pragma mark ----------------  JVCQueueHelper 处理模块

/**
 *  启动缓存队列出队线程
 */
-(void)startPopVideoDataThread{
    
    if (!self.jvcQueueHelper) {
        
        JVCQueueHelper      *jvcQueueHelperObj     = [[JVCQueueHelper alloc] init:self.nLocalChannel];
        jvcQueueHelperObj.jvcQueueHelperDelegate   = self;
        self.jvcQueueHelper                        = jvcQueueHelperObj;
        [jvcQueueHelperObj release];
    }
    
    //设置帧率
    [self.jvcQueueHelper setDefaultFrameRate:self.isPlaybackVideo==YES?self.playBackDecoderObj.dVideoframeFrate:self.decodeModelObj.dVideoframeFrate];
    
    [self performSelectorOnMainThread:@selector(popVideoDataThread) withObject:nil waitUntilDone:NO];
    
}

-(void)popVideoDataThread{
    
    [self.jvcQueueHelper startPopDataThread];
}

/**
 *  缓存队列的入队函数 （视频）
 *
 *  @param videoData         视频帧数据
 *  @param nVideoDataSize    数据数据大小
 *  @param isVideoDataIFrame 视频是否是关键帧
 *  @param isVideoDataBFrame 视频是否是B帧
 */
-(void)pushVideoData:(unsigned char *)videoData nVideoDataSize:(int)nVideoDataSize isVideoDataIFrame:(BOOL)isVideoDataIFrame isVideoDataBFrame:(BOOL)isVideoDataBFrame{
    
    if (self.isOnlyIState && !isVideoDataIFrame) {
        
        return;
    }
    
    [self.jvcQueueHelper offer:videoData nSize:nVideoDataSize is_i_frame:isVideoDataIFrame is_b_frame:isVideoDataBFrame];
}

/**
 *  缓存队列的出队回调（协议）
 *
 *  @param bufferData 缓存队列的出队参数
 */
-(void)popDataCallBack:(void *)bufferData {
    
    frame *decodervideoFrame = (frame *)bufferData;
    
    [self saveRecordVideoDataToLocal:(char *)decodervideoFrame->buf isVideoDataI:decodervideoFrame->is_i_frame isVideoDataB:decodervideoFrame->is_b_frame videoDataSize:decodervideoFrame->nSize];
    
    int nDecoderStatus = [self decodeOneVideoFrame:decodervideoFrame VideoOutFrame:jvcOutVideoFrame];
    
    //DDLogInfo(@"%s----popodata,nDecoderStatus=%d",__FUNCTION__,nDecoderStatus);
    
    if ( nDecoderStatus >= 0) {
        
        if (self.jvConnectDelegate != nil && [self.jvConnectDelegate respondsToSelector:@selector(decoderOutVideoFrameCallBack:nPlayBackFrametotalNumber:)]) {
            
            jvcOutVideoFrame->nLocalChannelID = self.nLocalChannel;
            
            [self.jvConnectDelegate decoderOutVideoFrameCallBack:jvcOutVideoFrame nPlayBackFrametotalNumber:self.isPlaybackVideo==YES?self.playBackDecoderObj.nPlayBackFrametotalNumber:-1];
        }
    }
}

#pragma mark 解码处理模块

/**
 *  打开解码器
 */
-(void)openVideoDecoder{
    
    int nDecoderID  = self.nLocalChannel -1 ;
    
    [self.decodeModelObj openVideoDecoder:nDecoderID];
}

/**
 *  关闭解码器
 *
 *  @param nVideoDecodeID 解码器编号
 */
-(void)closeVideoDecoder{
    
    [self.jvcQueueHelper clearEnqueueData];
    
    [self.decodeModelObj closeVideoDecoder];
}

/**
 *  还原解码器参数
 */
-(void)resetVideoDecoderParam{
    
    [self.jvcQueueHelper clearEnqueueData];
    
    self.decodeModelObj.isWaitIFrame = FALSE;
    
}

/**
 *  解码一帧
 *
 *  @param nLocalChannel   连接的本地通道编号
 *  @param videoFrame      视频帧数据
 *  @param nSystemVersion  当前手机系统的版本
 *  @param VideoOutFrame   解码返回的结构
 *
 *  @return 解码成功返回 0 否则失败
 */
-(int)decodeOneVideoFrame:(frame *)videoFrame VideoOutFrame:(DecoderOutVideoFrame *)VideoOutFrame{
    
    int nDecoderID      = self.nLocalChannel -1 ;
    int nDecoderStatus  = -1 ;
    
    nDecoderStatus = [self.decodeModelObj decodeOneVideoFrame:videoFrame nSystemVersion:self.nSystemVersion VideoOutFrame:jvcOutVideoFrame];
    
    return nDecoderID;
}

/**
 *  抓拍图像
 */
-(void)startWithCaptureImage{
    
    self.decodeModelObj.isCaptureImage == NO ? self.decodeModelObj.isCaptureImage = YES:self.decodeModelObj.isCaptureImage;
}

/**
 *  抓拍图片的委托处理
 *
 *  @param captureOutImageData 抓拍的图片数据
 */
-(void)decoderModelCaptureImageCallBack:(NSData *)captureOutImageData {
    
    [captureOutImageData retain];
    
    if (self.jvConnectDelegate != nil && [self.jvConnectDelegate respondsToSelector:@selector(JVCCloudSEEManagerHelperCaptureImageData:)]) {
        
        [self.jvConnectDelegate JVCCloudSEEManagerHelperCaptureImageData:captureOutImageData];
    }
    
    [captureOutImageData release];
}

#pragma mark 远程回放处理模块

/**
 *  根据远程回放检索回调返回的Buffer 获取 远程回放文件列表信息
 *
 *  @param remotePlaybackFileBuffer     远程回放检索回调返回的Buffer
 *  @param remotePlaybackFileBufferSize 远程回放检索回调返回的Buffer的大小
 *
 *  @return 远程回放文件列表信息
 */
-(NSMutableArray *)getRemoteplaybackSearchFileListInfoByNetworkBuffer:(char *)remotePlaybackFileBuffer remotePlaybackFileBufferSize:(int)remotePlaybackFileBufferSize {
    
    return [self.playBackDecoderObj convertRemoteplaybackSearchFileListInfoByNetworkBuffer:self.nConnectDeviceType remotePlaybackFileBuffer:remotePlaybackFileBuffer remotePlaybackFileBufferSize:remotePlaybackFileBufferSize nRemoteChannel:self.nRemoteChannel];
}

/**
 *  获取请求远程回放的一条命令
 *
 *  @param requestPlayBackFileInfo   当前选中的远程回放的远程文件信息
 *  @param requestPlayBackFileDate   远程回放的日期
 *  @param requestPlayBackFileIndex  当前选中的远程文件列表的索引
 *  @param requestOutCommand         输出的发送命令
 */
-(void)getRequestSendPlaybackVideoCommand:(NSMutableDictionary *)requestPlayBackFileInfo requestPlayBackFileDate:(NSDate *)requestPlayBackFileDate nRequestPlayBackFileIndex:(int)nRequestPlayBackFileIndex requestOutCommand:(char *)requestOutCommand{
    
    [requestPlayBackFileInfo retain];
    [requestPlayBackFileDate retain];
    
    [self.playBackDecoderObj getRequestSendPlaybackVideoCommand:self.nConnectDeviceType requestPlayBackFileInfo:requestPlayBackFileInfo requestPlayBackFileDate:requestPlayBackFileDate nRequestPlayBackFileIndex:nRequestPlayBackFileIndex requestOutCommand:requestOutCommand];
    
    [requestPlayBackFileDate release];
    [requestPlayBackFileInfo release];
}

#pragma mark 音频监听处理模块

/**
 *  设置音频类型
 *
 *  @param nAudioType 音频的类型
 */
-(void)setAudioType:(int)nAudioType{
    
    self.jvcPlaySound.nAudioType            = nAudioType;
    self.jvcVoiceIntercomHelper.nAudioType  = nAudioType;
}

/**
 *   打开音频解码器
 */
-(void)openAudioDecoder{
    
    [self.jvcPlaySound openAudioDecoder:self.nConnectDeviceType isExistStartCode:self.decodeModelObj.isExistStartCode];
    self.isAudioListening = self.jvcPlaySound.isOpenDecoder;
    
    if (!self.jvcAudioQueueHelper) {
        
        JVCAudioQueueHelper *jvcAudioQueueObj         = [[JVCAudioQueueHelper alloc] init:self.nLocalChannel];
        jvcAudioQueueObj.jvcAudioQueueHelperDelegate  = self;
        self.jvcAudioQueueHelper                      = jvcAudioQueueObj;
        [jvcAudioQueueObj release];
    }
    
    [self performSelectorOnMainThread:@selector(popAudioDataThread) withObject:nil waitUntilDone:NO];
}

-(void)popAudioDataThread{
    
    [self.jvcAudioQueueHelper startAudioPopDataThread];
}

/**
 *  关闭音频解码
 */
-(void)closeAudioDecoder{
    
    [self.jvcPlaySound closeAudioDecoder];
    
    self.isAudioListening = self.jvcPlaySound.isOpenDecoder;
    [self.jvcAudioQueueHelper exitPopDataThread];
    
    
}

#pragma mark 音频缓存队列处理模块

/**
 *  缓存队列的入队函数(音频)
 *
 *  @param videoData         视频帧数据
 *  @param nVideoDataSize    数据数据大小
 *  @param isVideoDataIFrame 视频是否是关键帧
 */
-(void)pushAudioData:(unsigned char *)audioData nAudioDataSize:(int)nAudioDataSize {
    
    [self.jvcAudioQueueHelper jvcAudioOffer:audioData nSize:nAudioDataSize];
}

/**
 *  缓存队列的出队入口数据
 *
 *  @param bufferData 队列出队的Buffer
 *
 */
-(void)popAudioDataCallBack:(void *)bufferData{
    
    frame *decoderAudioFrame = (frame *)bufferData;
    
    BOOL isSoundType     =  FALSE; //YES: 16bit NO: 8bit
    BOOL isConvertStatus =  FALSE;
    
    if (!self.isVoiceIntercom) {
        
        isConvertStatus= [self.jvcPlaySound convertSoundBufferByNetworkBuffer:self.nConnectDeviceType isExistStartCode:self.decodeModelObj.isExistStartCode networkBuffer:(char *)decoderAudioFrame->buf nBufferSize:&decoderAudioFrame->nSize isBufferType:&isSoundType audioDecoderOutBuffer:(char *)pcmBuffer];
    }else {
        
        isConvertStatus= [self.jvcVoiceIntercomHelper convertSoundBufferByNetworkBuffer:self.nConnectDeviceType isExistStartCode:self.decodeModelObj.isExistStartCode networkBuffer:(char *)decoderAudioFrame->buf nBufferSize:&decoderAudioFrame->nSize isBufferType:&isSoundType audioDecoderOutBuffer:(char *)pcmBuffer];
    }
    
    if (isConvertStatus) {
        
        if (self.jvConnectDelegate !=nil && [self.jvConnectDelegate respondsToSelector:@selector(JVCCloudSEEManagerHelperAudioDataCallBack:audioDataSize:audioDataType:)]) {
            
            if (self.isVoiceIntercom) {
                
                switch (self.nConnectDeviceType) {
                        
                    case DEVICEMODEL_SoftCard:
                    case DEVICEMODEL_HardwareCard_950:
                    case DEVICEMODEL_HardwareCard_951:{
                        
                        for (int i=0; i<3; i++) {
                            
                            [self.jvConnectDelegate JVCCloudSEEManagerHelperAudioDataCallBack:(char *)(pcmBuffer+i*320) audioDataSize:decoderAudioFrame->nSize/3 audioDataType:isSoundType];
                        }
                    }
                        break;
                    default:{
                        
                        [self.jvConnectDelegate JVCCloudSEEManagerHelperAudioDataCallBack:(char *)pcmBuffer audioDataSize:decoderAudioFrame->nSize audioDataType:isSoundType];
                    }
                        break;
                }
            }else{
                
                [self.jvConnectDelegate JVCCloudSEEManagerHelperAudioDataCallBack:(char *)pcmBuffer audioDataSize:decoderAudioFrame->nSize audioDataType:isSoundType];
            }
        }
    }
}

#pragma mark 语音对讲处理

/**
 *   打开音频解码器
 */
-(void)openVoiceIntercomDecoder{

    
    [self.jvcVoiceIntercomHelper openAudioDecoder:self.nConnectDeviceType isExistStartCode:self.decodeModelObj.isExistStartCode];
    self.isVoiceIntercom = self.jvcVoiceIntercomHelper.isOpenDecoder;
    
    if (!self.jvcAudioQueueHelper) {
        
        JVCAudioQueueHelper *jvcAudioQueueObj         = [[JVCAudioQueueHelper alloc] init:self.nLocalChannel];
        jvcAudioQueueObj.jvcAudioQueueHelperDelegate  = self;
        self.jvcAudioQueueHelper                      = jvcAudioQueueObj;
        [jvcAudioQueueObj release];
    }

    
    [self performSelectorOnMainThread:@selector(popAudioDataThread) withObject:nil waitUntilDone:NO];
}

/**
 *  打开语音对讲的采集模块
 *
 *  @param nAudioBit                采集音频的位数 目前 8位或16位
 *  @param nAudioCollectionDataSize 采集音频的数据
 *
 *  @return 成功返回YES
 */
-(BOOL)getAudioCollectionBitAndDataSize:(int *)nAudioBit nAudioCollectionDataSize:(int *)nAudioCollectionDataSize{
    
    return [self.jvcVoiceIntercomHelper getAudioCollectionBitAndDataSize:self.nConnectDeviceType isExistStartCode:self.decodeModelObj.isExistStartCode nAudioBit:nAudioBit nAudioCollectionDataSize:nAudioCollectionDataSize];
}

/**
 *  编码本地采集的音频数据
 *
 *  @param Audiodata               本地采集的音频数据
 *  @param nEncodeAudioOutdataSize 本地采集的音频数据大小，编码之后为编码的数据大小
 *  @param encodeOutAudioData      编码后的音频数据
 *
 *  @return 成功返回YES
 */
-(BOOL)encoderLocalRecorderData:(char *)Audiodata nEncodeAudioOutdataSize:(int *)nEncodeAudioOutdataSize encodeOutAudioData:(char *)encodeOutAudioData{
    
    return [self.jvcVoiceIntercomHelper encoderLocalRecorderData:Audiodata nEncodeAudioOutdataSize:nEncodeAudioOutdataSize encodeOutAudioData:encodeOutAudioData];
}

/**
 *  关闭音频解码
 */
-(void)closeVoiceIntercomDecoder{
    
    [self.jvcVoiceIntercomHelper closeAudioDecoder];
    self.isVoiceIntercom = self.jvcVoiceIntercomHelper.isOpenDecoder;
    
     [self.jvcAudioQueueHelper exitPopDataThread];
}

#pragma mark 录像处理模块

/**
 *  打开录像的编码器
 *
 *  @param strRecordVideoPath 录像的地址
 *  @param nRecordChannelID   录像的通道号
 *  @param nWidth             录像视频的宽
 *  @param nHeight            录像视频的高
 *  @param dRate              录像的帧率
 */
-(void)openRecordVideo:(NSString *)strRecordVideoPath {
    
    [strRecordVideoPath retain];
    
    int     nRecoedWidth  = self.isPlaybackVideo == NO?self.decodeModelObj.nVideoWidth:self.playBackDecoderObj.nVideoWidth;
    int     nRecoedHeight = self.isPlaybackVideo == NO?self.decodeModelObj.nVideoHeight:self.playBackDecoderObj.nVideoHeight;
    double  dRate         = self.isPlaybackVideo == NO?self.decodeModelObj.dVideoframeFrate:self.playBackDecoderObj.dVideoframeFrate;
    
    [self.jvcRecodVideoHelper openRecordVideo:strRecordVideoPath nRecordChannelID:self.nLocalChannel-1 nWidth:nRecoedWidth nHeight:nRecoedHeight dRate:dRate];
    
    [strRecordVideoPath release];
}

/**
 *  录像一帧的方法
 *
 *  @param videoData     录像的视频数据
 *  @param isVideoDataI  是否是I帧
 *  @param isVideoDataB  是否是B帧
 *  @param videoDataSize 视频数据的大小
 */
-(void)saveRecordVideoDataToLocal:(char *)videoData isVideoDataI:(BOOL)isVideoDataI isVideoDataB:(BOOL)isVideoDataB videoDataSize:(int)videoDataSize{
    
    [self.jvcRecodVideoHelper saveRecordVideoDataToLocal:videoData isVideoDataI:isVideoDataI isVideoDataB:isVideoDataB videoDataSize:videoDataSize];
}

/**
 *  停止录像
 */
-(void)stopRecordVideo{
    
    [self.jvcRecodVideoHelper stopRecordVideo];
}


@end
