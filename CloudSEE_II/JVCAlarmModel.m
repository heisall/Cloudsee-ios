//
//  JVCAlarmModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmModel.h"
#import "JVCAlarmMacro.h"
#import "JVCSystemUtility.h"

@implementation JVCAlarmModel
@synthesize strAlarmGuid,strAlarmLocalPicURL,strAlarmLocalVideoUrl,strAlarmPicUrl;
@synthesize strAlarmTime,strAlarmVideoUrl,strYstNumber,iAlarmType,iFlag,iAlarmPlanType;
@synthesize iYstChannel,iAlarmLevel,strALarmDeviceNickName;
@synthesize iAlarmTimer;
@synthesize strAlarmLocalPicUrl;
@synthesize isDownLoad;

-(void)dealloc{
    
    
    [strYstNumber release];
    [strAlarmVideoUrl release];
    [strAlarmPicUrl release];
    [strAlarmLocalVideoUrl release];
    [strAlarmLocalPicURL release];
    [strAlarmGuid release];
    [strAlarmTime release];
    [super dealloc];
}





/**
 *  根据字典初始化报警对象
 *
 *  @param dic 数据
 *
 *  @return 报警对象
 */
- (id)initAlarmModelWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        
        self.isDownLoad=FALSE;
        
        self.strAlarmGuid = [dic objectForKey:JK_ALARM_GUID];
        self.strAlarmPicUrl = [dic objectForKey:JK_ALARM_PIC];
        self.iAlarmPlanType = [[dic objectForKey:JK_ALARM_SOLUTION] intValue];
        self.iAlarmTimer = [[dic objectForKey:JK_ALARM_TIMESTAMP] intValue];
        self.iAlarmType =  [[dic objectForKey:JK_ALARM_TYPE] intValue];
        self.strAlarmVideoUrl = [dic objectForKey:JK_ALARM_VIDEO];
        self.iYstChannel = [[dic objectForKey:JK_ALARM_FTP_CHANNEL_NO] intValue];
        self.strYstNumber = [dic objectForKey:JK_ALARM_FTP_DEVICE_GUID];
        self.strALarmDeviceNickName = [dic objectForKey:JK_ALARM_DEVICE_NAME];

    }
    return self;
}

-(id)init{
    
    if (self=[super init]) {
        
        self.isDownLoad=FALSE;
    }
    
    return self;
}
@end
