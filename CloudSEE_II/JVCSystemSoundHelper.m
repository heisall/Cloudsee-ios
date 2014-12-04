//
//  JVCSystemSoundHelper.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-21.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCSystemSoundHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface JVCSystemSoundHelper () {
    
    SystemSoundID    sound;
    
    AVAudioPlayer    *player;
}

@end

@implementation JVCSystemSoundHelper
@synthesize delegate;

static JVCSystemSoundHelper *jvcSystemSoundHelperObj = nil;

/**
 *  单例
 *
 *  @return 返回JVCSystemSoundHelper的单例
 */
+ (JVCSystemSoundHelper *)shareJVCSystemSoundHelper;
{
    @synchronized(self)
    {
        if (jvcSystemSoundHelperObj == nil) {
            
            jvcSystemSoundHelperObj = [[self alloc] init];
            
        }
        return jvcSystemSoundHelperObj;
    }
    return jvcSystemSoundHelperObj;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcSystemSoundHelperObj == nil) {
            
            jvcSystemSoundHelperObj = [super allocWithZone:zone];
            
            return jvcSystemSoundHelperObj;
        }
    }
    return nil;
}

-(void)dealloc{
    
    [super dealloc];
    
}


/**
 *  加载背景音
 *
 *  @param path      路径
 *  @param isRunloop 是否循环管理
 */
-(void)playSound:(NSString *)path withIsRunloop:(BOOL)isRunloop{
    
    if (player) {
        
        [player release];
        player = nil;
    }
    
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:path];
    
    player =[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    player.volume         = 1.0;
    player.numberOfLoops  = isRunloop == YES? -1 : 0;
    [player prepareToPlay];
    
    [soundUrl release];
    
    [player play];
    
    
    //使用本地URL创建
    //    if (sound) {
    //
    //        AudioServicesDisposeSystemSoundID(sound);
    //    }
    //
    //    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL URLWithString:path], &sound);
    //
    //    AudioServicesPlaySystemSound(sound);
    //
    //    if (isRunloop) {
    //
    //        /*添加音频结束时的回调*/
    //        AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, SoundFinished,path);
    //    }
}

static void SoundFinished(SystemSoundID soundID,void* sample){
    
    if (jvcSystemSoundHelperObj.delegate != nil && [jvcSystemSoundHelperObj.delegate respondsToSelector:@selector(playEndCallBack)]) {
        
        [jvcSystemSoundHelperObj.delegate playEndCallBack];
        
    }else {
        
        /*播放全部结束，因此释放所有资源 */
        AudioServicesPlaySystemSound(soundID);
    }
}

/**
 *  停止播放声音的回调
 */
-(void)stopSound{
    
    [player stop];
    
    //AudioServicesDisposeSystemSoundID(sound);
}

@end
