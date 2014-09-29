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

/**
 *  添加设备初始化model类型
 *
 *  @param info   传入的字典
 *  @param YSTNum 云视通号
 *
 *  @return 返回相应的设备model类型
 */
-(id)initWithADDDeviceDictionary:(NSDictionary *)info  YSTNUM:(NSString *)YSTNum{
    
    self = [super init];
    
    if (self !=nil) {
        
        NSDictionary *dInfo = [info objectForKey:DEVICE_JSON_DINFO];
        self.yunShiTongNum = YSTNum.uppercaseString;
        self.nickName = YSTNum.uppercaseString;
        self.userName = [dInfo objectForKey:DEVICE_JSON_DVUSERNAME];
        self.passWord = [dInfo objectForKey:DEVICE_JSON_DVPASSWORD];
        self.onLineState = [[dInfo objectForKey:DEVICE_JSON_ONLINESTATE] intValue];
        self.hasWifi = [[dInfo objectForKey:DEVICE_JSON_WIFI] intValue];
        self.onLineState=DEVICESTATUS_ONLINE;
        self.hasWifi    =DEVICESTATUS_OFFLINE;
        self.linkType= CONNECTTYPE_YST;

    }
    
    return self;
}


/**
 *  根据收到的channel的
 *
 *  @param channelDic  通道的字典
 *  @param deviceModel 通道对应的设备字典
 *
 *  @return 通道的model类型
 */
-(id)initWithChannelDic:(NSDictionary *)channelDic  devieModel:(JVCDeviceModel *)deviceModel{
    
    self = [super init];
    
    if (self !=nil) {
        
        self.yunShiTongNum = deviceModel.yunShiTongNum;
        self.nickName = [channelDic objectForKey:DEVICE_CHANNEL_JSON_NAME];
        self.userName=deviceModel.userName;
        self.passWord = deviceModel.passWord;
        self.onLineState = deviceModel.onLineState;
        self.hasWifi = deviceModel.hasWifi;
        self.sortNum =[NSString stringWithFormat:@"%@",[channelDic objectForKey:DEVICE_CHANNEL_JSON_NUMBER]];
        self.linkType=deviceModel.linkType;
        self.ip=deviceModel.ip;
        self.port=deviceModel.port;
        
    }
    
    return self;
}


@end
