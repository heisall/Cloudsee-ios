//
//  OpenALBufferViewcontroller.h
//  OpenALTest
//
//  Created by jovision on 13-5-15.
//
//

#import <UIKit/UIKit.h>
#import <OpenAL/alc.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <OpenAL/al.h>

@interface OpenALBufferViewcontroller : UIViewController{


    ALCcontext            *mContext;
    ALCdevice             *mDevice;
    ALuint                 outSourceID;
    
    NSMutableDictionary   *soundDictionary;
    NSMutableArray        *bufferStorageArray;
    
    ALuint                 buff;
    NSTimer               *updataBufferTimer;
}

@property (nonatomic,assign) ALCcontext *mContext;
@property (nonatomic,assign) ALCdevice *mDevice;
@property (nonatomic,retain) NSMutableDictionary* soundDictionary;
@property (nonatomic,retain) NSMutableArray* bufferStorageArray;

/**
 *  单例
 *
 *  @return 返回OpenALBufferViewcontroller 单例
 */
+ (OpenALBufferViewcontroller *)shareOpenALBufferViewcontrollerobjInstance;

/**
 *  初始化播放器
 */
-(void)initOpenAL;

/**
 *  播放音频
 *
 *  @param data      音频数据
 *  @param dataSize  音频数据的大小
 *  @param monoValue 音频数据的类型 YES:8k16Bit NO:8k8bit
 */
- (void)openAudioFromQueue:(short*)data dataSize:(UInt32)dataSize monoValue:(BOOL)monoValue;

/**
 *  停止播放
 */
-(void)stopSound;

@end
