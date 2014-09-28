//
//  JVCDeviceModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceModel.h"
#import "JVCDeviceMacro.h"

@implementation JVCDeviceModel

@synthesize  userName,passWord,ip,port,nickName,yunShiTongNum;

@synthesize linkType,onLineState,hasWifi,useWifi,sortNum;


- (void)dealloc
{
    [userName release];
    userName = nil;
    
    [passWord release];
    passWord = nil;
    
    [ip release];
    ip = nil;
    
    [port release];
    port = nil;
    
    [nickName release];
    nickName = nil;
    
    [yunShiTongNum  release];
    yunShiTongNum = nil;
    
    linkType    = 0;
    
    onLineState = 0;
    
    hasWifi     = 0;
    
    useWifi     = 0;
    
    [super dealloc];

}

/**
 *  初始化
 *
 *  @param info 数组信息
 *
 *  @return 初始化好的数据
 */
-(id)initWithDictionary:(NSDictionary *)info {
    
    self = [super init];
    
    if (self !=nil) {
        
        self.userName = [info objectForKey:DEVICE_JSON_DVUSERNAME];
        self.passWord = [info objectForKey:DEVICE_JSON_DVPASSWORD];
        self.yunShiTongNum = [info objectForKey:DEVICE_JSON_DGUID];
        self.hasWifi = [[info objectForKey:DEVICE_JSON_WIFI] intValue];
        self.nickName = [info objectForKey:DEVICE_JSON_NICKNAME];
        self.linkType = [[info objectForKey:DEVICE_JSON_LINKTYPE] intValue];
        if (self.linkType==CONNECTTYPE_IP) {
            
            // _model.editByUser=YES;
        }
        self.ip = [info objectForKey:DEVICE_JSON_IP];
        self.port = [NSString stringWithFormat:@"%@",[info objectForKey:DEVICE_JSON_PORT]];
        self.onLineState=[[info objectForKey:DEVICE_ONLINE_STATUS] intValue];
    }
    return self;

}

@end
