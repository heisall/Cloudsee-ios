//
//  OpenALBufferViewcontroller.m
//  OpenALTest
//  播放音频的处理类
//  Created by jovision on 13-5-15.
//
//

#import "OpenALBufferViewcontroller.h"
#import <AudioToolbox/AudioFile.h>


@interface OpenALBufferViewcontroller (){

    BOOL isRunPlayState;

}

@end

@implementation OpenALBufferViewcontroller
@synthesize mDevice;
@synthesize mContext;
@synthesize soundDictionary;
@synthesize bufferStorageArray;

static OpenALBufferViewcontroller *_OpenALBufferViewcontroller = nil;

/**
 *  单例
 *
 *  @return 返回OpenALBufferViewcontroller 单例
 */
+ (OpenALBufferViewcontroller *)shareOpenALBufferViewcontrollerobjInstance
{
    @synchronized(self)
    {
        if (_OpenALBufferViewcontroller == nil) {
            
            _OpenALBufferViewcontroller = [[self alloc] init ];
       
        }
        
        return _OpenALBufferViewcontroller;
    }
    
    return _OpenALBufferViewcontroller;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_OpenALBufferViewcontroller == nil) {
            
            _OpenALBufferViewcontroller = [super allocWithZone:zone];
            
            return _OpenALBufferViewcontroller;
            
        }
    }
    
    return nil;
}


/**
 *  初始化播放器
 */
-(void)initOpenAL
{
    mDevice=alcOpenDevice(NULL);
    
    if (mDevice) {
        
        mContext=alcCreateContext(mDevice, NULL);
        alcMakeContextCurrent(mContext);
    }
    
    if (!soundDictionary) {
        
        soundDictionary = [[NSMutableDictionary alloc]init];
    }
    
    if (!bufferStorageArray) {
        
        bufferStorageArray = [[NSMutableArray alloc]init];
    }
    
    
    alGenSources(1, &outSourceID);
    alSpeedOfSound(1.0);
    alDopplerVelocity(1.0);
    alDopplerFactor(1.0);                                 

    alSourcef(outSourceID, AL_PITCH, 1.0f);
    alSourcef(outSourceID, AL_GAIN, 1.0f);
    alSourcei(outSourceID, AL_LOOPING, AL_FALSE);
    alSourcef(outSourceID, AL_SOURCE_TYPE, AL_STREAMING);
    alSourcei(outSourceID, AL_FREQUENCY, 8000);
    alSourcei(outSourceID, AL_BITS , 8);
   // alSourcef(outSourceID, AL_REFERENCE_DISTANCE, 50.0f);
    alSourcei(outSourceID,  AL_CHANNELS , 1);
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
//    [audioSession setActive:NO error:&mError];在AVAudioPlayer初始化时，设置AudioSession的category为混音
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];在AVAudioRecorder初始化时，设置AudioSession的Category为录音状态
//    NSError *mError = nil;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
//    [audioSession setActive:YES error:&mError];
    
     isRunPlayState = YES;
}

- (BOOL) updataQueueBuffer
{
    
    ALint stateVaue;
    int processed, queued;
    
    alGetSourcei(outSourceID, AL_SOURCE_STATE, &stateVaue);
    
    if (stateVaue == AL_STOPPED ||
        stateVaue == AL_PAUSED ||
        stateVaue == AL_INITIAL)
    {
        DDLogInfo(@"%s----error===%d",__FUNCTION__,stateVaue);
        [self playSound];
        return NO;
    }

    alGetSourcei(outSourceID, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceID, AL_BUFFERS_QUEUED, &queued);
    
    while(processed--)
    {
        alSourceUnqueueBuffers(outSourceID, 1, &buff);
        alDeleteBuffers(1, &buff);
    }
    
    return YES;
}

/**
 *  播放音频
 *
 *  @param data      音频数据
 *  @param dataSize  音频数据的大小
 *  @param monoValue 音频数据的类型 YES:8k16Bit NO:8k8bit
 */
