//
//  JVCDeviceModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceModel.h"

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


//-(id)init:(NSDictionary *)info {
//
//
//
//
//}

@end
