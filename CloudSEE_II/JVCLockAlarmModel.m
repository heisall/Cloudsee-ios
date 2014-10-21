//
//  JVCLockAlarmModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLockAlarmModel.h"

@implementation JVCLockAlarmModel
@synthesize alarmGuid,alarmName,alarmType,alarmState;

- (void)dealloc
{
    [alarmGuid release];
    [alarmName release];
    
    [super dealloc];
}
@end
