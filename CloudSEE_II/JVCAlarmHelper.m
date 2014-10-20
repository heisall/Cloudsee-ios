//
//  JVCAlarmHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmHelper.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceMacro.h"
#import "JVCAlarmMacro.h"
#import "JVCAlarmModel.h"
#import "JVCSystemUtility.h"

@implementation JVCAlarmHelper

static JVCAlarmHelper *shareAlarmHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCAlarmHelper *)shareAlarmHelper
{
    @synchronized(self)
    {
        if (shareAlarmHelper == nil) {
            
            shareAlarmHelper = [[self alloc] init];
        }
        
        return shareAlarmHelper;
    }
    
    return shareAlarmHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAlarmHelper == nil) {
            
            shareAlarmHelper = [super allocWithZone:zone];
            
            return shareAlarmHelper;
        }
    }
    
    return nil;
}

/**
 *  获取报警历史
 *
 *  @param index 起始位置  index 开始位置 结束位置：index+JK_ALARM_LISTCOUNT（4）
 */
- (NSMutableArray  *)getAlarmHistoryList:(int)index
{
    NSMutableArray *arrayArarmList = [NSMutableArray array];
    /**
     *  放到异步线程里面
     */
    id result =  [[JVCDeviceHelper sharedDeviceLibrary]getAccountByDeviceAlarmList:index];
    
    if ([result isKindOfClass:[NSDictionary class]]) {//是字典类型的
        
        NSDictionary *resultDic = (NSDictionary *)result;
        
        if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resultDic]) {//成功
            
            NSArray *arrayList = [resultDic objectForKey:JK_ALARM_INFO];
            
            for (NSDictionary *tdic in arrayList) {
                
                JVCAlarmModel *model = [[JVCAlarmModel alloc] initAlarmModelWithDictionary:tdic];
                
                [arrayArarmList addObject:model];
                
                [model release];
            }
        }
    }
    
    return arrayArarmList;

}

/**
 *  获取报警历史
 *
 *  @param index 起始位置  index 开始位置 结束位置：index+JK_ALARM_LISTCOUNT（4）
 */
- (NSMutableArray  *)getHistoryAlarm:(int)index
{
    NSMutableArray *arrayArarmList = [NSMutableArray array];
    /**
     *  放到异步线程里面
     */
    id result =  [[JVCDeviceHelper sharedDeviceLibrary]getAccountByDeviceAlarmList:index];
    
    if ([result isKindOfClass:[NSDictionary class]]) {//是字典类型的
        
        NSDictionary *resultDic = (NSDictionary *)result;
        
        if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resultDic]) {//成功
            
            NSArray *arrayList = [resultDic objectForKey:JK_ALARM_INFO];
            
            for (NSDictionary *tdic in arrayList) {
                
                JVCAlarmModel *model = [[JVCAlarmModel alloc] initAlarmModelWithDictionary:tdic];
                
                [arrayArarmList addObject:model];
                
                [model release];
            }
        }
    }
    
    return arrayArarmList;
    
}

/**
 *  删除报警信息
 *
 *  @param deviceGuid 报警的32位唯一标识
 *
 *  @return yes 成功  no 失败
 */
- (BOOL)deleteAlarmHistoryWithGuid:(NSString *)deviceGuid
{
    id result =  [[JVCDeviceHelper sharedDeviceLibrary]deleteAlarmHorisyWithIndex:deviceGuid];
    
    if ([result isKindOfClass:[NSDictionary class]]) {//是字典类型的
        
        NSDictionary *resultDic = (NSDictionary *)result;
        
        if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resultDic]) {//成功
            
            return YES;
        }
    }
        return NO;
}

@end
