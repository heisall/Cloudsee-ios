//
//  JVCLockAlarmModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JVCAlarmLockType) {
    JVCAlarmLockType_Door       = 0,
    JVCAlarmLockType_Bracelet   = 1,
};

@interface JVCLockAlarmModel : NSObject
{
    NSString    *alarmGuid;//唯一标示
    int         alarmType;//类型  门磁、手环
    NSString    *alarmName;//昵称
    BOOL        *alarmState;//开关的专题爱
}
@property(nonatomic,assign) int         alarmType;
@property(nonatomic,assign) BOOL        *alarmState;

@property(nonatomic,retain) NSString    *alarmGuid;
@property(nonatomic,retain) NSString    *alarmName;

@end
