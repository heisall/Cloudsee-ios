//
//  JVCPlaySoundHelper.m
//  CloudSEE_II
//  音频监听的助手类 用于处理网路库的数据进行解码播放
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCPlaySoundHelper.h"
#import "JVCAudioCodecInterface.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCCloudSEENetworkGeneralHelper.h"
#import "JVNetConst.h"

@interface JVCPlaySoundHelper () {
    
   pthread_mutex_t  mutex;
}

@end

@implementation JVCPlaySoundHelper
@synthesize nAudioType,isOpenDecoder;

-(void)dealloc{
    
    pthread_mutex_destroy(&mutex);
    [super dealloc];
}

-(id)init{
    
    
    if (self=[super init]) {
        
        pthread_mutex_init(&mutex, nil);
    }
    
    return self;
}

/**
 *  上锁
 */
-(void)lock
{
	pthread_mutex_lock(&mutex);
}

/**
 *  解锁
 */
-(void)unLock
{
	pthread_mutex_unlock(&mutex);
}

/**
 *   音频解码器打开
 *
 *  @param nConnectDeviceType 连接的设备类型
 *  @param isExistStartCode   是否包含新帧头
 */
-(void)openAudioDecoder:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode {
    
    if (!self.isOpenDecoder) {
        
        switch (nConnectDeviceType) {
                
            case DEVICEMODEL_DVR:
            case DEVICEMODEL_IPC:
                
                if (isExistStartCode) {
                    
                    [self lock];
                    JAD_DecodeOpen(0,self.nAudioType);
                    [self unLock];
                }
                
                break;
                
            default:
                
                if (isExistStartCode) {
                    
                    [self lock];
                    JAD_DecodeOpen(0,1);
                    [self unLock];
                }
                
                break;
        }
        
        self.isOpenDecoder = TRUE;
        
    }else{
        
        DDLogCVerbose(@"%s----audio is open",__FUNCTION__);
    }
}

/**
 *  关闭音频解码器
 */
-(void)closeAudioDecoder{
    
    if (self.isOpenDecoder) {
        
        [self lock];
        JAD_DecodeClose(0);
        [self unLock];
        
        self.isOpenDecoder = FALSE;
    }
}

/**
 *  音频解码
 *
 *  @param nConnectDeviceType    连接的设备类型
 *  @param isExistStartCode      是否包含新帧头
 *  @param networkBuffer         音频数据
 *  @param nBufferSize           音频数据大小
 *  @param isBufferType          音频数据的类型 YES:8K16B NO:8K8Bit
 *  @param audioDecoderOutBuffer 解码输出的buffer
 *
 *  @return YES 转换失败 NO:转换失败
 */
-(BOOL)convertSoundBufferByNetworkBuffer:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode networkBuffer:(char *)networkBuffer nBufferSize:(int *)nBufferSize isBufferType:(BOOL *)isBufferType audioDecoderOutBuffer:(char *)audioDecoderOutBuffer{
    
    
    JVCCloudSEENetworkGeneralHelper  *ystNetworkHelperCMObj = [JVCCloudSEENetworkGeneralHelper shareJVCCloudSEENetworkGeneralHelper];
    int                                   nSize                 = *nBufferSize;
    
    if (!self.isOpenDecoder) {
        
        DDLogVerbose(@"%s-----audio is not open!",__FUNCTION__);
        return NO;
    }
    
    switch (nConnectDeviceType) {
            
        case DEVICEMODEL_SoftCard:
        case DEVICEMODEL_HardwareCard_950:
        case DEVICEMODEL_HardwareCard_951:{
            
            if(isExistStartCode) {
                
                unsigned char *audioPcmBuf = NULL;
                
                [self lock];
                
                JAD_DecodeOneFrame(0, networkBuffer,  &audioPcmBuf);
                memcpy(audioDecoderOutBuffer, audioPcmBuf, AudioSize_PCM);
                
                JAD_DecodeOneFrame(0, networkBuffer+21,  &audioPcmBuf);
                memcpy(audioDecoderOutBuffer+AudioSize_PCM, audioPcmBuf, AudioSize_PCM);
                
                [self unLock];
                
                *nBufferSize   = AudioSize_G711;
                *isBufferType  = YES;
                
            }else{
                
                if ([ystNetworkHelperCMObj isKindOfBufInStartCode:(char *)networkBuffer]) {
                    
                    int startCode = 0;
                    memcpy(&startCode, networkBuffer, 4);
                    
                    if (startCode==JVN_DSC_9800CARD) {
                        
                        *isBufferType = YES;
                        
                    }else{
                        
                        *isBufferType = NO;
                    }
                    
                    memcpy(audioDecoderOutBuffer, networkBuffer + 8, nSize - 8);
                    *nBufferSize   = nSize   - 8;
                }
            }
        }
            break;
        case DEVICEMODEL_DVR:{
            
            if (isExistStartCode) {
                
                unsigned char *audioPcmBuf = NULL;
                
                
                [self lock];
                JAD_DecodeOneFrame(0, networkBuffer,  &audioPcmBuf);
                [self unLock];
                
                memcpy(audioDecoderOutBuffer, audioPcmBuf, AudioSize_G711);
                
                *isBufferType  = YES;
                *nBufferSize   = AudioSize_G711;
                
            }else{
                
                memcpy(audioDecoderOutBuffer, networkBuffer + 8, nSize-8);
                *nBufferSize   = nSize   - 8;
                *isBufferType  = NO;
            }
        }
            break;
        case DEVICEMODEL_IPC:{
            
            if (isExistStartCode) {
                
                if ([ystNetworkHelperCMObj isKindOfBufInStartCode:(char *)networkBuffer]) {
                    
                    networkBuffer = networkBuffer + 8;
                }
                
                unsigned char *audioPcmBuf = NULL;
                
                [self lock];
                JAD_DecodeOneFrame(0, networkBuffer,  &audioPcmBuf);
                [self unLock];
                
                memcpy(audioDecoderOutBuffer, audioPcmBuf, AudioSize_G711);
                
                *isBufferType  = YES;
                *nBufferSize   = AudioSize_G711;
                
            }else{
                
                return NO;
            }
            
        }
            break;
        default:
            break;
    }
    return YES;
}

@end
