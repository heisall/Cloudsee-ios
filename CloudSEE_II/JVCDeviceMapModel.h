//
//  JVCDeviceMapModel.h
//  CloudSEE_II
//
//  Created by David on 14/12/16.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCBaseMapModel.h"

@interface JVCDeviceMapModel : JVCBaseMapModel
{
    int         aswitch;    //安全防护开关状态
    int         atime;      //防护时间
    int         dimols;     //设备服务器设备的在线状态
    int         dsls;       //设备在云视通服务器的在线状态
    int         dstypeint;  //设备型号的int编号
    int         dtype;      //设备的类型
    int         dvlt;       //设备的连接类型 （0:云视通 1：IP）
    int         dwifi;      //设备是否支持无线 1：支持
    int         dvport;    //设备的端口

    NSString    *dguid;     //设备的云视通号
    NSString    *dname;     //设备的昵称
    NSString    *dstype;    //设备的类型
    NSString    *dsv;       //设备的版本
    NSString    *dvip;      //设备的IP
    NSString    *dvpassword;//连接视频的密码
    NSString    *dvusername;//连接视频的用户名
}

@property(nonatomic,assign)int         aswitch;
@property(nonatomic,assign)int         atime;
@property(nonatomic,assign)int         dimols;
@property(nonatomic,assign)int         dsls;
@property(nonatomic,assign)int         dstypeint;
@property(nonatomic,assign)int         dtype;
@property(nonatomic,assign)int         dvlt;
@property(nonatomic,assign)int         dwifi;
@property(nonatomic,assign)int         dvport;

@property(nonatomic,retain)NSString    *dguid;
@property(nonatomic,retain)NSString    *dname;
@property(nonatomic,retain)NSString    *dstype;
@property(nonatomic,retain)NSString    *dsv;
@property(nonatomic,retain)NSString    *dvip;
@property(nonatomic,retain)NSString    *dvpassword;
@property(nonatomic,retain)NSString    *dvusername;

@end
