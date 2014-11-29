//
//  JVCAlarmManagerHelper.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-27.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAlarmManagerHelper.h"
#import "JVCCloudSEENetworkHelper.h"

@implementation JVCAlarmManagerHelper

/**
 *  初始化报警设置的助手类
 *
 *  @param localChannel 本地云视通连接的通道号
 *
 *  @return 报警设置的助手类
 */
-(id)init:(int)localChannel{
    
    if ( self = [super init]) {
        
        nLocalChannel = localChannel;
    }
    
    return self;
}

/**
 *  设置安全防护按钮的状态
 *
 *  @param nStatus 0：关 1：开
 */
-(void)setAlarmStatus:(int)nStatus{
    
    JVCCloudSEENetworkHelper *networkHelpObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    if ([networkHelpObj checknLocalChannelIsDisplayVideo:nLocalChannel]) {
        
        [networkHelpObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_setAlarm remoteOperationCommand:nStatus];
    }
}

/**
 *  设置安全防护时间
 *
 *  @param nStatus 0：关 1：开
 */
-(void)setAlarmBeginHours:(int)nBeginHours withEndHours:(int)nEndHours {
    
    JVCCloudSEENetworkHelper *networkHelpObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    if ([networkHelpObj checknLocalChannelIsDisplayVideo:nLocalChannel]) {
        
        [networkHelpObj RemoteSetAlarmTime:nLocalChannel withTime1:nBeginHours withTime2:nEndHours];
    }
}

/**
 *  设置移动侦测开关
 *
 *  @param nStatus 0：关 1：开
 */
-(void)setMotionDetecting:(int)nStatus{
    
    JVCCloudSEENetworkHelper *networkHelpObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    if ([networkHelpObj checknLocalChannelIsDisplayVideo:nLocalChannel]) {
        
        [networkHelpObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationType:TextChatType_setMobileMonitoring remoteOperationCommand:nStatus];
    }
    
}

@end
