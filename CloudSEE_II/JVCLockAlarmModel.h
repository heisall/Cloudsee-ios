//
//  JVCLockAlarmModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JVCAlarmLockType) {
    JVCAlarmLockType_Door       = 1,
    JVCAlarmLockType_Bracelet   = 2,
};

@interface JVCLockAlarmModel : NSObject
{
    int         alarmGuid;//唯一标示
    int         alarmType;//类型  门磁、手环
    NSString    *alarmName;//昵称
    BOOL        alarmState;//开关的
    int         alarmRes;
}
@property(nonatomic,assign) int         alarmType;
@property(nonatomic,assign) BOOL        alarmState;
@property(nonatomic,assign) int         alarmRes;
@property(nonatomic,assign) int         alarmGuid;
@property(nonatomic,retain) NSString    *alarmName;

/**
 *  根据字典初始化报警对象
 *
 *  @param dic 数据
 *
 *  @return 报警对象
 */
- (id)initAlarmLockModelWithDictionary:(NSDictionary *)dic;

@end
