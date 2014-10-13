//
//  JVCLanScanDeviceModel.m
//  CloudSEE_II
//  局域网扫描的设备的Model类
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLanScanDeviceModel.h"

@implementation JVCLanScanDeviceModel

@synthesize strYstNumber,iDeviceChannelCount,strDeviceIP,strDevicePort;
@synthesize iDeviceVariety,strDeviceName,iTimeOut,iNetMod,iCurMod;


/**
 *  释放方法
 */
-(void)dealloc{
    
    [strYstNumber release];
    [strDeviceIP release];
    [strDevicePort release];
    [strDeviceName release];
    [super dealloc];
    
}

@end
