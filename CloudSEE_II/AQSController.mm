//
//  AQSController.mm
//  AQS
//  音频采集处理
//  Preprocessor Macros参数的值清空即可(操作:select the Target, open the Build Settings pane, search for "Preprocessor Macros". Leave the fields blank (I've got rid of a DEBUG entry)
//  Created by Midfar Sun on 2/3/12.
//  Copyright 2012 midfar.com. All rights reserved.
//

#import "AQSController.h"
#import "AQPlayer.h"
#import "AQRecorder.h"



@interface AQSController (){

	CFStringRef	  recordFilePath;
    AQRecorder    *recorder;
	//AQPlayer   *player;
    BOOL          isRecoderState;
}

@end

@implementation AQSController
@synthesize delegate;

OSStatus errorState;

static AQSController *_AQSController = nil;

/**
 *  单例
 *
 *  @return 返回AQSController 单例
 */
+ (AQSController *)shareAQSControllerobjInstance
{
    @synchronized(self)
    {
        if (_AQSController == nil) {
            
            _AQSController = [[self alloc] init ];
            
        }
        
        return _AQSController;
    }
    
    return _AQSController;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_AQSController == nil) {
            
            _AQSController = [super allocWithZone:zone];
            
            return _AQSController;
            
        }
    }
    
    return nil;
}

char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4], *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}

-(void)setFileDescriptionForFormat: (CAStreamBasicDescription)format withName:(NSString*)name
{
	char buf[5];
	const char *dataFormat = OSTypeToStr(buf, format.mFormatID);
	NSString* description = [[NSString alloc] initWithFormat:@"(%ld ch. %s @ %g Hz)", format.NumberChannels(), dataFormat, format.mSampleRate, nil];
	[description release];	
}

//#pragma mark Playback routines
//
//-(void)stopPlayQueue
//{
//	player->StopQueue();
//}
//
//-(void)pausePlayQueue
//{
//	player->PauseQueue();
//	playbackWasPaused = YES;
//}

- (void)stopRecord
{
    if (isRecoderState) {
        
        recorder->StopRecord();
        
        //player->DisposeQueue(true);
        
        if (errorState) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)errorState);
        
        else
        {
            UInt32 category = kAudioSessionCategory_AmbientSound;
            errorState = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            
            errorState = AudioSessionSetActive(true);
            if (errorState) printf("AudioSessionSetActive (true) failed");
            
        }
        
        isRecoderState = FALSE;

    }
	
}

//- (void)replay
//{
//	if (player->IsRunning())
//	{
//		if (playbackWasPaused) {
//			OSStatus result = player->StartQueue(true);
//			if (result == noErr)
//				[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
//		}
//		else
//			[self stopPlayQueue];
//	}
//	else
//	{		
//		OSStatus result = player->StartQueue(false);
//		if (result == noErr)
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
//	}
//}

- (void)record:(int)cacheBufSize mChannelBit:(int)mchannelBit
{
    
    if (errorState) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)errorState);
	else
	{
        UInt32 category = kAudioSessionCategory_PlayAndRecord;
		errorState = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        
        errorState = AudioSessionSetActive(true);
		if (errorState) printf("AudioSessionSetActive (true) failed");
        
    }
	if (recorder->IsRunning())
	{
		[self stopRecord];
	}
	else
	{
		recorder->StartRecord(CFSTR("recordedFile.wav"),cacheBufSize,mchannelBit);
		
		[self setFileDescriptionForFormat:recorder->DataFormat() withName:@"Recorded File"];
	}
	
    isRecoderState = TRUE ;
}

#pragma mark AudioSession listeners

void interruptionListener(	void *	inClientData,
							UInt32	inInterruptionState)
{
    AQSController *THIS = (AQSController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
            
			[THIS stopRecord];
		}
//		else if (THIS->player->IsRunning()) {
//			//the queue will stop itself on an interruption, we just need to update the UI
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
//            THIS->playbackWasInterrupted = YES;
//		}
	}
	else if (inInterruptionState == kAudioSessionEndInterruption)
	{
		// we were playing back when we were interrupted, so reset and resume now
		//THIS->player->StartQueue(true);
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
	}
}

void propListener(	void *                  inClientData,
					AudioSessionPropertyID	inID,
					UInt32                  inDataSize,
					const void *            inData)
{
    //AQSController *THIS = (AQSController*)inClientData;
    
    if (inID == kAudioSessionProperty_AudioRouteChange)
    {
        CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;          
        //CFShow(routeDictionary);
        CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
        SInt32 reasonVal;
        CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
        
        if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
        {
            
            if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
            {           
//                if (THIS->player->IsRunning()) {
//                    
//                    [THIS pausePlayQueue];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
//                }       
            }
            
        }
    }
    else if (inID == kAudioSessionProperty_AudioInputAvailable)
    {
        if (inDataSize == sizeof(UInt32)) {
            
            //UInt32 isAvailable = *(UInt32*)inData;
        }
    }
}
				
#pragma mark Initialization routines
- (void)awakeFromNib
{
    // Allocate our singleton instance for the recorder & player object
    
	recorder = new AQRecorder();
    
    recorder->RegisterAQSController(self);
	//player = new AQPlayer();
    
    errorState = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
    if (errorState) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)errorState);
	else 
	{
        UInt32 category = kAudioSessionCategory_AmbientSound;
		errorState = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        
               
		if (errorState) printf("couldn't set audio category!");
        
        errorState = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (errorState) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)errorState);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);

        // we do not want to allow recording if input is not available
		errorState = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (errorState) printf("ERROR GETTING INPUT AVAILABILITY! %d\n", (int)errorState);
        
//        // we also need to listen to see if input availability changes
        errorState = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
        if (errorState) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)errorState);
 
        errorState = AudioSessionSetActive(true); 
		if (errorState) printf("AudioSessionSetActive (true) failed");
    
    }
    
}

/**
 *  接收音频采集的回调函数
 *
 *  @param audioData    采集的音频数据
 *  @param audioDataSize 采集的音频数据的大小
 */
-(void)receiveAudioData:(char *)audioData audioDataSize:(long)audioDataSize{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(receiveAudioDataCallBack:audioDataSize:)]) {
        
        [self.delegate receiveAudioDataCallBack:audioData audioDataSize:audioDataSize];
        
    }
}


#pragma mark Cleanup
- (void)dealloc
{
	delete recorder;
	[super dealloc];
}

@end
