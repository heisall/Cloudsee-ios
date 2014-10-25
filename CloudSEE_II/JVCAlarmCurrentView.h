//
//  JVCAlarmCurrentView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

//enum
//{
//    ALARM_MOTIONDETECT = 7,//移动检测
//    ALARM_DOOR = 11,//门磁手环报警
//
//};

enum  {

    AlarmType_Close = 0,//关闭
    AlarmType_Watch = 1,//查看
};

@class JVCAlarmModel;

@protocol JVCAlarmAlarmDelegate <NSObject>

/**
 *  返回用户的选择
 *
 *  @param result 用户选择
 */
- (void)JVCAlarmAlarmCallBack:(JVCAlarmModel*)AlarmModel;

@end

@interface JVCAlarmCurrentView : UIView
{
    id<JVCAlarmAlarmDelegate>AlarmDelegate;
    
    BOOL bShowState;
    
    BOOL bIsInPlay;//是不是再播放界面
}
@property(nonatomic,assign)id<JVCAlarmAlarmDelegate>AlarmDelegate;
@property(nonatomic,assign) BOOL bShowState;
@property(nonatomic,assign) BOOL bIsInPlay;
/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCAlarmCurrentView *)shareCurrentAlarmInstance;

- (void)initCurrentAlarmView:(JVCAlarmModel *)alarmModel;
@end
