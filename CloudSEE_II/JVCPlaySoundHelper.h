//
//  JVCPlaySoundHelper.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-30.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCPlaySoundHelper : NSObject {

    int    nAudioType;           //音频编码的类别
    BOOL   isOpenDecoder;        //解码器是否打开   YES:打开
}

@property (nonatomic,assign)int   nAudioType;
@property (nonatomic,assign)BOOL  isOpenDecoder;

/**
 *  上锁
 */
-(void)lock;

/**
 *  解锁
 */
-(void)unLock;

/**
 *   解码器打开
 *
 *  @param nConnectDeviceType 连接的设备类型
 *  @param isExistStartCode   是否包含新帧头
 */
-(void)openAudioDecoder:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode;

/**
 *  关闭音频解码器
 */
-(void)closeAudioDecoder;

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
-(BOOL)convertSoundBufferByNetworkBuffer:(int)nConnectDeviceType isExistStartCode:(BOOL)isExistStartCode networkBuffer:(char *)networkBuffer nBufferSize:(int *)nBufferSize isBufferType:(BOOL *)isBufferType audioDecoderOutBuffer:(char *)audioDecoderOutBuffer;

@end
