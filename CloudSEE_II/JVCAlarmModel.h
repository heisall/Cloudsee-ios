//
//  JVCAlarmModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//
enum AlarmPlan
{
    AlarmPlan_YST       = 0,//云视通方案
    AlarmPlan_Cloud     = 1,//云存储方案
    AlarmPlan_FTP       = 2,//ftp方案

};
#import <Foundation/Foundation.h>

@interface JVCAlarmModel : NSObject
{
    
    NSString *strAlarmGuid;             //每一条报警的唯一标示符
    int iAlarmPlanType;                     //报警的方案
    NSString *strYstNumber;             //报警的云通号
    NSString *strALarmDeviceNickName;   //设备的昵称
    int iYstChannel;                    //通道
    int iAlarmLevel;                     //报警的级别
    NSString *strAlarmTime;             //报警的时间
    NSString *strAlarmPicUrl;           //报警图片的URL
    NSString *strAlarmMsgNickname;      //设备的报警昵称 11 的时候用

    NSString *strAlarmVideoUrl;         //报警视频的URL
    NSString *strAlarmLocalVideoUrl;    //报警视频的本地URL
    BOOL iFlag;                         //YES:已读 NO:未读
    NSString *strAlarmLocalPicURL;      //缓存本地报警图片的URL
    BOOL isDownLoad;                    //YES:正在加载图片和视频 NO:加载完成
    int iAlarmTimer;                    //时间截
    int iAlarmType;                     //报警类别
    BOOL bNewAlarm;                      //是否是新报警

}
@property(nonatomic,retain)NSString *strAlarmMsgNickname;
@property(nonatomic,retain)NSString  *strAlarmGuid;
@property(nonatomic,retain)NSString  *strYstNumber;
@property(nonatomic,assign)int iYstChannel;
@property(nonatomic,assign)int iAlarmType;
@property(nonatomic,assign)int iAlarmPlanType;
@property(nonatomic,assign)int iAlarmLevel;
@property(nonatomic,assign)    int iAlarmTimer;                    //时间截
@property(nonatomic,retain)NSString  *strAlarmTime;
@property(nonatomic,retain)NSString  *strAlarmPicUrl;
@property(nonatomic,retain)NSString  *strAlarmVideoUrl;
@property(nonatomic,retain)NSString  *strAlarmLocalVideoUrl;
@property(nonatomic,assign)BOOL iFlag;
@property(nonatomic,retain)NSString  *strAlarmLocalPicURL;
@property(nonatomic,retain)NSString  *strALarmDeviceNickName;
@property(nonatomic,assign)BOOL isDownLoad;
@property(nonatomic,assign)BOOL bNewAlarm;


/**
 *  根据字典初始化报警对象
 *
 *  @param dic 数据
 *
 *  @return 报警对象
 */
- (id)initAlarmModelWithDictionary:(NSDictionary *)dic;
@end
