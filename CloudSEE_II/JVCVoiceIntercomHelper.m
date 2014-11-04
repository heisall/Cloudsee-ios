//
//  JVCVoiceIntercomHelper.m
//  CloudSEE
//  语音对讲中间层的处理类
//  Created by chenzhenyang on 14-9-17.
//  Copyright (c) 2014年 miaofaqiang. All rights reserved.
//

#import "JVCVoiceIntercomHelper.h"
#import "JVCCloudSEENetworkMacro.h"

@implementation JVCVoiceIntercomHelper
@synthesize nAudioCollectionType;
AudioFrame    *audioFrame;
char          decodeAudioCache[76]    = {0};


-(id)init{
    
    
    if (self=[super init]) {
        
        audioFrame = (AudioFrame*)decodeAudioCache;
        audioFrame->iIndex=0;
    }
    
    return self;
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
-(BOOL)convertSoundBufferByNetworkBuffer:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode networkBuffer:(char *)networkBuffer nBufferSize:(int *)nBufferSize isBufferType:(BOOL *)isBufferType audioDecoderOutBuffer:(char *)audioDecoderOutBuffer audioDecoderOutBufferSize:(int)audioDecoderOutBufferSize {

    int              nSize                 = *nBufferSize;
   // DDLogVerbose(@"%s-----",__FUNCTION__);
    switch (nConnectDeviceType) {
            
        case DEVICEMODEL_SoftCard:
        case DEVICEMODEL_HardwareCard_950:
        case DEVICEMODEL_HardwareCard_951:{
            
            int outLen;
            outLen = audioDecoderOutBufferSize;
            
            DecodeAudioData(networkBuffer+16,nSize-16,audioDecoderOutBuffer,&outLen);
            *nBufferSize   = outLen;
            *isBufferType  = YES;
        }
            break;
        case DEVICEMODEL_DVR:{
            
            if (isExistStartCode) {
                
                unsigned char *audioPcmBuf = NULL;
                
                [self lock];
                JAD_DecodeOneFrame(0, networkBuffer,  &audioPcmBuf);
                [self unLock];
                
                memcpy(audioDecoderOutBuffer, audioPcmBuf, AudioSize_G711);
                *nBufferSize   = AudioSize_G711;
                *isBufferType  = YES;
                
            }else{
                
                memcpy(audioDecoderOutBuffer, networkBuffer, AudioSize_G711);
                *nBufferSize   = nSize;
                *isBufferType  = NO;
            }
        }
            break;
        case DEVICEMODEL_IPC:{
            
            if (isExistStartCode) {
                
                unsigned char *audioPcmBuf = NULL;
                
                [self lock];
                JAD_DecodeOneFrame(0, networkBuffer,  &audioPcmBuf);
                [self unLock];
                
                memcpy(audioDecoderOutBuffer, audioPcmBuf, AudioSize_G711);
                
                *nBufferSize   = AudioSize_G711;
                *isBufferType  = YES;
                
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

/**
 *  打开语音对讲的采集模块
 *
 *  @param nConnectDeviceType       连接的设备类型
 *  @param isExistStartCode         设备是否包含新帧头
 *  @param nAudioBit                采集音频的位数 目前 8位或16位
 *  @param nAudioCollectionDataSize 采集音频的数据
 *
 *  @return 成功返回YES
 */
-(BOOL)getAudioCollectionBitAndDataSize:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode nAudioBit:(int *)nAudioBit nAudioCollectionDataSize:(int *)nAudioCollectionDataSize{
    
    
    BOOL result                    = TRUE;
    
    switch (nConnectDeviceType) {
            
        case DEVICEMODEL_SoftCard:
        case DEVICEMODEL_HardwareCard_950:
        case DEVICEMODEL_HardwareCard_951:{

           self.nAudioCollectionType = AudioType_AMR;
            
            *nAudioBit                           = AudioBit_AMR;
            *nAudioCollectionDataSize            = AudioSize_AMR;
        }
            break;
            
        case DEVICEMODEL_DVR:{
            
            if (isExistStartCode) {
                
                self.nAudioCollectionType = AudioType_G711;
                *nAudioBit                = AudioBit_G711;
                *nAudioCollectionDataSize = AudioSize_G711;
                
            }else{
    
                self.nAudioCollectionType = AudioType_PCM;
                *nAudioBit                = AudioBit_PCM;
                *nAudioCollectionDataSize = AudioSize_PCM;
            }
        }
            break;
        case DEVICEMODEL_IPC:{
            
            if (isExistStartCode) {
                
                self.nAudioCollectionType = AudioType_G711;
                *nAudioBit                = AudioBit_G711;
                *nAudioCollectionDataSize = AudioSize_G711;
                
            }else{
                
                result  = FALSE;
            }
        }
        default:
            break;
    }
    
    return result;
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
-(BOOL)encoderLocalRecorderData:(char *)Audiodata nEncodeAudioOutdataSize:(int *)nEncodeAudioOutdataSize encodeOutAudioData:(char *)encodeOutAudioData encodeOutAudioDataSize:(int)encodeOutAudioDataSize{
    
    BOOL isEncoderStatus  = TRUE;
    
    int  nAudiodataSize   =  *nEncodeAudioOutdataSize;
    
    switch (nAudiodataSize) {
            
        case AudioSize_PCM:{
            
            memcpy(encodeOutAudioData, Audiodata, AudioSize_PCM);
        }
            break;
            
        case AudioSize_G711:{
            
            [self lock];
            int nEncodeResultSize = JAD_EncodeOneFrame(0, (unsigned char*)Audiodata, encodeOutAudioData,AudioSize_G711);
            [self unLock];
            
            *nEncodeAudioOutdataSize = nEncodeResultSize;
        }
            break;
        case AudioSize_AMR:{
            
            int ndecoderAudioSize = encodeOutAudioDataSize;
            
            [self lock];
            EncodeAudioData(Audiodata,AudioSize_AMR,encodeOutAudioData,&ndecoderAudioSize);
            audioFrame->iIndex ++;
            memcpy(decodeAudioCache, audioFrame, sizeof(struct AudioFrame));
            //复制音频格式信息
            memcpy(decodeAudioCache + sizeof(struct AudioFrame),encodeOutAudioData,ndecoderAudioSize);
            
            memcpy(encodeOutAudioData, decodeAudioCache, ndecoderAudioSize +sizeof(struct AudioFrame));
            
            [self unLock];
            *nEncodeAudioOutdataSize = ndecoderAudioSize +sizeof(struct AudioFrame);
            
        }
            break;
            
        default:{
        
            isEncoderStatus = FALSE;
        }
            break;
    }
    
    return isEncoderStatus;
}


@end
