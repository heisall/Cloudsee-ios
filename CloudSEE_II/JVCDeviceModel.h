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
    NSString *ip;               //ip
	NSString *port;             //端口号
    
    int  onLineState;            //1 在线   0：不在线
    int  hasWifi;                //0：没有wifi   1：有WiFi
    int  useWifi;                //0  没有用WiFi  1 ：使用WiFi
    int  linkType;               //设备连接模式  0 云视通连接  1：ip连接
    BOOL isCustomLinkModel;      //连接模式 //YES 客户定制IP连接 NO：非定制
}

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *passWord;
@property(nonatomic,retain) NSString *nickName;
@property(nonatomic,retain) NSString *yunShiTongNum;
@property(nonatomic,retain) NSString *ip;
@property(nonatomic,retain) NSString *port;

@property(nonatomic,assign) int  linkType;
@property(nonatomic,assign) int  onLineState;
@property(nonatomic,assign) int  hasWifi;
@property(nonatomic,assign) int  useWifi;
@property(nonatomic,assign) BOOL isCustomLinkModel;

/**
 *  初始化
 *
 *  @param info 数组信息
 *
 *  @return 初始化好的数据
 */
-(id)initWithDictionary:(NSDictionary *)info;

/**
 *  添加设备初始化model类型
 *
 *  @param info   传入的字典
 *  @param YSTNum 云视通号
 *
 *  @return 返回相应的设备model类型
 */
-(id)initWithADDDeviceDictionary:(NSDictionary *)info  YSTNUM:(NSString *)YSTNum;

@end
