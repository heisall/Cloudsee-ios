//
//  JVCOperationDeviceAlarmTimerViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCCustomDatePickerView.h"

@protocol JVCOperationDeviceAlarmDelete <NSObject>

/**
 *  代理
 *
 *  @param startTimer 开始时间
 *  @param endTimer   结束时间
 */
- (void)jvcOperationDevieAlarmStartTimer:(NSString *)startTimer  endTimer:(NSString *)endTimer;

@end

@interface JVCOperationDeviceAlarmTimerViewController : JVCBaseWithGeneralViewController <JVCCustomDatePickerViewDelegate>
{
    NSString *alarmStartTimer; //开始时间
    NSString *alarmEndTimer;   //结束时间
    
    id<JVCOperationDeviceAlarmDelete>delegateAlarm;
    
}
@property(nonatomic,retain)NSString *alarmStartTimer;//开始时间
@property(nonatomic,retain) NSString *alarmEndTimer;//结束时间
@property(nonatomic,assign)id<JVCOperationDeviceAlarmDelete>delegateAlarm;

/**
 *  设置按钮的标题
 */
- (void)setBtnsTitles;
@end
