//
//  JVCLanScanDeviceModel.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCLanScanDeviceModel : NSObject{
    
    NSString *strYstNumber;        //云视通号 如 A361
    int       iDeviceChannelCount; //设备的通道数量
    NSString *strDeviceIP;         //局域网中设备的IP
    NSString *strDevicePort;       //局域网中设备的端口
    int       iDeviceVariety;      //设备的种类
    NSString *strDeviceName;       //设备的名称
    int       iTimeOut;            //是否超时，广播超时时间之后返回的数据
    BOOL      iNetMod;             //YES：WIFI功能
    BOOL      iCurMod;             //YES:WIFI NO:有钱
    
}

@property(nonatomic,retain)NSString *strYstNumber;
@property(nonatomic,assign)int       iDeviceChannelCount;
@property(nonatomic,retain)NSString *strDeviceIP;
@property(nonatomic,retain)NSString *strDevicePort;
@property(nonatomic,assign)int       iDeviceVariety;
@property(nonatomic,retain)NSString *strDeviceName;
@property(nonatomic,assign)int       iTimeOut;
@property(nonatomic,assign)BOOL      iNetMod;
@property(nonatomic,assign)BOOL      iCurMod;

@end
