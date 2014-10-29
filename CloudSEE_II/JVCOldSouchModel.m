//
//  JVCOldSouchModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOldSouchModel.h"

@implementation JVCOldSouchModel
@synthesize idnum;
@synthesize linkType;
@synthesize channelName;
@synthesize channelNumber;
@synthesize userName;
@synthesize password;
@synthesize yunShiTongNum;
@synthesize ip;
@synthesize port;
@synthesize passwordState;
@synthesize windowIndex;
@synthesize groupID;

@synthesize byTCP;
@synthesize localTry,LANSerchFlag,_isCheckResult;
@synthesize isAuto;
@synthesize deleteChannle;

@synthesize _imageModelDatas;
@synthesize flage;
@synthesize OID;
@synthesize Owner;
@synthesize DeviceID;
@synthesize isLoadImageURL;
@synthesize badge;
@synthesize sound;
@synthesize time;
@synthesize _isYSTState;
@synthesize isSearchByWifi;
@synthesize isGetByWifiNew;
@synthesize isNewAdd;
@synthesize hasWifi;
@synthesize useWifi;
@synthesize onLineState;
@synthesize editByUser;
#pragma mark 释放视频源实体的资源
-(void)dealloc{
    
    [time release];
    time=nil;
    [badge release];
    badge=nil;
    [sound release];
    sound=nil;
	[deleteChannle release];   //记录被删除的通道
    deleteChannle=nil;
	[channelName  release];
    channelName=nil;
	[channelNumber release];
    channelNumber=nil;
	[userName release];
    userName=nil;
	[password release];
    password=nil;
	[yunShiTongNum release];
    yunShiTongNum=nil;
	[ip release];
    ip=nil;
	[port release];
    port=nil;
    [OID release];
    OID=nil;
    [Owner release];
    Owner=nil;
    [DeviceID release];
    DeviceID=nil;
    [_imageModelDatas release];
    _imageModelDatas=nil;
	[super dealloc];
	
}
-(id)init{
    
    if (self=[super init]) {
        
        NSMutableArray *imageModelDatas=[[NSMutableArray alloc] initWithCapacity:10];
        self._imageModelDatas=imageModelDatas;
        [imageModelDatas release];
        self._isYSTState=NO;
        self._isCheckResult=NO;
        self._isYSTState=-1;
        self.userName=(NSString *)DefaultUserName;
        self.password=(NSString *)DefaultPassWord;
        
    }
    return self;
}

@end
