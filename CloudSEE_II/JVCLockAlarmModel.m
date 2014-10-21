//
//  JVCLockAlarmModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLockAlarmModel.h"
#import "JVCAlarmMacro.h"
@implementation JVCLockAlarmModel
@synthesize alarmGuid,alarmName,alarmType,alarmState,alarmRes;

- (void)dealloc
{
    [alarmName release];
    
    [super dealloc];
}

/**
 *  根据字典初始化报警对象
 *
 *  @param dic 数据
 *
 *  @return 报警对象
 */
- (id)initAlarmLockModelWithDictionary:(NSDictionary *)dic
{
    if (self=[super init]) {
        
        self.alarmGuid = [[dic objectForKey:Alarm_Lock_Guid] integerValue];
        self.alarmName = [dic objectForKey:Alarm_Lock_Name];
        self.alarmState =[[dic objectForKey:Alarm_Lock_Enable] integerValue];
        self.alarmType = [[dic objectForKey:Alarm_Lock_Type] integerValue];
//        self.alarmRes = [[dic objectForKey:Alarm_Lock_RES] integerValue];

    }
    return self;
}

@end
