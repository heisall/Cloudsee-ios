//
//  JVCAlarmModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmModel.h"

@implementation JVCAlarmModel
@synthesize strALarmDeviceNickName;

@synthesize bNewAlarmFlag;
@synthesize iAlarmType;

- (void)dealloc
{
    [strALarmDeviceNickName release];
    [super dealloc];
}
@end
