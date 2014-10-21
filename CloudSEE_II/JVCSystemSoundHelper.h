//
//  JVCSystemSoundHelper.h
//  CloudSEE_II
//  播放语音提示助手类
//  Created by chenzhenyang on 14-10-21.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCSystemSoundHelperDelegate  <NSObject>

/**
 *  播放结束回调
 */
-(void)playEndCallBack;

@end

@interface JVCSystemSoundHelper : NSObject {
    
    id <JVCSystemSoundHelperDelegate> delegate;

}

@property (nonatomic,assign) id <JVCSystemSoundHelperDelegate> delegate;


/**
 *  单例
 *
 *  @return 返回JVCSystemSoundHelper的单例
 */
+ (JVCSystemSoundHelper *)shareJVCSystemSoundHelper;

/**
 *  加载背景音
 *
 *  @param path      路径
 *  @param isRunloop 是否循环管理
 */
-(void)playSound:(NSString *)path withIsRunloop:(BOOL)isRunloop;

/**
 *  停止播放声音的回调
 */
-(void)stopSound;

@end
