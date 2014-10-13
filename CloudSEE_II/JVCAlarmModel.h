//
//  JVCAlarmModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAlarmModel : NSObject
{
    NSString *strALarmDeviceNickName;   //设备的昵称
    BOOL bNewAlarmFlag;                 //新设备的标识   yes：新设备  no 老设备
    int  iAlarmType;                    //报警类型
}
@property(nonatomic,assign)BOOL bNewAlarmFlag;
@property(nonatomic,assign)int  iAlarmType;
@property(nonatomic,retain)NSString *strALarmDeviceNickName;
@end
