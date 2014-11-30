//
//  JVCAlarmManagerHelper.h
//  CloudSEE_II
//  报警的集中管理类（安全防护按钮、报警时间段等）
//  Created by chenzhenyang on 14-11-27.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAlarmManagerHelper : NSObject {

    int nLocalChannel;
}

/**
 *  初始化报警设置的助手类
 *
 *  @param localChannel 本地云视通连接的通道号
 *
 *  @return 报警设置的助手类
 */
-(id)init:(int)localChannel;

/**
 *  设置安全防护按钮的状态
 *
 *  @param nStatus 0：关 1：开
 */
-(void)setAlarmStatus:(int)nStatus;

/**
 *  设置安全防护时间段
 *
 *  @param nLocalChannel  本地通道
 *  @param strBeginTime   开始时间
 *  @param strEndTime     结束时间
 */
-(void)setAlarmBeginHours:(NSString *)strBeginTime withStrEndTime:(NSString *)strEndTime;

/**
 *  设置移动侦测开关
 *
 *  @param nStatus 0：关 1：开
 */
-(void)setMotionDetecting:(int)nStatus;

@end
