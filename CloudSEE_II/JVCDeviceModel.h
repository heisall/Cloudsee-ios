//
//  JVCDeviceModel.h
//  CloudSEE_II
//  设备的model类
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCDeviceModel : NSObject
{
   
    NSString *userName;         //用户名
    NSString *passWord;         //密码
    NSString *nickName;         //昵称
    NSString *yunShiTongNum;    //云视通号
    NSString *ip;              //ip
	NSString *port;            //端口号
    
    //通道特有
    NSString *sortNum;                //通道的排序，（设备不用）========通道
    
    int onLineState;            //1 在线   0：不在线
    int hasWifi;                //0：没有wifi   1：有WiFi
    int useWifi;               //0  没有用WiFi  1 ：使用WiFi
    int linkType;               //设备连接模式  0 云视通连接  1：ip连接
    
 
    
}

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *passWord;
@property(nonatomic,retain) NSString *nickName;
@property(nonatomic,retain) NSString *yunShiTongNum;
@property(nonatomic,retain) NSString *ip;
@property(nonatomic,retain) NSString *port;
@property(nonatomic,retain) NSString *sortNum;

@property(nonatomic,assign) int linkType;
@property(nonatomic,assign) int onLineState;
@property(nonatomic,assign) int hasWifi;
@property(nonatomic,assign) int useWifi;


@end