- (void)openAudioFromQueue:(short*)data dataSize:(UInt32)dataSize monoValue:(BOOL)monoValue
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSCondition* ticketCondition= [[NSCondition alloc] init];
    [ticketCondition lock];
    
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    NSData * tmpData = [NSData dataWithBytes:data length:dataSize];
    
    if (!monoValue) {
        
        alBufferData(bufferID, AL_FORMAT_MONO8, (short*)[tmpData bytes], (ALsizei)[tmpData length], 8000);
        
    }else{
        
        alBufferData(bufferID, AL_FORMAT_MONO16, (short*)[tmpData bytes], (ALsizei)[tmpData length], 8000);
    }
    
    alSourceQueueBuffers(outSourceID, 1, &bufferID);
    
    [self updataQueueBuffer];
    
    ALint stateVaue;
    alGetSourcei(outSourceID, AL_SOURCE_STATE, &stateVaue);
    
    [ticketCondition unlock];
    [ticketCondition release];
    ticketCondition = nil;
    [pool release];
     pool = nil;
}

-(void)playSound
{
    ALint value;
    alGetSourcei(outSourceID, AL_SOURCE_STATE, &value);
    if (value!=AL_PLAYING) {
        
        alSourcePlay(outSourceID);
    }
    
 
}

/**
 *  停止播放
 */
-(void)stopSound
{
    if (isRunPlayState) {
        
        alSourceStop(outSourceID);
        [self cleanUpOpenALMath];
        
        isRunPlayState = FALSE;
    }
    
}

- (void)playSound:(NSString*)soundKey
{
    NSNumber* numVal = [soundDictionary objectForKey:soundKey];
    if (numVal == nil)
        return;
    
    NSUInteger sourceID = [numVal unsignedIntValue];
    alSourcePlay(sourceID);
}

- (void)stopSound:(NSString*)soundKey
{
    NSNumber* numVal = [soundDictionary objectForKey:soundKey];
    if (numVal == nil)
        return;
    
    NSUInteger sourceID = [numVal unsignedIntValue];
    alSourceStop(sourceID);
    
}

/**
 *  清除缓存声音
 */
-(void)cleanUpOpenALMath
{
    for (NSNumber* sourceNumber in [soundDictionary allValues])
    {
        NSUInteger sourceID = [sourceNumber unsignedIntegerValue];
        alDeleteSources(1, &sourceID);
    }
    
    [soundDictionary removeAllObjects];
    
    for (NSNumber* bufferNumber in bufferStorageArray)
    {
        NSUInteger bufferID = [bufferNumber unsignedIntegerValue];
        alDeleteBuffers(1, &bufferID);
    }
    
    [bufferStorageArray removeAllObjects];
    alcDestroyContext(mContext);
    alcCloseDevice(mDevice);

}

-(AudioFileID)openAudioFile:(NSString*)filePath
{
    AudioFileID outAFID = 0;
    // use the NSURl instead of a cfurlref cuz it is easier
    NSURL * afUrl = [NSURL fileURLWithPath:filePath];
    // do some platform specific stuff..
#if TARGET_OS_IPHONE
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
#else
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, fsRdPerm, 0, &outAFID);
#endif
    
    return outAFID;
}

-(UInt32)audioFileSize:(AudioFileID)fileDescriptor
{
    UInt64 outDataSize = 0;
    UInt32 thePropSize = sizeof(UInt64);
    OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
    
    return (UInt32)outDataSize;
}

-(void)cleanUpOpenAL
{
    //    while(processed--)
    //    {
    //        alSourceUnqueueBuffers(outSourceID, 1, &buff);
    //        alDeleteBuffers(1, &buff);
    //    }
    [updataBufferTimer invalidate];
    updataBufferTimer = nil;
    alDeleteSources(1, &outSourceID);
    alDeleteBuffers(1, &buff);
    alcDestroyContext(mContext);
    alcCloseDevice(mDevice);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}



- (void)dealloc {
    [soundDictionary release];
    [bufferStorageArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
